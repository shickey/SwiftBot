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

let MAX_QUEUE_COUNT = 10000000

public class ExecutionQueue {
    public var first : ExecutionFrame! = nil
    public var last : ExecutionFrame! = nil
    public var count : Int = 0
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

public class ExecutionFrame {
    
    let instruction : RobotInstruction
    
    public var previous : ExecutionFrame? = nil
    public var next : ExecutionFrame? = nil
    
    init(_ newInstruction: RobotInstruction) {
        instruction = newInstruction
    }
}

extension ExecutionFrame : CustomStringConvertible {
    public var description : String {
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

public struct ExecutionResult {
    let success : Bool
    let error : RobotError?
    let sensingResult : Bool?
}

public func executeFrameOnLevel(frame: ExecutionFrame, _ level: Level) -> ExecutionResult {
    
    switch frame.instruction {
    case .CanGoForward:
        let result = _canGoForward(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    case .GoForward:
        if !(_goForward(level)) {
            return ExecutionResult(success: false, error: .CannotMoveIntoWall, sensingResult: nil)
        }
        
    case .TurnLeft:
        _turnLeft(level)
        return ExecutionResult(success: true, error: nil, sensingResult: nil)
        
    case .SenseCookie:
        let result = _senseCookie(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    case .PlaceCookie:
        if !(_placeCookie(level)) {
            return ExecutionResult(success: false, error: .CannotStackCookies, sensingResult: nil)
        }
        
    case .PickupCookie:
        if !(_pickupCookie(level)) {
            return ExecutionResult(success: false, error: .NoCookieToPickup, sensingResult: nil)
        }
        
    case .CanGoLeft:
        let result = _canGoLeft(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    case .CanGoRight:
        let result = _canGoRight(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    }
    
    return ExecutionResult(success: true, error: nil, sensingResult: nil)
}

public func buildExecutionQueueInBackground(level: Level, _ instructions: () -> (), _ completion: (ExecutionQueue, Level, Bool) -> ()) {
    
    let levelCopy = level.copy()
    let executionQueue = ExecutionQueue()
    
    let finish = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        var success = threadDict["success"] as! Bool
        
        let (valid, _) = validateLevel(level)
        if !valid {
            success = false
        }
        dispatch_async(dispatch_get_main_queue(), {
            completion(queue, level, success)
        })
        NSThread.exit()
    }
    
    canGoForward = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.CanGoForward)
        let result = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) {
            threadDict["success"] = false
            finish()
        }
        return result.sensingResult!
    }
    
    canGoLeft = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.CanGoLeft)
        let result = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) {
            threadDict["success"] = false
            finish()
        }
        return result.sensingResult!
    }
    
    canGoRight = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.CanGoRight)
        let result = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) {
            threadDict["success"] = false
            finish()
        }
        return result.sensingResult!
    }
    
    goForward = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.GoForward)
        let result = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) || !result.success {
            threadDict["success"] = false
            finish()
        }
    }
    
    turnLeft = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.TurnLeft)
        let _ = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) {
            threadDict["success"] = false
            finish()
        }
    }
    
    senseCookie = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.SenseCookie)
        let result = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) {
            threadDict["success"] = false
            finish()
        }
        return result.sensingResult!
    }
    
    placeCookie = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.PlaceCookie)
        let result = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) || !result.success {
            threadDict["success"] = false
            finish()
        }
    }
    
    pickupCookie = {
        let threadDict = NSThread.currentThread().threadDictionary
        let level = threadDict["level"] as! Level
        let queue = threadDict["queue"] as! ExecutionQueue
        
        let frame = ExecutionFrame(.PickupCookie)
        let result = executeFrameOnLevel(frame, level)
        if !enqueueFrame(frame, queue) || !result.success {
            threadDict["success"] = false
            finish()
        }
    }
    
    let queuer = BackgroundQueuer(instructions, finish)
    
    let thread = NSThread.init(target: queuer, selector: Selector("buildQueue"), object: nil)
    
    let threadDict = thread.threadDictionary
    threadDict["level"] = levelCopy
    threadDict["queue"] = executionQueue
    threadDict["success"] = true
    
    thread.start()
    
}

class BackgroundQueuer {
    
    let instructions : () -> ()
    let completion : () -> ()
    
    init(_ newInstructions: () -> (), _ queueCompletion: () -> ()) {
        instructions = newInstructions
        completion = queueCompletion
    }
    
    @objc func buildQueue() {
        instructions()
        completion()
    }
    
}
