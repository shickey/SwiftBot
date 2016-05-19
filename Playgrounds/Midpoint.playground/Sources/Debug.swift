import Foundation

public func printStackTrace() {
    let symbols = NSThread.callStackSymbols()
    for symbol in symbols {
        print(symbol)
    }
}