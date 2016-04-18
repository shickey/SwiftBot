import UIKit
import XCPlayground

let DEBUG = true

var levels : [Level] = ({
    var lineMap = Map(mapString: "WWW\nW W\nW W\nW W\nW W\nWWW")
    var line = Level(map: lineMap, startingLocation: Point(1, 4))
    
    var leftMap = Map(mapString: "WWWWW\nW   W\nWWW W\nWWW W\nWWWWW");
    var left = Level(map: leftMap, startingLocation: Point(3, 3))
    
    var donutMap = Map(mapString: "WWWWWWW\nW     W\nW WWW W\nW WWW W\nW WWW W\nW     W\nWWWWWWW")
    var donut = Level(map:donutMap, startingLocation: Point(5, 5));
    donut.options.smokeTrailsEnabled = true
    
    var square = Level(map: Map(size: Size(10, 10)), startingLocation: Point(1, 8))
    
    var maze = Level(map: Map(mapString: "WWWWWWWWWWWWWWWWWWWWWWWWW\nW  W W   W   W   W   WW W\nWW W W W W W W W   W    W\nWW W WWW W W W WWWWWWWW W\nW  W     W W W   W    W W\nW WWW WWWW W W W W WW   W\nW          W W W W WWWWWW\nWWWWWWWWWWWW WWW W  W   W\nW  W   W   W   W WW W WWW\nWW W W   W W WWW  W W   W\nWW W WWWWW W W W WW W W W\nWW W     W   W    W WWW W\nWW WWWWW WW WWWWW W     W\nW      W WW     W WWW W W\nW WWWWWW W  WWW W   W W W\nW        W WW W WWW W W W\nWWWWWWWWWW W  W   W W W W\nW    W   WWW WWWW W W W W\nW WW W W        W W WWW W\nW  W W WWWWW WW W W W W W\nW WW W W W   W  W   W   W\nW W  W W   WWW WWWWWWW WW\nW WWWW W W   W W     W WW\nW      W WWW W   WWW   WW\nWWWWWWWWWWWWWWWWWWWWWWWWW"))
    
    return [line, left, donut, square, maze]
})()

public var currentLevel = levels[0]

public var view : RobotView!


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
    var frames : ExecutionFrame! = nil
    
    func addFrame(frame: ExecutionFrame) {
        if frames == nil {
            frames = frame
        }
        else {
            frames.append(frame)
        }
    }
    
    canGoForward = {
        if encounteredError { return false }
        let frame = ExecutionFrame(instruction: .CanGoForward)
        let result = executeFrameOnLevel(frame, level: levelCopy)
        addFrame(frame)
        return result.sensingResult!
    }
    
    goForward = {
        if encounteredError { return }
        let frame = ExecutionFrame(instruction: .GoForward)
        let result = executeFrameOnLevel(frame, level: levelCopy)
        addFrame(ExecutionFrame(instruction: .GoForward))
        if !result.success {
            encounteredError = true
        }
    }
    
    turnLeft = {
        if encounteredError { return }
        let frame = ExecutionFrame(instruction: .TurnLeft)
        let result = executeFrameOnLevel(frame, level: levelCopy)
        addFrame(frame)
    }
    
    senseCookie = {
        if encounteredError { return false }
        let frame = ExecutionFrame(instruction: .SenseCookie)
        let result = executeFrameOnLevel(frame, level: levelCopy)
        addFrame(frame)
        return result.sensingResult!
    }
    
    placeCookie = {
        if encounteredError { return }
        let frame = ExecutionFrame(instruction: .PlaceCookie)
        let result = executeFrameOnLevel(frame, level: levelCopy)
        addFrame(ExecutionFrame(instruction: .PlaceCookie))
        if !result.success {
            encounteredError = true
        }
    }
    
    pickupCookie = {
        if encounteredError { return }
        let frame = ExecutionFrame(instruction: .PickupCookie)
        let result = executeFrameOnLevel(frame, level: levelCopy)
        addFrame(ExecutionFrame(instruction: .PickupCookie))
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
        var framesToPrint = frames
        while framesToPrint != nil {
            print("    " + functionNameForInstruction(framesToPrint.instruction))
            framesToPrint = framesToPrint.next
        }
        print()
        print("Final Level State:\n")
        print(levelCopy) // Print final state of map for debugging
        print()
    }
    
    var currentFrame : ExecutionFrame? = frames
    
    let timer = CFRunLoopTimerCreateWithHandler(nil, CFAbsoluteTimeGetCurrent() + currentLevel.options.animationInterval, currentLevel.options.animationInterval, 0, 0, { (timer) in
        if let frame = currentFrame {
            let result = executeFrameOnLevel(frame, level: currentLevel)
            if result.error != nil {
                switch result.error! {
                case .CannotMoveIntoWall:
                    print("ERROR: SwiftBot cannot move into a wall!")
                case .NoCookieToPickup:
                    print("ERROR: There's no cookie for SwiftBot to pickup!")
                case .CannotStackCookies:
                    print("ERROR: UNSTABLE COOKIE STACK! SwiftBot can place a cookie on another cookie!")
                }
            }
            
            if DEBUG {
                print(frame)
                print(result)
            }
            
            view.setNeedsDisplay()
            currentFrame = frame.next
        }
        else {
            CFRunLoopTimerInvalidate(timer)
            
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
    
    view = RobotView(frame: CGRectMake(0, 0, CGFloat(mapSize.width) * multiplier, CGFloat(mapSize.height) * multiplier))
    view.level = currentLevel
    
    XCPlaygroundPage.currentPage.liveView = view
}

func tearDown() {
    XCPlaygroundPage.currentPage.finishExecution()
}