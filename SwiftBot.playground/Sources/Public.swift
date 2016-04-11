import UIKit
import XCPlayground

let ANIMATION_INTERVAL = 0.25

var maps : [Map] = ({
    var line = Map(mapString: "WWW\nW W\nW W\nW W\nW W\nWWW", startingLocation: Point(1, 4))
    var simple = Map(mapString: "WWWWW\nW   W\nWWW W\nWWW W\nWWWWW", startingLocation: Point(3, 3))
    var square = Map(size: Size(20, 20))
    var maze = Map(mapString: "WWWWWWWWWWWWWWWWWWWWWWWWW\nW  W W   W   W   W   WW W\nWW W W W W W W W   W    W\nWW W WWW W W W WWWWWWWW W\nW  W     W W W   W    W W\nW WWW WWWW W W W W WW   W\nW          W W W W WWWWWW\nWWWWWWWWWWWW WWW W  W   W\nW  W   W   W   W WW W WWW\nWW W W   W W WWW  W W   W\nWW W WWWWW W W W WW W W W\nWW W     W   W    W WWW W\nWW WWWWW WW WWWWW W     W\nW      W WW     W WWW W W\nW WWWWWW W  WWW W   W W W\nW        W WW W WWW W W W\nWWWWWWWWWW W  W   W W W W\nW    W   WWW WWWW W W W W\nW WW W W        W W WWW W\nW  W W WWWWW WW W W W W W\nW WW W W W   W  W   W   W\nW W  W W   WWW WWWWWWW WW\nW WWWW W W   W W     W WW\nW      W WWW W   WWW   WW\nWWWWWWWWWWWWWWWWWWWWWWWWW")
    return [line, simple, square, maze]
})()

public var currentMap = maps[0]

public var view : RobotView!


let errorFunc = {
    print("Whoa! You can't use robot instructions outside of the rules section!")
}

public var canGoForward : () -> Bool = { return false }
public var goForward : () -> () = errorFunc
public var turnLeft : () -> () = errorFunc
public var squaresLeftToExplore : () -> Bool = { return false }

public var instructions : () -> () = {}


public func run(completion: (() -> ())? = nil, afterEach: (() -> ())? = nil) {
    
    var mapCopy = currentMap.copy()
    var encounteredError = false
    var moves : [() -> ()] = []
    
    canGoForward = {
        if encounteredError { return false }
        return mapCopy.canMove()
    }
    
    goForward = {
        if encounteredError { return }
        let success = mapCopy.move()
        if success {
            moves.append({
                currentMap.move()
            })
        }
        else {
            encounteredError = true
            return
        }
    }
    
    turnLeft = {
        if encounteredError { return }
        mapCopy.turnLeft()
        moves.append({
            currentMap.turnLeft()
        })
    }
    
    squaresLeftToExplore = {
        if encounteredError { return false }
        return !mapCopy.isComplete()
    }
    
    defer {
        canGoForward = { return false }
        goForward = errorFunc
        turnLeft = errorFunc
        squaresLeftToExplore = { return false }
    }
    
    instructions()
    
    if let nonNilCompletion = completion {
        moves.append(nonNilCompletion)
    }
    
    moves.append({
        tearDown()
    })
    
    var moveNumber = 0;
    
    let timer = CFRunLoopTimerCreateWithHandler(nil, CFAbsoluteTimeGetCurrent() + ANIMATION_INTERVAL, ANIMATION_INTERVAL, 0, 0, { (timer) in
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
        }
    })
    
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
    
}

public func setup(page: Int = 0) {
    currentMap = maps[page]
    
    var multiplier : CGFloat = 100.0
    let mapSize = currentMap.size
    let maxDimension = max(mapSize.width, mapSize.height)
    if maxDimension > 5 {
        multiplier = 50.0
    }
    if maxDimension > 10 {
        multiplier = 25.0
    }
    
    view = RobotView(frame: CGRectMake(0, 0, CGFloat(mapSize.width) * multiplier, CGFloat(mapSize.height) * multiplier))
    view.map = currentMap
    
    XCPlaygroundPage.currentPage.liveView = view
}

func tearDown() {
    XCPlaygroundPage.currentPage.finishExecution()
}