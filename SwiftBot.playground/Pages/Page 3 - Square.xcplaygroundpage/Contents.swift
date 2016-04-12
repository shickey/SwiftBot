//: [Previous](@previous)

setup(2)
defer { run() }

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
        goForward()
        turnLeft()
        turnLeft()
        turnLeft()
    }
    
}

//: [Next](@next)
