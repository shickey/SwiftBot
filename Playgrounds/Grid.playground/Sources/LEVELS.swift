var levels : [Level] = ({
    
    var square = Level(map: Map(size: Size(10, 10)), startingLocation: Point(8, 8))
    square.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        var finalCookies : Set<Cookie> = []
        for i in [1, 3, 5, 7] {
            for j in [1, 3, 5, 7] {
                finalCookies.insert(Cookie(i, j))
            }
        }
        
        for i in [2, 4, 6, 8] {
            for j in [2, 4, 6, 8] {
                finalCookies.insert(Cookie(i, j))
            }
        }
        
        print(finalCookies)
        
        if level.cookies != finalCookies {
            valid = false
            errors.append("Make sure you have alternating cookies starting with a cookie in the lower right corner")
        }
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
        
    }
    
    return [square]
})()

public var currentLevel = levels[0]