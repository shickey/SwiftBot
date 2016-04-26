//: [Previous](@previous)

setup(2)

/*:

# Looping!

This map is just like the first map from last session, except this time **we don't know how long the hallway is**.

![How long is the hallway?](hallway_length.png)

## Your Goal
Get SwiftBot to move to the end of the hallway and drop a cookie in the final square. Remember, the hallway may be a different length each time we run the program, so your instructions should work for every case!

![Goal](hallway_goal.png)

## `canGoForward()`
SwiftBot has one other instruction we haven't used yet. The `canGoForward()` instruction allow SwiftBot to sense if they can go forward or if they can't (i.e., there's a wall in front of them). We can use `canGoForward()` in an `if` statement, the same way we use `senseCookie()`

    if canGoForward() {
        // This code will only get run if there's
        // no wall in front of SwiftBot
    }

However, this still doesn't help us in this case because we don't know how many times we need to move forward! Enter the `while` statement:

## The `while` statement
The `while` statement is similar to the `if` statement in that it will allow a chunk of code to run only when a condition is true (e.g., `canGoForward()`). However, it is different than `if` because the code inside the `while` statement will **run over and over again until the condition is false**. That is, each time we get to the end of the code inside the while statement, we go back up to the top and run the code again, as long as the condition is true. E.g.,

    while canGoForward() {
        // These lines of code will run
        // over and over again until
        // SwiftBot can't go forward anymore
    }

Use a while loop in your instructions below to get SwiftBot to move to the wall then place a cookie once it reaches the end.

*/

instructions = {
    
    
    
}

//: [Next](@next)
