//: [Previous](@previous)

setup(3)

/*:
 
 # Removing Redundancies
 
 When we use just the three standard SwiftBot commands `moveForward()`, `placeCookie()`, `turnLeft()` to solve the square map we end up with some very redudant code! Here's an example:
 
 ![Redudancies!](instructions_annotated.png)
 
 Wouldn't it be nice if we didn't have to type the same set of instructions 4 times in a row?
 
 ## Defining New SwiftBot Commands
 Let's make SwiftBot a little smarter. We can define a new SwiftBot command with the `func` keyword (short for 'function'). Here's a custom SwiftBot command called `placeThreeCookies()` that makes SwiftBot put three cookies down in a row. Note that we need the parentheses on the end!
 
    func placeThreeCookies() {
 
        goForward()
        placeCookie()
        goForward()
        placeCookie()
        goForward()
        placeCookie()
 
    }
 
 To use our new command, we simply write the command in the instructions section like normal. This example will cause SwiftBot to place a total of six cookies in a row:
 
    instructions = {
        
        placeThreeCookies()
        placeThreeCookies()
 
    }
 
 Let's use a custom SwiftBot command to solve the square map!
 */


// Here we define a new SwiftBot command 
// called placeCookieAndMoveToNextCorner()
func placeCookieAndMoveToNextCorner() {
    
    // Write normal SwiftBot commands here that
    // tell SwiftBot to place a cookie, move to
    // the next corner, and turn left:
    
    
    
    
    
}


instructions = {
    
    // In our instructions, we can now use our custom
    // command 4 times to tell SwiftBot to complete
    // the whole map. Write those instructions here:
    
    
    
    
}

//: [Next](@next)
