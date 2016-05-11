import Foundation

var levels : [Level] = ({
    
    var lineMap = Map(mapString: "WWWWWWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWW WWW\nWWWWWWW")
    
    
    
    
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
    
    
    var invert = Level(map:lineMap, startingLocation: Point(3, 4))
    invert.cookies = conditionalsCookies
    invert.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        
        var allCookies : Set<Cookie> = [
            Cookie(3, 1),
            Cookie(3, 2),
            Cookie(3, 3),
            Cookie(3, 4)
        ]
        
        if !level.cookies.isDisjointWith(conditionalsCookies) {
            valid = false
            errors.append("Some of the original cookies are on the floor")
        }
        
        if !(level.cookies.union(conditionalsCookies) == allCookies) {
            valid = false
            errors.append("Some of the cookies weren't inverted properly")
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
    
    var randomLengthHallwayMapString : String = ({
        
        var str = "WWWWWWW\nWWW WWW\n"
        
        var rows = arc4random_uniform(UInt32(8))
        for _ in 0..<rows {
            str += "WWW WWW\n"
        }
        
        str += "WWW WWW\nWWWWWWW"
        return str
        
    })()
    let randomHallwayMap = Map(mapString:randomLengthHallwayMapString)
    let randomHallway = Level(map: randomHallwayMap, startingLocation: Point(3, randomHallwayMap.size.height - 2))
    randomHallway.goalValidator = { (level) in
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
    
    
    
    var randomInvertMap = Map(mapString:randomLengthHallwayMapString)
    var randomInvertCookies : Set<Cookie> = ({
        
        var cookies : Set<Cookie> = []
        
        for i in 1...randomInvertMap.size.height - 2 {
            cookies.insert(Cookie(3, i))
        }
        
        let numCookiesToDelete = arc4random_uniform(UInt32(randomInvertMap.size.height - 2))
        
        for _ in 0..<numCookiesToDelete {
            var indexToDelete = arc4random_uniform(UInt32(cookies.count))
            cookies.removeAtIndex(cookies.startIndex.advancedBy(Int(indexToDelete)))
        }
        
        return cookies
        
    })()
    let randomInvert = Level(map: randomInvertMap, startingLocation: Point(3, randomHallwayMap.size.height - 2))
    randomInvert.cookies = randomInvertCookies
    randomInvert.goalValidator = { (level) in
        var valid = true
        var errors : [String] = []
        
        
        var allCookies : Set<Cookie> = []
        
        for i in 1...randomInvertMap.size.height - 2 {
            allCookies.insert(Cookie(3, i))
        }
        
        if !level.cookies.isDisjointWith(randomInvertCookies) {
            valid = false
            errors.append("Some of the original cookies are on the floor")
        }
        
        if !(level.cookies.union(randomInvertCookies) == allCookies) {
            valid = false
            errors.append("Some of the cookies weren't inverted properly")
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
    
    
    return [conditionals, invert, randomHallway, randomInvert]
})()

public var currentLevel = levels[0]
