enum MapTile : Character, Equatable {
    case Wall = "W"
    case Space = " "
}

func ==(lhs: MapTile, rhs: MapTile) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public class Map {
    
    var tiles : [[MapTile]] = []
    
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
    }
}

func tileAtMapLocation(map: Map, _ location: Point) -> MapTile {
    return map.tiles[location.y][location.x]
}