/*
 * Doubly linked list implementation of program execution states
 */

enum RobotInstruction {
    case CanGoForward
    case GoForward
    case TurnLeft
    case SenseCookie
    case PlaceCookie
    case PickupCookie
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
    }
}

class ExecutionFrame {
    
    let instruction : RobotInstruction
    
    var previous : ExecutionFrame? = nil
    var next : ExecutionFrame? = nil
    
    init(instruction newInstruction: RobotInstruction) {
        instruction = newInstruction
    }
    
    func append(frame: ExecutionFrame) {
        if next == nil {
            next = frame
            frame.previous = self
            return
        }
        next!.append(frame)
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

enum ExecutionError {
    case CannotMoveIntoWall
    case NoCookieToPickup
    case CannotStackCookies
}

struct ExecutionResult {
    let success : Bool
    let error : ExecutionError?
    let sensingResult : Bool?
}

func executeFrameOnLevel(frame: ExecutionFrame, level: Level) -> ExecutionResult {
    
    switch frame.instruction {
    case .CanGoForward:
        let result = canMoveRobot(level)
        return ExecutionResult(success: true, error: nil, sensingResult: result)
        
    case .GoForward:
        if !(moveRobot(level)) {
            return ExecutionResult(success: false,error: .CannotMoveIntoWall, sensingResult: nil)
        }
        
    case .TurnLeft:
        turnRobotLeft(level)
        return ExecutionResult(success: true,error: nil, sensingResult: nil)
        
    case .SenseCookie:
        let result = robotSenseCookie(level)
        return ExecutionResult(success: true,error: nil, sensingResult: result)
        
    case .PlaceCookie:
        if !(robotPlaceCookie(level)) {
            return ExecutionResult(success: false,error: .CannotStackCookies, sensingResult: nil)
        }
        
    case .PickupCookie:
        if !(robotPickupCookie(level)) {
            return ExecutionResult(success: false,error: .NoCookieToPickup, sensingResult: nil)
        }
        
    }
    
    return ExecutionResult(success: true,error: nil, sensingResult: nil)
}