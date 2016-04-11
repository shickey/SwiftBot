/*:
 # SwiftBot!
 
 Welcome to SwiftBot! SwiftBot is a little orange robot that likes to explore. SwiftBot looks like this:
 
 INSERT SWIFTBOT IMAGE
 
 SwiftBot lives in a 2D room with blue walls. Open floor space is white in SwiftBot's world.
 
 INSERT IMAGE OF EXAMPLE ROOM
 
 SwiftBot's goal is explore every square of floor space in their world. To help SwiftBot do this, we give SwiftBot instructions.
 
 ## SwiftBot Commands
 SwiftBot knows exactly 2 commands:
 
 ### `goForward()`
 The `goForward()` command will make SwiftBot move forward one space in the direction they're currently facing
 
 ### `turnLeft()`
 The `turnLeft()` command will make SwiftBot turn left in place (i.e., without leaving their current square)

Over on the right, you should see SwiftBot in a simple room. Let's program SwiftBot to get them to explore the whole space!
 
 But first, we're going to need some setup. YOU CAN IGNORE THESE 2 LINES OF CODE (but don't delete them!)
 */

setup(0)
defer { run() }

/*:
 Phew. Now that that's out of the way, let's write some instructions for SwiftBot.
 */
instructions = {
    
    // Write your instructions for SwiftBot below these lines!
    // Try writing goForward(), save, and see what happens. Note that the parentheses are necessary!
    // Once you get that working, write the rest of the instructions (one per line) to tell SwiftBot
    // to explore the whole room
    //
    // WRITE INSTRUCTIONS HERE:
    
    goForward()
    goForward()
    goForward()
    
    
    
    
    
} // Be careful not to delete this } curly bracket!

/*:
 Awesome! Click "Next" when you're ready to move on
 
 [Next](@next)
 */
