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

struct Robot {
    var location : Point = Point(0,0)
    var facing : Direction = .North
}