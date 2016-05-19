/*:

# The Maze

There is one cookie in this maze. Find it and pick it up!

![Find the Cookie!](maze_goal.png)

## A Couple New Helper Instructions

SwiftBot knows all its normal commands in addition to two more:

- `canGoLeft()` which indicates if there's open space to the left of the robot
- `canGoRight()` which indicates if there's open space to the right of the robot

*/

setup(0)


instructions = {
    
    while !senseCookie() {
        if canGoLeft() {
            turnLeft()
            goForward()
            
        }
        else if canGoForward() {
            goForward()
        }
        else if canGoRight() {
            turnLeft()
            turnLeft()
            turnLeft()
            goForward()
        }
        else {
            turnLeft()
            turnLeft()
            goForward()
        }
    }
    pickupCookie()
    
}
