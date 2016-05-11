import Foundation

var levels : [Level] = ({
    
    let squareMap = Map(size: Size(7,7))
    let square = Level(map: squareMap, startingLocation: Point(1, 5))
    square.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.cookies.count != 1 {
            valid = false
            errors.append("There should be exactly 1 cookie on the floor")
        }
        if !level.cookies.contains(Cookie(3, 5)) {
            valid = false
            errors.append("There isn't a cookie in the middle of the bottom row")
        }
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
        
    }
    
    let randomSquareSize = Int((2 * arc4random_uniform(UInt32(4))) + 6) + Int(arc4random_uniform(1))
    let randomSquareMap = Map(size: Size(randomSquareSize, randomSquareSize))
    let randomSquare = Level(map: randomSquareMap, startingLocation: Point(1, randomSquareSize - 2))
    randomSquare.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.cookies.count != 1 {
            valid = false
            errors.append("There should be exactly 1 cookie on the floor")
        }
        
        let cookie1 = Cookie((randomSquareSize / 2) + 1, randomSquareSize - 2)
        let cookie2 = Cookie((randomSquareSize / 2) + 2, randomSquareSize - 2)
        
        if !(level.cookies.contains(cookie1) || level.cookies.contains(cookie2)) {
            valid = false
            errors.append("There isn't a cookie in the middle of the bottom row")
        }
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
        
    }
    
    return [square, randomSquare]
})()

public var currentLevel = levels[0]
