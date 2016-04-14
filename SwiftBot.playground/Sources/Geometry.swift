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