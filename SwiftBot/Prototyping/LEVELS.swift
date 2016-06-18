import Foundation
import simd

var levels : [Level] = ({
    
    let mazeMap = Map(mapString: "WWWWWWWWWWWWWWWWWWWWWWWWW\nW  W W   W   W   W   WW W\nWW W W W W W W W   W    W\nWW W WWW W W W WWWWWWWW W\nW  W     W W W   W    W W\nW WWW WWWW W W W W WW   W\nW          W W W W WWWWWW\nWWWWWWWWWWWW WWW W  W   W\nW  W   W   W   W WW W WWW\nWW W W   W W WWW  W W   W\nWW W WWWWW W W W WW W W W\nWW W     W   W    W WWW W\nWW WWWWW WW WWWWW W     W\nW      W WW     W WWW W W\nW WWWWWW W  WWW W   W W W\nW        W WW W WWW W W W\nWWWWWWWWWW W  W   W W W W\nW    W   WWW WWWW W W W W\nW WW W W        W W WWW W\nW  W W WWWWW WW W W W W W\nW WW W W W   W  W   W   W\nW W  W W   WWW WWWWWWW WW\nW WWWW W W   W W     W WW\nW      W WWW W   WWW   WW\nWWWWWWWWWWWWWWWWWWWWWWWWW")
    
    
    let mapSize = mazeMap.size;
    
    var start : Point
    repeat {
        var x = Int(arc4random_uniform(UInt32(mapSize.width)))
        var y = Int(arc4random_uniform(UInt32(mapSize.height)))
        start = Point(x, y)
    } while (tileAtMapLocation(mazeMap, start) == .Wall)
    
    var cookie : Cookie
    repeat {
        var x = Int(arc4random_uniform(UInt32(mapSize.width)))
        var y = Int(arc4random_uniform(UInt32(mapSize.height)))
        cookie = Point(x, y)
    } while (tileAtMapLocation(mazeMap, cookie) == .Wall || cookie == start)
    
    
    let maze = Level(map: mazeMap, startingLocation: start)
    //    maze.cookies = [cookie : 1]
    //    maze.goalValidator = { (level) in
    //        var valid = true
    //        var errors : [String] = []
    //
    //        if level.cookies.count > 0 {
    //            valid = false
    //            errors.append("There are still cookies on the floor")
    //        }
    //
    //
    //        if valid {
    //            return (true, nil)
    //        }
    //        else {
    //            return (false, errors)
    //        }
    //    }
    
    return [maze]
    
})()