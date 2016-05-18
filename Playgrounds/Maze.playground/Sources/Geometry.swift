/*
 * Point
 */

public struct Point {
    public var x = 0
    public var y = 0
    
    public init(_ newX: Int, _ newY: Int) {
        x = newX
        y = newY
    }
}

extension Point : Equatable {}
public func ==(lhs: Point, rhs: Point) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

extension Point : Hashable {
    public var hashValue : Int {
        // TODO: This is an absolutely ludicrous hash function, but has no
        // collisions for points in -50 < x < 50 and -50 < y < 50
        return "(\(x), \(y))".hashValue
    }
}

/*
 * Size
 */

public struct Size : Equatable {
    public var width = 0
    public var height = 0
    
    public init(_ newWidth: Int, _ newHeight: Int) {
        width = newWidth
        height = newHeight
    }
}

public func ==(lhs: Size, rhs: Size) -> Bool {
    return (lhs.width == rhs.width) && (lhs.height == rhs.height)
}

/*
 * Direction
 */

enum Direction {
    case North
    case East
    case West
    case South
    
    var left : Direction {
        switch self {
        case .North:
            return .West
        case .West:
            return .South
        case .South:
            return .East
        case .East:
            return .North
        }
    }
    
    var right : Direction {
        switch self {
        case .North:
            return .East
        case .West:
            return .North
        case .South:
            return .West
        case .East:
            return .South
        }
    }
}