import UIKit
import XCPlayground
//let rules = {
///*:
//# Hello World!
//
//Type your instructions here:
//*/
//    // Write instructions for the bot here
///*:
//When you've finished, hit the run button below!
//*/
//
//}

var map = Map(size: Size(20, 20))

var maze = Map(mapString: "WWWWWWWWWWWWWWWWWWWWWWWWW\nW  W W   W   W   W   WW W\nWW W W W W W W W   W    W\nWW W WWW W W W WWWWWWWW W\nW  W     W W W   W    W W\nW WWW WWWW W W W W WW   W\nW          W W W W WWWWWW\nWWWWWWWWWWWW WWW W  W   W\nW  W   W   W   W WW W WWW\nWW W W   W W WWW  W W   W\nWW W WWWWW W W W WW W W W\nWW W     W   W    W WWW W\nWW WWWWW WW WWWWW W     W\nW      W WW     W WWW W W\nW WWWWWW W  WWW W   W W W\nW        W WW W WWW W W W\nWWWWWWWWWW W  W   W W W W\nW    W   WWW WWWW W W W W\nW WW W W        W W WWW W\nW  W W WWWWW WW W W W W W\nW WW W W W   W  W   W   W\nW W  W W   WWW WWWWWWW WW\nW WWWW W W   W W     W WW\nW      W WWW W   WWW   WW\nWWWWWWWWWWWWWWWWWWWWWWWWW")

//var view = RobotView(frame: CGRectMake(0, 0, 300, 300))
//view.map = map

print(maze)


//let rules = { (robot: Robot) in
//    
//    if robot.state == 0 {
//        
//        if robot.canGoNorth {
//            robot.goNorth()
//        }
//        else if robot.canGoWest {
//            robot.goWest()
//        }
//        
//    }
//    
//}

//XCPlaygroundPage.currentPage.liveView = view
