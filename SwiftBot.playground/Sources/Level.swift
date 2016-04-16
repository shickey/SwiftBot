import Foundation

struct Robot {
    var location : Point = Point(0,0)
    var facing : Direction = .North
}

struct Goal {
    var robotLocation : Point?
    var robotOrientation : Direction?
    var cookies : Set<Cookie>?
}

typealias Cookie = Point

public class Level {
    
    var map : Map
    var robot : Robot = Robot()
    var cookies : Set<Cookie> = []
    
    public init(map newMap: Map) {
        map = newMap
        randomlyPlaceRobot(self)
    }
    
    public init(map newMap: Map, startingLocation: Point) {
        map = newMap
        moveRobot(self, startingLocation)
    }
    
    public func copy() -> Level {
        let c = Level(map: map)
        c.cookies = cookies
        c.robot = robot
        return c
    }
    
}

/*
 * MARK: Level Functions
 */

func randomlyPlaceRobot(level: Level) {
    let map = level.map
    var x = Int(arc4random_uniform(UInt32(map.size.width)))
    var y = Int(arc4random_uniform(UInt32(map.size.height)))
    var tile = map.tiles[y][x]
    while tile == .Wall {
        x = Int(arc4random_uniform(UInt32(map.size.width)))
        y = Int(arc4random_uniform(UInt32(map.size.height)))
        tile = map.tiles[y][x]
    }
    moveRobot(level, Point(x, y))
}

func levelMatchesGoal(level: Level, _ goal: Goal) -> Bool {
    if let robotLocation = goal.robotLocation {
        if robotLocation != level.robot.location {
            return false
        }
    }
    if let robotOrientation = goal.robotOrientation {
        if robotOrientation != level.robot.facing {
            return false
        }
    }
    if let cookies = goal.cookies {
        if cookies != level.cookies {
            return false
        }
    }
    return true
}


    
    
/*
 * MARK: Robot Instruction Primatives
 */

func moveRobot(level: Level, _ location: Point) -> Bool {
    if !canMoveRobot(level, location) {
        print("ERROR: You can't move there!")
        return false
    }
    level.robot.location = location
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

func robotPlaceCookie(level: Level) -> Bool {
    if robotSenseCookie(level) {
        print("ERROR: There's already a cookie there!")
        return false
    }
    level.cookies.insert(level.robot.location)
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
                        line += "x"
                    case .Space:
                        line += " "
                    }
                }
                lines.append(line)
            }
            
            // "Blit" Cookies
            for cookie in cookies {
                var lineToBlitTo = lines[cookie.y]
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
            var lineToBlitTo = lines[robot.location.y]
            let start = lineToBlitTo.startIndex.advancedBy(robot.location.x)
            let end = start.advancedBy(1)
            lines[robot.location.y] = lineToBlitTo.stringByReplacingCharactersInRange(start..<end, withString: blitCharacter)
            
            return lines.joinWithSeparator("\n")
        }
    }
}
