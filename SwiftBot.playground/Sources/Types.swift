import Foundation

/*
*  Geometry
*/

struct Point {
    var x = 0
    var y = 0
    
    init(_ newX: Int, _ newY: Int) {
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

/*
*  Map
*/

enum MapTile : Character, Equatable {
    case Wall = "W"
    case Space = " "
    case Explored = "E"
}

func ==(lhs: MapTile, rhs: MapTile) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

enum Direction {
    case North
    case East
    case West
    case South
}

struct Robot {
    var location : Point = Point(0,0)
    var state : Int = 0
}