import UIKit
import XCPlayground

setup()

rules = {
    
    for _ in 0..<10 {
        goNorth()
    }
    
}

run(completion: {XCPlaygroundPage.currentPage.finishExecution()})



