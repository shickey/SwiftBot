//: [Previous](@previous)

setup(2)

instructions = {
    
    while canGoForward() {
        goForward()
    }
    turnLeft()
    while canGoForward() {
        goForward()
    }
    turnLeft()
    
    while squaresLeftToExplore() {
        while canGoForward() {
            goForward()
        }
        turnLeft()
        goForward()
        turnLeft()
        while canGoForward() {
            goForward()
        }
        turnLeft()
        turnLeft()
        turnLeft()
        if canGoForward() {
            goForward()
            turnLeft()
            turnLeft()
            turnLeft()
        }
    }
    
}
//: [Next](@next)
