import Foundation
import Dispatch
import Darwin


func goRight() {
    turnLeft()
    turnLeft()
    turnLeft()
}


func goLeft(){
    turnLeft()
    turnLeft()
}

func clean() {
    pickupCookie()
    goRight()
    while canGoForward() {
        goForward()
        goRight()
        pickupCookie()
        goForward()
        turnLeft()
        pickupCookie()
    }
}

func place() {
    placeCookie()
    while canGoForward() {
        goForward()
        goRight()
        placeCookie()
        goForward()
        turnLeft()
        placeCookie()
    }
}


func diag2() {
    while !senseCookie() {
        turnLeft()
        goForward()
        goRight()
        goForward()
    }
    if senseCookie(){
        pickupCookie()
        goLeft()
        placeCookie()
        while canGoForward (){
            goForward()
        }
        placeCookie()
    }
}



func leftCorner() {
    goRight()
    while canGoForward() {
        goForward()
    }
}



func oneCommand() {
    place()
    goLeft()
    while canGoForward() {
        goForward()
    }
    goLeft()
    diag2()
    leftCorner()
    clean()
}




var instructions = {
    oneCommand()
}



var semaphore = dispatch_semaphore_create(1)

var numInstructions : [Int] = []

for (index, level) in levels.enumerate() {
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    
    buildExecutionQueueInBackground(level, instructions, { (executionQueue) in
        let mapSize = level.map.size.width
        
        var frame = executionQueue.first
        while frame != nil {
            executeFrameOnLevel(frame, level)
            frame = frame.next
        }
        let (valid, _) = validateLevel(level)
        if valid {
            print("✅MAP SIZE \(mapSize - 2): PASS")
            print("   Robot executed \(executionQueue.count) commands")
            numInstructions.append(executionQueue.count)
        }
        else {
            print("❌MAP SIZE \(mapSize - 2): FAIL")
        }
        
        if index == levels.count - 1 {
            for num in numInstructions {
                print(num)
            }
            exit(0)
        }
        
        }, {
            dispatch_semaphore_signal(semaphore)
    })
    
    
}

NSRunLoop.currentRunLoop().run()

