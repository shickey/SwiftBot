import UIKit
import XCPlayground

let DEBUG = false

public var robotView : RobotView!
public var textView : UITextView!

var _instructions : () -> () = {}
public var instructions : () -> () {
    get {
        return _instructions
    }
    set(newInstructions) {
        _instructions = {
            newInstructions()
        }
        run()
    }
}


public func run() {
    
    buildExecutionQueueInBackground(currentLevel, instructions, { executionQueue in
        
//        if DEBUG {
//            print("Execution log:")
//            var frameToPrint = executionQueue.first
//            while frameToPrint != nil {
//                print("    " + functionNameForInstruction(frameToPrint.instruction))
//                frameToPrint = frameToPrint.next
//            }
//            print("")
//            print("Final Level State:\n")
//            print(levelCopy) // Print final state of map for debugging
//            print("")
//        }
        
        var currentFrame = executionQueue.first
        
        var generatedError = false
        
        let timer = CFRunLoopTimerCreateWithHandler(nil, CFAbsoluteTimeGetCurrent() + currentLevel.options.animationInterval, currentLevel.options.animationInterval, 0, 0, { (timer) in
            if let frame = currentFrame {
                if DEBUG {
                    var message = "Previous Instruction: "
                    if let p = frame.previous {
                        message += functionNameForInstruction(p.instruction)
                    }
                    else {
                        message += "(nil)"
                    }
                    message += "\nThis Instruction: " + functionNameForInstruction(frame.instruction) + "\n\n"
                    textView.text = message
                }
                let result = executeFrameOnLevel(frame, currentLevel)
                if result.error != nil {
                    generatedError = true
                    switch result.error! {
                    case .CannotMoveIntoWall:
                        if DEBUG {
                            print("ERROR: SwiftBot cannot move into a wall!")
                        }
                        textView.text = textView.text + "ERROR: SwiftBot cannot move into a wall!"
                        
                    case .NoCookieToPickup:
                        if DEBUG {
                            print("ERROR: There's no cookie for SwiftBot to pickup!")
                        }
                        textView.text = textView.text + "ERROR: There's no cookie for SwiftBot to pickup!"
                    case .CannotStackCookies:
                        if DEBUG {
                            print("ERROR: UNSTABLE COOKIE STACK! SwiftBot cannot place a cookie on another cookie!")
                        }
                        textView.text = textView.text + "ERROR: UNSTABLE COOKIE STACK! SwiftBot cannot place a cookie on another cookie!"
                    }
                }
                
                if DEBUG {
                    print(frame)
                    print(result)
                }
                
                robotView.setNeedsDisplay()
                currentFrame = frame.next
            }
            else {
                CFRunLoopTimerInvalidate(timer)
                
                if executionQueue.first != nil && !generatedError {
                    let (success, possibleErrors) = validateLevel(currentLevel)
                    if success {
                        textView.text = textView.text + "Complete!!!"
                    }
                    else {
                        let errors = possibleErrors!
                        var errorString = "Hmmm...not quite there yet:"
                        for error in errors {
                            errorString += "\n  - " + error
                        }
                        textView.text = textView.text + errorString
                    }
                }
                
                // TODO: This is kind of a hack-y way to make this work. Fix.
                // Call tearDown() after a 1 second pause to give the run loop enough
                // time to draw the final frame.
                let tearDownTimer = CFRunLoopTimerCreateWithHandler(nil, CFAbsoluteTimeGetCurrent() + 1.0, 0, 0, 0, { _ in
                    tearDown()
                })
                CFRunLoopAddTimer(CFRunLoopGetCurrent(), tearDownTimer, kCFRunLoopCommonModes)
            }
        })
        
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)

    
    })
    
}

public func setup(page: Int) {
    currentLevel = levels[page]
    
    var multiplier : CGFloat = 100.0
    let mapSize = currentLevel.map.size
    let maxDimension = max(mapSize.width, mapSize.height)

    if maxDimension > 5 {
        multiplier = 50.0
    }
    if maxDimension > 10 {
        multiplier = 25.0
    }
    
    robotView = RobotView(frame: CGRectMake(0, 0, CGFloat(mapSize.width) * multiplier, CGFloat(mapSize.height) * multiplier))
    robotView.level = currentLevel
    
    let textHeight : CGFloat = 100.0
    textView = UITextView(frame: CGRectMake(0, robotView.bounds.size.height, robotView.bounds.size.width, textHeight))
    textView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
    textView.textColor = UIColor(white:1.0, alpha: 1.0)
    textView.font = UIFont(name: "Menlo", size: 12.0)
    
    XCPlaygroundPage.currentPage.liveView = ({
        let viewFrame = CGRectMake(robotView.bounds.origin.x,
                                      robotView.bounds.origin.y,
                                      robotView.bounds.size.width,
                                      robotView.bounds.size.height + textHeight);
        let view = UIView(frame: viewFrame)
        view.addSubview(robotView)
        view.addSubview(textView)
        return view
    })()
}

func tearDown() {
    XCPlaygroundPage.currentPage.finishExecution()
}