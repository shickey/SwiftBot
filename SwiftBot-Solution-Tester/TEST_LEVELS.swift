import Foundation

public var levels : [Level] = ({
    
    let validator : (Level) -> (Bool, [String]?) = { (level) in
        var valid = true
        var errors : [String] = []
        
        var levelSize = level.map.size.width
        
        if level.cookies.count != 1 {
            valid = false
            errors.append("There should be exactly 1 cookie on the floor")
        }
        
        if levelSize % 2 == 0 {
            let cookie1 = Cookie((levelSize / 2) - 1, levelSize - 2)
            let cookie2 = Cookie((levelSize / 2)    , levelSize - 2)
            
            if !(level.cookies.contains(cookie1) || level.cookies.contains(cookie2)) {
                valid = false
                errors.append("There isn't a cookie in the middle of the bottom row")
            }
        }
        else {
            let cookie = Cookie(levelSize / 2, levelSize - 2)
            if !(level.cookies.contains(cookie)) {
                valid = false
                errors.append("There isn't a cookie in the middle of the bottom row")
            }
        }
        
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
        
    }
    
    var newLevels : [Level] = []
    
    
    var boardSizes : [Int] = []
    
    for i in 7...12 {
        boardSizes.append(i)
    }
    
    //    var currentSize = 5
    //    for _ in 1...13 {
    //
    //        currentSize *= 2
    //    }
    //    boardSizes.append(currentSize + 2)
    //    print(boardSizes)
    
    //    for i in [7, 12, 22, 42, 82, 162, 322, 642, 1282] {
    //    for i in [7, 13, 23, 43, 83, 163, 323, 643, 1283] {
    for i in boardSizes {
        let map = Map(size: Size(i,i))
        let level = Level(map: map, startingLocation: Point(1, i - 2))
        level.goalValidator = validator
        newLevels.append(level)
    }
    
    return newLevels
    
})()