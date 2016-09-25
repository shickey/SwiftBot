import Foundation
import Dispatch
import Darwin


func reachend(){
    while canGoForward(){
        goForward()
    }
}

func turnright(){
    turnLeft()
    turnLeft()
    turnLeft()
}

func turnaround(){
    turnLeft()
    turnLeft()
}


func spiral(){
    
    while canGoForward(){
        goForward()
        if !senseCookie(){
            if !canGoForward(){
                turnright()
                goForward()
                placeCookie()
                goForward()
            }
        }
        if senseCookie(){
            pickupCookie()
            turnaround()
            goForward()
            turnLeft()
            goForward()
            if !senseCookie(){
                placeCookie()
            }
            else{
                pickupCookie()
                turnaround()
                goForward()
                turnLeft()
                goForward()
                if !senseCookie(){
                    placeCookie()
                }
                else{
                    pickupCookie()
                    while canGoForward(){
                        goForward()
                        if !canGoForward(){
                            placeCookie()
                            turnaround()
                            goForward()
                            while !senseCookie(){
                                goForward()
                            }
                            pickupCookie()
                            reachend()
                        }
                    }
                }
            }
        }
        
    }
}

var instructions = {
    // METHOD 3
    
    placeCookie()
    goForward()
    spiral()
    
    // this specific code only works on odd number squres, it is possible to make it work on even number squares as well.
}

var numFinished = 0

for (index, level) in levels.enumerate() {
    
    buildExecutionQueueInBackground(level, instructions, { (executionQueue, finalLevel, success) in
        let mapSize = finalLevel.map.size.width

        if success {
            print("✅MAP SIZE \(mapSize - 2): PASS")
            print("   Robot executed \(executionQueue.count) commands")
        }
        else {
            print("❌MAP SIZE \(mapSize - 2): FAIL")
        }
        
        numFinished += 1
        if numFinished == levels.count {
            exit(0)
        }
        
    })
    
}

NSRunLoop.currentRunLoop().run()

