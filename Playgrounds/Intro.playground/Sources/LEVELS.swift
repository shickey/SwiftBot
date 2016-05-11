import Foundation

var levels : [Level] = ({
    var lineMap = Map(mapString: "WWWWWWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWWWWWW")
    var line = Level(map: lineMap, startingLocation: Point(3, 4))
    line.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.robot.location != Point(3, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if level.cookies.count == 0 || !level.cookies.contains(Cookie(3, 1)) {
            valid = false
            errors.append("There is no cookie at the end of the hallway")
        }
        else if level.cookies.count > 1 {
            valid = false
            errors.append("There are too many cookies on the floor")
        }
        
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
    }
    
    var leftMap = Map(mapString: "WWWWW\nW   W\nWWW W\nWWW W\nWWWWW");
    var left = Level(map: leftMap, startingLocation: Point(3, 3))
    left.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.robot.location != Point(1, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if level.cookies.count == 0 || !level.cookies.contains(Cookie(1, 1)) {
            valid = false
            errors.append("There is no cookie at the end of the hallway")
        }
        else if level.cookies.count > 1 {
            valid = false
            errors.append("There are too many cookies on the floor")
        }
        
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
    }
    
    var rightMap = Map(mapString: "WWWWW\nW   W\nW WWW\nW WWW\nWWWWW")
    var right = Level(map: rightMap, startingLocation: Point(1, 3))
    right.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.robot.location != Point(3, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if level.cookies.count == 0 || !level.cookies.contains(Cookie(3, 1)) {
            valid = false
            errors.append("There is no cookie at the end of the hallway")
        }
        else if level.cookies.count > 1 {
            valid = false
            errors.append("There are too many cookies on the floor")
        }
        
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
    }
    
    var donutMap = Map(mapString: "WWWWWWW\nW     W\nW WWW W\nW WWW W\nW WWW W\nW     W\nWWWWWWW")
    var donut = Level(map:donutMap, startingLocation: Point(5, 5));
    donut.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.cookies.count < 4 {
            valid = false
            errors.append("There are too few cookies on the floor")
        }
        else if level.cookies.count > 4 {
            valid = false
            errors.append("There are too many cookies on the floor")
        }
        
        if !level.cookies.contains(Cookie(1, 1)) {
            valid = false
            errors.append("There is no cookie in the upper left corner")
        }
        if !level.cookies.contains(Cookie(5, 1)) {
            valid = false
            errors.append("There is no cookie in the upper right corner")
        }
        if !level.cookies.contains(Cookie(1, 5)) {
            valid = false
            errors.append("There is no cookie in the lower left corner")
        }
        if !level.cookies.contains(Cookie(5, 5)) {
            valid = false
            errors.append("There is no cookie in the lower right corner")
        }
        
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
    }
    
    var conditionalsMap = Map(mapString: "WWWWWWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWWWWWW")
    var conditionalsCookies : Set<Cookie> = ({
        
        var cookies : Set<Cookie> = [
            Cookie(3, 1),
            Cookie(3, 2),
            Cookie(3, 3),
            Cookie(3, 4)
        ]
        
        let numCookiesToDelete = arc4random_uniform(UInt32(5))
        
        for _ in 0..<numCookiesToDelete {
            var indexToDelete = arc4random_uniform(UInt32(cookies.count))
            cookies.removeAtIndex(cookies.startIndex.advancedBy(Int(indexToDelete)))
        }
        
        return cookies
        
    })()
    var conditionals = Level(map: lineMap, startingLocation: Point(3, 4))
    conditionals.cookies = conditionalsCookies
    conditionals.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        if level.cookies.count > 0 {
            valid = false
            errors.append("There are still cookies on the floor!")
        }
        if level.robot.location != Point(3, 1) {
            valid = false
            errors.append("SwiftBot isn't at the end of the hallway")
        }
        
        if valid {
            return (true, nil)
        }
        else {
            return (false, errors)
        }
        
    }
    
    return [line, left, right, donut, conditionals]
})()

public var currentLevel = levels[0]
