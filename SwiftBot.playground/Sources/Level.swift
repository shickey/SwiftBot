import Foundation

struct Robot {
    var location : Point = Point(0,0)
    var facing : Direction = .North
}

typealias Cookie = Point

public class Level {
    
    var map : Map
    var robot : Robot = Robot()
    var cookies : [Cookie] = []
    
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
        c.robot = robot
        return c
    }
    
}

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
    level.cookies.append(level.robot.location)
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
