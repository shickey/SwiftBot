import Foundation
import Dispatch

enum RobotInstruction {
    case CanGoForward
    case GoForward
    case TurnLeft
    case SenseCookie
    case PlaceCookie
    case PickupCookie
    case CanGoLeft
    case CanGoRight
}

func functionNameForInstruction(instruction: RobotInstruction) -> String {
    switch instruction {
    case .CanGoForward:
        return "canGoForward()"
    case .GoForward:
        return "goForward()"
    case .TurnLeft:
        return "turnLeft()"
    case .SenseCookie:
        return "senseCookie()"
    case .PlaceCookie:
        return "placeCookie()"
    case .PickupCookie:
        return "pickupCookie()"
    case .CanGoLeft:
        return "canGoLeft()"
    case .CanGoRight:
        return "canGoRight()"
    }
}

/*
 * Doubly linked list implementation of program execution states
 */

let MAX_QUEUE_COUNT = 10000

public class ExecutionQueue {
    var first : ExecutionFrame! = nil
    var last : ExecutionFrame! = nil
    var count : Int = 0
}

extension ExecutionQueue : CustomStringConvertible {
    public var description : String {
        var str = ""
        var currentFrame = first
        while currentFrame != nil {
            str += currentFrame.description
            str += "\n"
            currentFrame = currentFrame.next
        }
        return str
    }
}

func enqueueFrame(frame: ExecutionFrame, _ queue: ExecutionQueue) -> Bool {
    if queue.count > MAX_QUEUE_COUNT {
        print("TOO MANY INSTRUCTIONS QUEUED")
        return false
    }
    if queue.first == nil {
        queue.first = frame
        queue.last = frame
    }
    else {
        queue.last.next = frame
        frame.previous = queue.last
        queue.last = frame
    }
    queue.count += 1
    return true
}

class ExecutionFrame {
    
    let instruction : RobotInstruction
    
    var previous : ExecutionFrame? = nil
    var next : ExecutionFrame? = nil
    
    init(_ newInstruction: RobotInstruction) {
        instruction = newInstruction
    }
}

extension ExecutionFrame : CustomStringConvertible {
    var description : String {
        var str = "[ExecutionFrame:\n"
        str += "    instruction: " + functionNameForInstruction(instruction) + "\n"
        str += "    previous: "
        if let p = previous {
            str += functionNameForInstruction(p.instruction)
        }
        else {
            str += "(nil)"
        }
        str += "\n"
        str += "    next: "
        if let n = next {
            str += functionNameForInstruction(n.instruction)
        }
        else {
            str += "(nil)"
        }
        str += "\n]"
        return str
    }
}

enum RobotError {
    case CannotMoveIntoWall
    case NoCookieToPickup
    case CannotStackCookies
}

struct ExecutionResult {
    let success : Bool
    let error : RobotError?
    let sensingResult : Bool?
}

func executeFrameOnLevel(frame: ExecutionFrame, _ level: Level) -> ExecutionResult {
    
    switch frame.instruction {
    case .CanGoForward:
        let result = canMoveRobot(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    case .GoForward:
        if !(moveRobot(level)) {
            return ExecutionResult(success: false, error: .CannotMoveIntoWall, sensingResult: nil)
        }
        
    case .TurnLeft:
        turnRobotLeft(level)
        return ExecutionResult(success: true, error: nil, sensingResult: nil)
        
    case .SenseCookie:
        let result = robotSenseCookie(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    case .PlaceCookie:
        if !(robotPlaceCookie(level)) {
            return ExecutionResult(success: false, error: .CannotStackCookies, sensingResult: nil)
        }
        
    case .PickupCookie:
        if !(robotPickupCookie(level)) {
            return ExecutionResult(success: false, error: .NoCookieToPickup, sensingResult: nil)
        }
        
    case .CanGoLeft:
        let result = canMoveRobotLeft(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    case .CanGoRight:
        let result = canMoveRobotRight(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    }
    
    return ExecutionResult(success: true, error: nil, sensingResult: nil)
}

public func buildExecutionQueueInBackground(level: Level, _ instructions: () -> (), _ completion: (ExecutionQueue) -> () ) {
    
    let levelCopy = level.copy()
    var encounteredError = false
    let executionQueue = ExecutionQueue()
    
    canGoForward = {
        if encounteredError { return false }
        let frame = ExecutionFrame(.CanGoForward)
        let result = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
        return result.sensingResult!
    }
    
    canGoLeft = {
        if encounteredError { return false }
        let frame = ExecutionFrame(.CanGoLeft)
        let result = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
        return result.sensingResult!
    }
    
    canGoRight = {
        if encounteredError { return false }
        let frame = ExecutionFrame(.CanGoRight)
        let result = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
        return result.sensingResult!
    }
    
    goForward = {
        if encounteredError { return }
        let frame = ExecutionFrame(.GoForward)
        let result = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
        if !result.success {
            encounteredError = true
        }
    }
    
    turnLeft = {
        if encounteredError { return }
        let frame = ExecutionFrame(.TurnLeft)
        let _ = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
    }
    
    senseCookie = {
        if encounteredError { return false }
        let frame = ExecutionFrame(.SenseCookie)
        let result = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
        return result.sensingResult!
    }
    
    placeCookie = {
        if encounteredError { return }
        let frame = ExecutionFrame(.PlaceCookie)
        let result = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
        if !result.success {
            encounteredError = true
        }
    }
    
    pickupCookie = {
        if encounteredError { return }
        let frame = ExecutionFrame(.PickupCookie)
        let result = executeFrameOnLevel(frame, levelCopy)
        if !enqueueFrame(frame, executionQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                completion(executionQueue)
            })
            NSThread.exit()
        }
        if !result.success {
            encounteredError = true
        }
    }
    
    let queuer = BackgroundQueuer(instructions, {
        dispatch_async(dispatch_get_main_queue(), {
            completion(executionQueue)
        })
        NSThread.exit()
    })
    
    NSThread.detachNewThreadSelector(#selector(BackgroundQueuer.buildQueue), toTarget: queuer, withObject: nil)
    
    
}

class BackgroundQueuer {
    
    let instructions : () -> ()
    let completion : () -> ()
    
    init(_ newInstructions: () -> (), _ queueCompletion: () -> ()) {
        instructions = newInstructions
        completion = queueCompletion
    }
    
    @objc func buildQueue() {
        print("hello threaded world!")
        instructions()
        completion()
    }
    
}
