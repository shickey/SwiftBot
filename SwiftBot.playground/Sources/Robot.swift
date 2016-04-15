enum Direction {
    case North
    case East
    case West
    case South
}

struct Robot {
    var location : Point = Point(0,0)
    var facing : Direction = .North
}