import Foundation

public class Map {
    
    var tiles : [[MapTile]] = []
    var robot = Robot()
    
    var size : Size {
        get {
            return Size(tiles[0].count, tiles.count)
        }
    }
    
    public init(size: Size, startingLocation: Point? = nil) {
        tiles = {
            var newTiles : [[MapTile]] = []
            
            var line : [MapTile] = []
            for _ in 0..<size.width {
                line.append(.Wall)
            }
            newTiles.append(line)
            
            for _ in 1..<(size.height - 1) {
                line = []
                for x in 0..<size.width {
                    if x == 0 || x == (size.width - 1) {
                        line.append(.Wall)
                    }
                    else {
                        line.append(.Space)
                    }
                }
                newTiles.append(line)
            }
            
            line = []
            for _ in 0..<size.width {
                line.append(.Wall)
            }
            newTiles.append(line)
            
            return newTiles
        }()
        
        if let start = startingLocation {
            move(start)
        }
        else {
            randomlyPlaceRobot()
        }
    }
    
    public init(mapString: String, startingLocation: Point? = nil) {
        tiles = {
            let lines = mapString.componentsSeparatedByString("\n")
            var tiles : [[MapTile]] = []
            for line in lines {
                var tileLine : [MapTile] = []
                for char in line.characters {
                    tileLine.append(MapTile(rawValue: char)!)
                }
                tiles.append(tileLine)
            }
            return tiles
        }()
        if let start = startingLocation {
            move(start)
        }
        else {
            randomlyPlaceRobot()
        }
    }
    
    func copy() -> Map {
        let c = Map(size: size)
        c.tiles = tiles
        c.robot = robot
        return c
    }
    
    func randomlyPlaceRobot() {
        clear()
        var x = Int(arc4random_uniform(UInt32(size.width)))
        var y = Int(arc4random_uniform(UInt32(size.height)))
        var tile = tiles[y][x]
        while tile == .Wall {
            x = Int(arc4random_uniform(UInt32(size.width)))
            y = Int(arc4random_uniform(UInt32(size.height)))
            tile = tiles[y][x]
        }
        move(Point(x, y))
    }
    
    func clear() {
        for y in 0..<size.height {
            for x in 0..<size.width {
                let tile = tiles[y][x]
                if tile != .Wall {
                    tiles[y][x] = .Space
                }
            }
        }
    }
    
    func tileAtLocation(location: Point) -> MapTile {
        return tiles[location.y][location.x]
    }
    
    func move() -> Bool {
        return move(robot.facing)
    }
    
    func move(direction: Direction) -> Bool {
        var movePosition = robot.location
        switch direction {
        case .North:
            movePosition.y -= 1
        case .East:
            movePosition.x += 1
        case .West:
            movePosition.x -= 1
        case .South:
            movePosition.y += 1
        }
        return move(movePosition)
    }
    
    func move(location: Point) -> Bool {
        if !canMove(location) {
            print("ERROR: You can't move there!")
            return false
        }
        robot.location = location
        tiles[robot.location.y][robot.location.x] = .Explored
        return true
    }
    
    func canMove() -> Bool {
        return canMove(robot.facing)
    }
    
    func canMove(direction: Direction) -> Bool {
        var movePosition = robot.location
        switch direction {
        case .North:
            movePosition.y -= 1
        case .East:
            movePosition.x += 1
        case .West:
            movePosition.x -= 1
        case .South:
            movePosition.y += 1
        }
        return canMove(movePosition)
    }
    
    func canMove(location: Point) -> Bool {
        if location.x < 0 || location.x >= size.width { return false }
        if location.y < 0 || location.y >= size.height { return false }
        let tile = tileAtLocation(location)
        if tile == .Wall {
            return false
        }
        return true
    }
    
    func turnLeft() {
        switch robot.facing {
        case .North:
            robot.facing = .West
        case .East:
            robot.facing = .North
        case .West:
            robot.facing = .South
        case .South:
            robot.facing = .East
        }
    }
    
    func turnRight() {
        switch robot.facing {
        case .North:
            robot.facing = .East
        case .East:
            robot.facing = .South
        case .West:
            robot.facing = .North
        case .South:
            robot.facing = .West
        }
    }
    
    func isComplete() -> Bool {
        for row in tiles {
            for tile in row {
                if tile == .Space {
                    return false
                }
            }
        }
        return true
    }
    
}

extension Map : CustomStringConvertible {
    public var description: String {
        get {
            var str = ""
            for y in 0..<size.height {
                for x in 0..<size.width {
                    let tile = tiles[y][x]
                    switch tile {
                    case .Wall:
                        str += "x"
                    case .Space:
                        str += " "
                    case .Explored:
                        str += "*"
                    }
                }
                str += "\n"
            }
            
            let robotIndex = ((robot.location.y * size.width) + robot.location.y) + robot.location.x // We add an extra robot.location.y to account for \n characters
            let start = str.startIndex.advancedBy(robotIndex)
            let end = start.advancedBy(1)
            str = str.stringByReplacingCharactersInRange(start..<end, withString: "R")
            return str
        }
    }
}
