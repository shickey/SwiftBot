/*:
 # SwiftBot!
 
 Welcome to SwiftBot! SwiftBot is a little orange robot that likes to explore. SwiftBot looks like this:
 
 ![SwiftBot](swiftbot.png)
 
 SwiftBot lives in a 2D room with blue walls. Open floor space is white in SwiftBot's world.
 
 ![SwiftBot's Enivronment](swiftbot_enviro.png)
 
 SwiftBot's goal is explore every square of floor space in their world. To help SwiftBot do this, we give SwiftBot instructions.
 
 ## SwiftBot Commands
 SwiftBot knows exactly 2 commands:
 
 ### `goForward()`
 The `goForward()` command will make SwiftBot move forward one space in the direction they're currently facing
 
 ### `turnLeft()`
 The `turnLeft()` command will make SwiftBot turn left in place (i.e., without leaving their current square)

 ## Programming SwiftBot

Over on the right, you should see SwiftBot in a simple room. Let's program SwiftBot to get them to explore the whole space!
 
 But first, we're going to need some setup. 

 **YOU CAN IGNORE THIS LINE OF CODE (but don't delete it!)**
 */

setup(0)

/*:
 Phew. Now that that's out of the way, let's write some instructions for SwiftBot. All instructions go inside the `instructions` block. Here's an example that will make SwiftBot move forward one space, turn left, then move forward two spaces:

    instructions = {

        goForward()
        turnLeft()
        goForward()
        goForward()

    }
 */
instructions = {
    
    // Write your instructions for SwiftBot below these lines!
    // Try writing goForward(), save, and see what happens.
    // Note that the parentheses are necessary!
    // Once that works, write the rest of the instructions (one per line)
    // to get SwiftBot to explore the whole room.
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
