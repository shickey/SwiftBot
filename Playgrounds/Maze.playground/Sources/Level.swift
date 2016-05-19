struct Robot {
    var location : Point = Point(0,0)
    var facing : Direction = .North
}

typealias Cookie = Point

struct LevelOptions {
    var animationInterval : Double = 0.25
    var smokeTrailsEnabled : Bool = false
}

public class Level {
    
    var map : Map
    var robot : Robot = Robot()
    var cookies : Set<Cookie> = []
    var path : [Point] = []
    
    var options : LevelOptions = LevelOptions()
    
    var goalValidator : ((Level) -> (Bool, [String]?))?
    
    public init(map newMap: Map, startingLocation: Point) {
        map = newMap
        moveRobot(self, startingLocation)
    }
    
    public func copy() -> Level {
        let c = Level(map: map, startingLocation: robot.location)
        c.cookies = cookies
        c.robot = robot
        c.options = options
        return c
    }
    
}

/*
 * Validation
 */

func validateLevel(level: Level) -> (Bool, [String]?) {
    if let validator = level.goalValidator {
        return validator(level)
    }
    return (true, nil) // If a level doesn't have a validator, it's valid by default
}
    
    
/*
 * MARK: Robot Instruction Primatives
 */

func moveRobot(level: Level, _ location: Point) -> Bool {
    if !canMoveRobot(level, location) {
        return false
    }
    level.robot.location = location
    level.path.append(location)
    return true
}

func moveRobot(level: Level) -> Bool {
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

func turnRobotLeft(level: Level) {
    level.robot.facing = level.robot.facing.left
}

func canMoveRobot(level: Level) -> Bool {
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

func canMoveRobot(level: Level, _ location: Point) -> Bool {
    let map = level.map
    if location.x < 0 || location.x >= map.size.width { return false }
    if location.y < 0 || location.y >= map.size.height { return false }
    let tile = map.tileAtLocation(location)
    if tile == .Wall {
        return false
    }
    return true
}

func canMoveRobotLeft(level: Level) -> Bool {
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

func canMoveRobotRight(level: Level) -> Bool {
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

func robotPlaceCookie(level: Level) -> Bool {
    if robotSenseCookie(level) {
        return false
    }
    level.cookies.insert(level.robot.location)
    return true
}

func robotPickupCookie(level: Level) -> Bool {
    if !robotSenseCookie(level) {
        return false
    }
    level.cookies.remove(level.robot.location)
    return true
}

func robotSenseCookie(level: Level) -> Bool {
    let position = level.robot.location
    for cookie in level.cookies {
        if cookie == position {
            return true
        }
    }
    return false
}

/*
 * MARK: Debug
 */

extension Level : CustomStringConvertible {
    
    public var description: String {
        get {
            var lines : [String] = []
            for y in 0..<map.size.height {
                var line = ""
                for x in 0..<map.size.width {
                    let tile = map.tileAtLocation(Point(x, y))
                    switch tile {
                    case .Wall:
                        line += "#"
                    case .Space:
                        line += " "
                    }
                }
                lines.append(line)
            }
            
            // "Blit" Cookies
            for cookie in cookies {
                let lineToBlitTo = lines[cookie.y]
                let start = lineToBlitTo.startIndex.advancedBy(cookie.x)
                let end = start.advancedBy(1)
                lines[cookie.y] = lineToBlitTo.stringByReplacingCharactersInRange(start..<end, withString: "*")
            }
            
            // "Blit" Bot
            // TODO: This will overwrite a cookie character if the robot is on a cookie
            var blitCharacter = "^"
            switch robot.facing {
            case .North:
                blitCharacter = "^"
            case .West:
                blitCharacter = "<"
            case .South:
                blitCharacter = "v"
            case .East:
                blitCharacter = ">"
            }
            let lineToBlitTo = lines[robot.location.y]
            let start = lineToBlitTo.startIndex.advancedBy(robot.location.x)
            let end = start.advancedBy(1)
            lines[robot.location.y] = lineToBlitTo.stringByReplacingCharactersInRange(start..<end, withString: blitCharacter)
            
            return lines.joinWithSeparator("\n")
        }
    }
}
