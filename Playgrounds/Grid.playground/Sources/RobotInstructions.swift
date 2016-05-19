let errorFunc = {
    print("Whoa! You can't use robot instructions outside of the instructions section!")
}

let errorFuncReturningBool = { () -> Bool in
    print("Whoa! You can't use robot instructions outside of the instructions section!")
    return false
}

public var canGoForward : () -> Bool = errorFuncReturningBool
public var canGoLeft : () -> Bool = errorFuncReturningBool
public var canGoRight : () -> Bool = errorFuncReturningBool
public var goForward : () -> () = errorFunc
public var turnLeft : () -> () = errorFunc
public var senseCookie : () -> Bool = errorFuncReturningBool
public var placeCookie : () -> () = errorFunc
public var pickupCookie : () -> () = errorFunc

/*
 * MARK: Robot Instruction Primatives
 */

func _goForward(level: Level) -> Bool {
    var movePosition = level.robot.location
    switch level.robot.facing {
    case .North:
        movePosition.y -= 1
    case .East:
        movePosition.x += 1
    case .West:
        movePosition.x -= 1
    case .South:
        movePosition.y += 1
    }
    return moveRobot(level, movePosition)
}

func _turnLeft(level: Level) {
    level.robot.facing = level.robot.facing.left
}

func _canGoForward(level: Level) -> Bool {
    var movePosition = level.robot.location
    switch level.robot.facing {
    case .North:
        movePosition.y -= 1
    case .East:
        movePosition.x += 1
    case .West:
        movePosition.x -= 1
    case .South:
        movePosition.y += 1
    }
    return canMoveRobot(level, movePosition)
}

func _canGoLeft(level: Level) -> Bool {
    var nextRobotLocation = level.robot.location
    switch level.robot.facing {
    case .North:
        nextRobotLocation.x -= 1
    case .West:
        nextRobotLocation.y += 1
    case .South:
        nextRobotLocation.x += 1
    case .East:
        nextRobotLocation.y -= 1
    }
    
    return canMoveRobot(level, nextRobotLocation);
}

func _canGoRight(level: Level) -> Bool {
    var nextRobotLocation = level.robot.location
    switch level.robot.facing {
    case .North:
        nextRobotLocation.x += 1
    case .West:
        nextRobotLocation.y -= 1
    case .South:
        nextRobotLocation.x -= 1
    case .East:
        nextRobotLocation.y += 1
    }
    
    return canMoveRobot(level, nextRobotLocation);
}

func _placeCookie(level: Level) -> Bool {
    if _senseCookie(level) {
        return false
    }
    level.cookies.insert(level.robot.location)
    return true
}

func _pickupCookie(level: Level) -> Bool {
    if !_senseCookie(level) {
        return false
    }
    level.cookies.remove(level.robot.location)
    return true
}

func _senseCookie(level: Level) -> Bool {
    if level.cookies.contains(level.robot.location) {
        return true
    }
    return false
}
