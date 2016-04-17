import UIKit
import XCPlayground

var levels : [Level] = ({
    var lineMap = Map(mapString: "WWW\nW W\nW W\nW W\nW W\nWWW")
    var line = Level(map: lineMap, startingLocation: Point(1, 4))
    
    var leftMap = Map(mapString: "WWWWW\nW   W\nWWW W\nWWW W\nWWWWW");
    var left = Level(map: leftMap, startingLocation: Point(3, 3))
    
    var donutMap = Map(mapString: "WWWWWWW\nW     W\nW WWW W\nW WWW W\nW WWW W\nW     W\nWWWWWWW")
    var donut = Level(map:donutMap, startingLocation: Point(5, 5));
    
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
        _instructions = newInstructions
        run()
    }
}


public func run(completion: (() -> ())? = nil, afterEach: (() -> ())? = nil) {
    
    let levelCopy = currentLevel.copy()
    var encounteredError = false
    var moves : [() -> ()] = []
    
    canGoForward = {
        if encounteredError { return false }
        return canMoveRobot(levelCopy)
    }
    
    goForward = {
        if encounteredError { return }
        let success = moveRobot(levelCopy)
        if success {
            moves.append({
                moveRobot(currentLevel)
            })
        }
        else {
            encounteredError = true
            return
        }
    }
    
    turnLeft = {
        if encounteredError { return }
        turnRobotLeft(levelCopy)
        moves.append({
            turnRobotLeft(currentLevel)
        })
    }
    
    senseCookie = {
        if encounteredError { return false }
        return robotSenseCookie(levelCopy)
    }
    
    placeCookie = {
        if encounteredError { return }
        let success = robotPlaceCookie(levelCopy)
        if success {
            moves.append({
                robotPlaceCookie(currentLevel)
            })
        }
        else {
            encounteredError = true
            return
        }
    }
    
    pickupCookie = {
        if encounteredError { return }
        let success = robotPickupCookie(levelCopy)
        if success {
            moves.append({
                robotPickupCookie(currentLevel)
            })
        }
        else {
            encounteredError = true
            return
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
    
    if let nonNilCompletion = completion {
        moves.append(nonNilCompletion)
    }
    
    var moveNumber = 0;
    
    let timer = CFRunLoopTimerCreateWithHandler(nil, CFAbsoluteTimeGetCurrent() + currentLevel.options.animationInterval, currentLevel.options.animationInterval, 0, 0, { (timer) in
        if moveNumber < moves.count {
            moves[moveNumber]()
            view.setNeedsDisplay()
            if let nonNilAfterEach = afterEach {
                nonNilAfterEach()
            }
            moveNumber = moveNumber + 1
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