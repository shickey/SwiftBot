import UIKit

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
                    let tileRect = CGRectIntegral(CGRectMake(origin.x, origin.y, tileSize.width, tileSize.height))
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
            let robotRect = CGRectIntegral(CGRectMake(robotOrigin.x, robotOrigin.y, tileSize.width, tileSize.height))
            
            let points = pointsForRobotRect(robotRect)
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, points[0].x, points[0].y)
            for i in 1..<points.count {
                CGContextAddLineToPoint(context, points[i].x, points[i].y)
            }
            CGContextClosePath(context)
            CGContextSetRGBFillColor(context, 1.0, 0.75, 0.5, 1.0)
            CGContextFillPath(context)
        }
        else {
            super.drawRect(rect)
        }
    }
    
    func pointsForRobotRect(robotRect: CGRect) -> [CGPoint] {
        if let map = storedMap {
            let minX = CGRectGetMinX(robotRect)
            let minY = CGRectGetMinY(robotRect)
            let maxX = CGRectGetMaxX(robotRect)
            let maxY = CGRectGetMaxY(robotRect)
            let midX = CGRectGetMidX(robotRect)
            let midY = CGRectGetMidY(robotRect)
            
            var points : [CGPoint] = []
            
            switch map.robot.facing {
            case .North:
                points.append(CGPointMake(minX, maxY))
                points.append(CGPointMake(minX, midY))
                points.append(CGPointMake(midX, minY))
                points.append(CGPointMake(maxX, midY))
                points.append(CGPointMake(maxX, maxY))
            case .East:
                points.append(CGPointMake(minX, minY))
                points.append(CGPointMake(midX, minY))
                points.append(CGPointMake(maxX, midY))
                points.append(CGPointMake(midX, maxY))
                points.append(CGPointMake(minX, maxY))
            case .West:
                points.append(CGPointMake(maxX, minY))
                points.append(CGPointMake(midX, minY))
                points.append(CGPointMake(minX, midY))
                points.append(CGPointMake(midX, maxY))
                points.append(CGPointMake(maxX, maxY))
            case .South:
                points.append(CGPointMake(minX, minY))
                points.append(CGPointMake(minX, midY))
                points.append(CGPointMake(midX, maxY))
                points.append(CGPointMake(maxX, midY))
                points.append(CGPointMake(maxX, minY))
            }
            return points
        }
        return []
    }
    
    func computeTileSize() -> CGSize {
        if let mapState = storedMap {
            let mapSize = mapState.size
            return CGSizeMake(bounds.width / CGFloat(mapSize.width), bounds.height / CGFloat(mapSize.height))
        }
        return CGSizeZero
    }
    
}