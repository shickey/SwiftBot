import UIKit
import XCPlayground

setup()

instructions = {
    
    while canGoNorth() {
        goNorth()
    }
    
}

run({XCPlaygroundPage.currentPage.finishExecution()})

