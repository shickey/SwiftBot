import Foundation
import Dispatch

var maps : [Map] = ({
    var square = Map(size: Size(20, 20))
    var maze = Map(mapString: "WWWWWWWWWWWWWWWWWWWWWWWWW\nW  W W   W   W   W   WW W\nWW W W W W W W W   W    W\nWW W WWW W W W WWWWWWWW W\nW  W     W W W   W    W W\nW WWW WWWW W W W W WW   W\nW          W W W W WWWWWW\nWWWWWWWWWWWW WWW W  W   W\nW  W   W   W   W WW W WWW\nWW W W   W W WWW  W W   W\nWW W WWWWW W W W WW W W W\nWW W     W   W    W WWW W\nWW WWWWW WW WWWWW W     W\nW      W WW     W WWW W W\nW WWWWWW W  WWW W   W W W\nW        W WW W WWW W W W\nWWWWWWWWWW W  W   W W W W\nW    W   WWW WWWW W W W W\nW WW W W        W W WWW W\nW  W W WWWWW WW W W W W W\nW WW W W W   W  W   W   W\nW W  W W   WWW WWWWWWW WW\nW WWWW W W   W W     W WW\nW      W WWW W   WWW   WW\nWWWWWWWWWWWWWWWWWWWWWWWWW")
    return [square, maze]
})()

public var currentMap = maps[0]

let errorFunc = {
    print("Whoa! You can't robot instructions outside of the rules section!")
}

public var goNorth : () -> () = errorFunc

public var rules : () -> () = {}

public func run(completion: (() -> ()) = {} ) {
    
    let queue = dispatch_queue_create("instructionsQueue", DISPATCH_QUEUE_SERIAL)
    var canceled = false
    
    goNorth = {
        let block = {
            if canceled { return }
            let success = currentMap.move(.North)
            if !success {
                canceled = true
            }
        }
        dispatch_async(queue, block)
    }
    
    rules()
    
    dispatch_async(queue, completion)
    
    goNorth = errorFunc
}