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
    print("Whoa! You can't robot instructions outside of the rules section!")
}

public var goNorth : () -> () = errorFunc
public var goWest  : () -> () = errorFunc

public var rules : () -> () = {}

public func run(afterEach: () -> () = {}, completion: () -> () = {} ) {
    
    let queue = dispatch_queue_create("instructionsQueue", DISPATCH_QUEUE_SERIAL)
    var canceled = false
    
    func dispatchFailableBlock(block: () -> Bool) {
        let block = {
            if canceled { return }
            let success = block()
            if !success {
                canceled = true
            }
        }
        dispatch_async(queue, block)
        dispatch_async(queue, {
            if canceled { return }
            dispatch_sync(dispatch_get_main_queue(), {
                view.setNeedsDisplay()
            })
            afterEach()
        })
        dispatch_async(queue, {
            if canceled { return }
            NSThread.sleepForTimeInterval(0.1)
        })
    }
    
    goNorth = {
        dispatchFailableBlock({
            return currentMap.move(.North)
        })
    }
    
    goWest = {
        dispatchFailableBlock({
            return currentMap.move(.West)
        })
    }
    
    defer {
        goNorth = errorFunc
        goWest  = errorFunc
    }
    
    rules()
    
    dispatch_async(queue, completion)
    
}

public func setup() {
    XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
    XCPlaygroundPage.currentPage.liveView = view
}