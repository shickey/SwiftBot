import UIKit

public struct Point {
    var x = 0
    var y = 0
    
    public init(_ newX: Int, _ newY: Int) {
        x = newX
        y = newY
    }
}

public struct Size {
    var width = 0
    var height = 0
    
    public init(_ newWidth: Int, _ newHeight: Int) {
        width = newWidth
        height = newHeight
    }
}

public enum MapTile : Character, Equatable {
    case Wall = "W"
    case Space = " "
    case Explored = "E"
}

public func ==(lhs: MapTile, rhs: MapTile) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public enum Direction {
    case North
    case East
    case West
    case South
}

public struct Robot {
    var location : Point = Point(0,0)
    var state : Int = 0
}

public class Map {
    
    var tiles : [[MapTile]] = []
    var robot = Robot()
    
    public var size : Size {
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
                    tileLine.append(MapTile.init(rawValue: char)!)
                }
                tiles.append(tileLine)
            }
            return tiles
        }()
        randomlyPlaceRobot()
    }
    
    public func randomlyPlaceRobot() {
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
    
    public func clear() {
        for y in 0..<size.height {
            for x in 0..<size.width {
                let tile = tiles[y][x]
                if tile != .Wall {
                    tiles[y][x] = .Space
                }
            }
        }
    }
    
    public func tileAtLocation(location: Point) -> MapTile {
        return tiles[location.y][location.x]
    }
    
    public func move(direction: Direction) {
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
    
    public func move(location: Point) {
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

public class RobotView : UIView {
    
    var storedMap : Map?
    
    public var map : Map? {
        get {
            return storedMap
        }
        set(newMap) {
            storedMap = newMap
            setNeedsDisplay()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, rect)
        if let map = storedMap {
            let mapSize = map.size
            let tileSize = computeTileSize()
            for y in 0..<mapSize.height {
                for x in 0..<mapSize.width {
                    let tile = map.tiles[y][x]
                    let origin = CGPointMake(CGFloat(x) * tileSize.width, CGFloat(y) * tileSize.height)
                    let tileRect = CGRectMake(origin.x, origin.y, tileSize.width, tileSize.height)
                    switch tile {
                    case .Wall:
                        CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0)
                    case .Space:
                        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0)
                    case .Explored:
                        CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0)
                    }
                    CGContextFillRect(context, tileRect)
                }
            }
            let robotOrigin = CGPointMake(CGFloat(map.robot.location.x) * tileSize.width, CGFloat(map.robot.location.y) * tileSize.height)
            let robotRect = CGRectMake(robotOrigin.x, robotOrigin.y, tileSize.width, tileSize.height)
            CGContextSetRGBFillColor(context, 0, 1.0, 0, 1.0)
            CGContextFillRect(context, robotRect)
        }
        else {
            super.drawRect(rect)
        }
    }
    
    func computeTileSize() -> CGSize {
        if let mapState = storedMap {
            let mapSize = mapState.size
            return CGSizeMake(bounds.width / CGFloat(mapSize.width), bounds.height / CGFloat(mapSize.height))
        }
        return CGSizeZero
    }
    
}
