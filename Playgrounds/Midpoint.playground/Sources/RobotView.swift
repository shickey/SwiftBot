import UIKit

public class RobotView : UIView {
    
    var storedLevel : Level?
    
    public var level : Level? {
        get {
            return storedLevel
        }
        set(newLevel) {
            storedLevel = newLevel
            setNeedsDisplay()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, rect)
        if let level = storedLevel {
            
            // Draw Map
            let map = level.map
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
                    }
                    CGContextFillRect(context, tileRect)
                }
            }
            
            // Draw smoke trails
            if level.options.smokeTrailsEnabled && level.path.count > 1 {
                let greyDelta : CGFloat = 0.5 / CGFloat(level.path.count)
                var fill : CGFloat = 0.5
                for pathComponent in level.path {
                    let origin = CGPointMake(CGFloat(pathComponent.x) * tileSize.width, CGFloat(pathComponent.y) * tileSize.height)
                    let tileRect = CGRectIntegral(CGRectMake(origin.x, origin.y, tileSize.width, tileSize.height))
                    CGContextSetGrayFillColor(context, fill, 1.0)
                    CGContextFillRect(context, tileRect)
                    fill -= greyDelta
                }
            }
            
            // Draw Cookies
            CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0)
            for cookie in level.cookies {
                let origin = CGPointMake(CGFloat(cookie.x) * tileSize.width, CGFloat(cookie.y) * tileSize.height)
                let tileRect = CGRectIntegral(CGRectMake(origin.x, origin.y, tileSize.width, tileSize.height))
                let insetPixels = tileRect.size.width * 0.05
                let cookieRect = CGRectIntegral(CGRectInset(tileRect, insetPixels, insetPixels))
                CGContextFillEllipseInRect(context, cookieRect)
            }
            
            // Draw Robot
            let robotOrigin = CGPointMake(CGFloat(level.robot.location.x) * tileSize.width, CGFloat(level.robot.location.y) * tileSize.height)
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
        if let level = storedLevel {
            let minX = CGRectGetMinX(robotRect)
            let minY = CGRectGetMinY(robotRect)
            let maxX = CGRectGetMaxX(robotRect)
            let maxY = CGRectGetMaxY(robotRect)
            let midX = CGRectGetMidX(robotRect)
            let midY = CGRectGetMidY(robotRect)
            
            var points : [CGPoint] = []
            
            switch level.robot.facing {
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
        if let level = storedLevel {
            let mapSize = level.map.size
            return CGSizeMake(bounds.width / CGFloat(mapSize.width), bounds.height / CGFloat(mapSize.height))
        }
        return CGSizeZero
    }
    
}