import UIKit
import XCPlayground
import Dispatch

var maps : [Map] = ({
    var square = Map(size: Size(20, 20))
    var maze = Map(mapString: "WWWWWWWWWWWWWWWWWWWWWWWWW\nW  W W   W   W   W   WW W\nWW W W W W W W W   W    W\nWW W WWW W W W WWWWWWWW W\nW  W     W W W   W    W W\nW WWW WWWW W W W W WW   W\nW          W W W W WWWWWW\nWWWWWWWWWWWW WWW W  W   W\nW  W   W   W   W WW W WWW\nWW W W   W W WWW  W W   W\nWW W WWWWW W W W WW W W W\nWW W     W   W    W WWW W\nWW WWWWW WW WWWWW W     W\nW      W WW     W WWW W W\nW WWWWWW W  WWW W   W W W\nW        W WW W WWW W W W\nWWWWWWWWWW W  W   W W W W\nW    W   WWW WWWW W W W W\nW WW W W        W W WWW W\nW  W W WWWWW WW W W W W W\nW WW W W W   W  W   W   W\nW W  W W   WWW WWWWWWW WW\nW WWWW W W   W W     W WW\nW      W WWW W   WWW   WW\nWWWWWWWWWWWWWWWWWWWWWWWWW")
    return [square, maze]
})()

public var currentMap = maps[0]

public var view : RobotView = ({
    let view = RobotView(frame: CGRectMake(0, 0, 300.0, 300.0))
    view.map = currentMap
    return view
})()

let errorFunc = {
    print("Whoa! You can't use robot instructions outside of the rules section!")
}

public var canGoNorth : () -> Bool = { return false }
public var goNorth : () -> () = errorFunc
public var goWest  : () -> () = errorFunc

public var instructions : () -> () = {}

public func run(completion: (() -> ())? = nil, afterEach: (() -> ())? = nil) {
    
    var mapCopy = currentMap.copy()
    var encounteredError = false
    var moves : [() -> ()] = []
    
    canGoNorth = {
        if encounteredError { return false }
        return mapCopy.canMove(.North)
    }
    
    goNorth = {
        if encounteredError { return }
        let success = mapCopy.move(.North)
        if success {
            moves.append({
                currentMap.move(.North)
            })
        }
        else {
            encounteredError = true
            return
        }
    }
    
    defer {
        canGoNorth = { return false }
        goNorth = errorFunc
    }
    
    instructions()
    
    let queue = dispatch_queue_create("instructionsQueue", DISPATCH_QUEUE_SERIAL)
    
    for clo in moves {
        let block = {
            clo()
            dispatch_sync(dispatch_get_main_queue(), {
                view.setNeedsDisplay()
            })
            if let afterEachBlock = afterEach {
                dispatch_sync(dispatch_get_main_queue(), afterEachBlock)
            }
        }
        dispatch_async(queue, block)
        dispatch_async(queue, {
            NSThread.sleepForTimeInterval(0.1)
        })
    }
    
    if let completionBlock = completion {
        dispatch_async(queue, {
            dispatch_sync(dispatch_get_main_queue(), completionBlock)
        })
    }
    
    
}

public func setup() {
    XCPlaygroundPage.currentPage.liveView = view
}