//: [Previous](@previous)

setup(3)

instructions = {
    
//    func turnRight() {
//        turnLeft()
//        turnLeft()
//        turnLeft()
//    }
//    
//    func canGoLeft() -> Bool {
//        turnLeft()
//        let can = canGoForward()
//        turnLeft()
//        turnLeft()
//        turnLeft()
//        return can
//    }
    
    while squaresLeftToExplore() {
        if canGoLeft() {
            turnLeft()
            goForward()
        }
        else if canGoForward() {
            goForward()
        }
        else {
            turnRight()
        }
    }
}

//: [Next](@next)
