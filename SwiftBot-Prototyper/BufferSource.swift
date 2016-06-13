import Metal
import Dispatch

class BufferSource {
    
    var buffers : [MTLBuffer] = []
    var nextBuffer : Int = 0
    let bufferSemaphore : dispatch_semaphore_t
    
    init(device: MTLDevice, numBuffers: Int, bufferSize: Int) {
        for _ in 0..<numBuffers {
            let newBuffer = device.newBufferWithLength(bufferSize, options: [])
            buffers.append(newBuffer)
        }
        
        bufferSemaphore = dispatch_semaphore_create(numBuffers)
    }
    
}

func nextBuffer(source: BufferSource) -> MTLBuffer {
    dispatch_semaphore_wait(source.bufferSemaphore, DISPATCH_TIME_FOREVER)
    let buffer = source.buffers[source.nextBuffer]
    source.nextBuffer += 1
    if source.nextBuffer >= source.buffers.count {
        source.nextBuffer = 0
    }
    return buffer
}
