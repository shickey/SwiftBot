import UIKit

public class Map {
    
    var tiles : [[MapTile]] = []
    var robot = Robot()
    
    var size : Size {
        get {
            return Size(tiles[0].count, tiles.count)
        }
    }
    
    public init(size: Size) {
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
        randomlyPlaceRobot()
    }
    
    public init(mapString: String) {
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
        randomlyPlaceRobot()
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
        robot.location.x = x
        robot.location.y = y
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
    
    func move(direction: Direction) {
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
        move(movePosition)
    }
    
    func move(location: Point) {
        let nextTile = tileAtLocation(location)
        if nextTile == .Wall {
            print("ERROR: There's a wall there!")
            return
        }
        robot.location = location
        tiles[robot.location.y][robot.location.x] = .Explored
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
