//: [Previous](@previous)

setup(2)

/*:

# Turning Right

Here's a similar map, except this time, we need SwiftBot to turn to the right. Let's define a new custom command called `turnRight()`. We use the `func` keyword (short for "function") to define a new command.

*/

func turnRight() {
    
    // Write the SwiftBot instructions here
    // that will make SwiftBot turn to the right
    turnLeft()
    turnLeft()
    turnLeft()
    
}

/*:

Now in our `instructions` block, we can use our custom command!

*/

instructions = {
    
    goForward()
    goForward()
    
    
    turnRight()   // Here we're using our custom turnRight()
                  // command which we defined above.
                  // When SwiftBot runs this instruction,
                  // they will run all the commands written
                  // in the turnRight() function above.
    
    goForward()
    goForward()
    placeCookie()
    
}

//: [Next](@next)
