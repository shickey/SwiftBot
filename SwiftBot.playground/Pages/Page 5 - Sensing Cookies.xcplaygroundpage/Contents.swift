//: [Previous](@previous)

setup(3)

/*:

# Sensing Cookies

This map is just like the first one, except it starts with a **random number of cookies on the floor** (anywhere between 0 and 4).

## Your Goal
Clean up the cookies! At the end of your program, the map should look like:
![Cookies cleaned up!](sensingcookies_goal.png)

## Sensing
Since we don't know where the cookies will appear, we'll need some way to check if a square has a cookie on it. Luckily, SwiftBot can sense if they're on top of a cookie:

### `senseCookie()`
The `senseCookie()` instruction will tell SwiftBot whether there is a cookie on the current square or not. We usually use it in conjunction with an `if` statement:

## The `if` Statement
We can use the `if` statement to run code **only if a condition is true**. Here's an example:

    if senseCookie() {
        goForward()
        goForward()
    }

In this example, SwiftBot will first check if the current square has a cookie on it. If there is a cookie, SwiftBot will then move forward 2 squares. If not, SwiftBot will ignore the goForward() instructions entirely. Take note of the curly braces!

*/

instructions = {
    
    // Use if statements and standard
    // SwiftBot instructions here to pick
    // up all the cookies.
    //
    // Your solution should work no matter
    // how many cookies there are!
    
    
    
    
    
}

//: That's all for today, folks!
