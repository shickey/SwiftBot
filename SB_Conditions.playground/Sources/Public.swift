import UIKit
import XCPlayground

let DEBUG = false

var levels : [Level] = ({

    var lineMap = Map(mapString: "WWWWWWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWWWWWW")
    
    
    
    
    var conditionalsCookies : Set<Cookie> = ({
        
        var cookies : Set<Cookie> = [
            Cookie(3, 1),
            Cookie(3, 2),
            Cookie(3, 3),
            Cookie(3, 4)
        ]
        
        let numCookiesToDelete = arc4random_uniform(UInt32(5))
        
        for _ in 0..<numCookiesToDelete {
            var indexToDelete = arc4random_uniform(UInt32(cookies.count))
            cookies.removeAtIndex(cookies.startIndex.advancedBy(Int(indexToDelete)))
        }
        
        return cookies
        
    })()
    var conditionals = Level(map: lineMap, startingLocation: Point(3, 4))
    conditionals.cookies = conditionalsCookies
    conditionals.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.cookies.count > 0 {
            valid = false
            errors.append("There are still cookies on the floor!")
        }
        if level.robot.location != Point(3, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
        
    }
    
    
    var invert = Level(map:lineMap, startingLocation: Point(3, 4))
    invert.cookies = conditionalsCookies
    invert.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        
        var allCookies : Set<Cookie> = [
            Cookie(3, 1),
            Cookie(3, 2),
            Cookie(3, 3),
            Cookie(3, 4)
        ]
        
        if !level.cookies.isDisjointWith(conditionalsCookies) {
            valid = false
            errors.append("Some of the original cookies are on the floor")
        }
        
        if !(level.cookies.union(conditionalsCookies) == allCookies) {
            valid = false
            errors.append("Some of the cookies weren't inverted properly")
        }
        
        
        
        if level.robot.location != Point(3, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
    }
    
    var randomLengthHallwayMapString : String = ({
        
        var str = "WWWWWWW\nWWW WWW\n"
        
        var rows = arc4random_uniform(UInt32(8))
        for _ in 0..<rows {
            str += "WWW WWW\n"
        }
        
        str += "WWW WWW\nWWWWWWW"
        return str
        
    })()
    let randomHallwayMap = Map(mapString:randomLengthHallwayMapString)
    let randomHallway = Level(map: randomHallwayMap, startingLocation: Point(3, randomHallwayMap.size.height - 2))
    randomHallway.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.robot.location != Point(3, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if level.cookies.count == 0 || !level.cookies.contains(Cookie(3, 1)) {
            valid = false
            errors.append("There is no cookie at the end of the hallway")
        }
        else if level.cookies.count > 1 {
            valid = false
            errors.append("There are too many cookies on the floor")
        }
        
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
    }
    
    
    
    var randomInvertMap = Map(mapString:randomLengthHallwayMapString)
    var randomInvertCookies : Set<Cookie> = ({
        
        var cookies : Set<Cookie> = []
        
        for i in 1...randomInvertMap.size.height - 2 {
            cookies.insert(Cookie(3, i))
        }
        
        let numCookiesToDelete = arc4random_uniform(UInt32(randomInvertMap.size.height - 2))
        
        for _ in 0..<numCookiesToDelete {
            var indexToDelete = arc4random_uniform(UInt32(cookies.count))
            cookies.removeAtIndex(cookies.startIndex.advancedBy(Int(indexToDelete)))
        }
        
        return cookies
        
    })()
    let randomInvert = Level(map: randomInvertMap, startingLocation: Point(3, randomHallwayMap.size.height - 2))
    randomInvert.cookies = randomInvertCookies
    randomInvert.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        
        var allCookies : Set<Cookie> = []
        
        for i in 1...randomInvertMap.size.height - 2 {
            allCookies.insert(Cookie(3, i))
        }
        
        if !level.cookies.isDisjointWith(randomInvertCookies) {
            valid = false
            errors.append("Some of the original cookies are on the floor")
        }
        
        if !(level.cookies.union(randomInvertCookies) == allCookies) {
            valid = false
            errors.append("Some of the cookies weren't inverted properly")
        }
        
        
        
        if level.robot.location != Point(3, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
    }
    
    
    
    
    var maze = Level(map: Map(mapString: "WWWWWWWWWWWWWWWWWWWWWWWWW\nW  W W   W   W   W   WW W\nWW W W W W W W W   W    W\nWW W WWW W W W WWWWWWWW W\nW  W     W W W   W    W W\nW WWW WWWW W W W W WW   W\nW          W W W W WWWWWW\nWWWWWWWWWWWW WWW W  W   W\nW  W   W   W   W WW W WWW\nWW W W   W W WWW  W W   W\nWW W WWWWW W W W WW W W W\nWW W     W   W    W WWW W\nWW WWWWW WW WWWWW W     W\nW      W WW     W WWW W W\nW WWWWWW W  WWW W   W W W\nW        W WW W WWW W W W\nWWWWWWWWWW W  W   W W W W\nW    W   WWW WWWW W W W W\nW WW W W        W W WWW W\nW  W W WWWWW WW W W W W W\nW WW W W W   W  W   W   W\nW W  W W   WWW WWWWWWW WW\nW WWWW W W   W W     W WW\nW      W WWW W   WWW   WW\nWWWWWWWWWWWWWWWWWWWWWWWWW"))
    
    return [conditionals, invert, randomHallway, randomInvert]
})()

public var currentLevel = levels[0]

public var robotView : RobotView!
public var textView : UITextView!


let errorFunc = {
    print("Whoa! You can't use robot instructions outside of the instructions section!")
}

let errorFuncReturningBool = { () -> Bool in
    print("Whoa! You can't use robot instructions outside of the instructions section!")
    return false
}

public var canGoForward : () -> Bool = errorFuncReturningBool
public var goForward : () -> () = errorFunc
public var turnLeft : () -> () = errorFunc
public var senseCookie : () -> Bool = errorFuncReturningBool
public var placeCookie : () -> () = errorFunc
public var pickupCookie : () -> () = errorFunc

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
    
    let levelCopy = currentLevel.copy()
    var encounteredError = false
    var executionStack = ExecutionStack()
    
    canGoForward = {
        if encounteredError { return false }
        let frame = ExecutionFrame(.CanGoForward)
        let result = executeFrameOnLevel(frame, levelCopy)
        appendFrameToStack(frame, executionStack)
        return result.sensingResult!
    }
    
    goForward = {
        if encounteredError { return }
        let frame = ExecutionFrame(.GoForward)
        let result = executeFrameOnLevel(frame, levelCopy)
        appendFrameToStack(ExecutionFrame(.GoForward), executionStack)
        if !result.success {
            encounteredError = true
        }
    }
    
    turnLeft = {
        if encounteredError { return }
        let frame = ExecutionFrame(.TurnLeft)
        let result = executeFrameOnLevel(frame, levelCopy)
        appendFrameToStack(frame, executionStack)
    }
    
    senseCookie = {
        if encounteredError { return false }
        let frame = ExecutionFrame(.SenseCookie)
        let result = executeFrameOnLevel(frame, levelCopy)
        appendFrameToStack(frame, executionStack)
        return result.sensingResult!
    }
    
    placeCookie = {
        if encounteredError { return }
        let frame = ExecutionFrame(.PlaceCookie)
        let result = executeFrameOnLevel(frame, levelCopy)
        appendFrameToStack(ExecutionFrame(.PlaceCookie), executionStack)
        if !result.success {
            encounteredError = true
        }
    }
    
    pickupCookie = {
        if encounteredError { return }
        let frame = ExecutionFrame(.PickupCookie)
        let result = executeFrameOnLevel(frame, levelCopy)
        appendFrameToStack(ExecutionFrame(.PickupCookie), executionStack)
        if !result.success {
            encounteredError = true
        }
    }
    
    defer {
        canGoForward = errorFuncReturningBool
        goForward = errorFunc
        turnLeft = errorFunc
        senseCookie = errorFuncReturningBool
        placeCookie = errorFunc
    }
    
    instructions()
    
    if DEBUG {
        print("Execution log:")
        var frameToPrint = executionStack.first
        while frameToPrint != nil {
            print("    " + functionNameForInstruction(frameToPrint.instruction))
            frameToPrint = frameToPrint.next
        }
        print("")
        print("Final Level State:\n")
        print(levelCopy) // Print final state of map for debugging
        print("")
    }
    
    var currentFrame = executionStack.first
    
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
            
            if executionStack.first != nil && !generatedError {
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