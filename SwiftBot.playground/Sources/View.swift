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