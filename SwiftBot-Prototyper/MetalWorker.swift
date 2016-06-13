import Cocoa
import SwiftBot
import Metal
import QuartzCore
import CoreVideo
import simd

let device = MTLCreateSystemDefaultDevice()!
let commandQueue = device.newCommandQueue()

var metalLayer : CAMetalLayer! = nil

var mapBufferSource : BufferSource! = nil
var pipeline : MTLRenderPipelineState! = nil
var displayLink : CVDisplayLink? = nil



func beginRendering(hostLayer: CALayer, level: Level) {
    
    metalLayer = CAMetalLayer()
    metalLayer.device = device
    metalLayer.pixelFormat = .BGRA8Unorm
    metalLayer.framebufferOnly = true
    metalLayer.frame = hostLayer.frame
    
    hostLayer.addSublayer(metalLayer)
    
    // TODO: This is a weird code smell. 
    // Is this the right place to do this?
    SwiftBot.renderingLevel = level
    
    let tiles = level.map.size.width * level.map.size.height
    let tileVertices = tiles * 6
    let robotVertices = 9 // Drawing the robot takes 3 triangles
    let bufferSize = (tileVertices + robotVertices) * 8
    mapBufferSource = BufferSource(device: device, numBuffers: 3, bufferSize: bufferSize)
    
    
    let library = device.newDefaultLibrary()!
    let vertexShader = library.newFunctionWithName("tile_vertex_shader")
    let fragmentShader = library.newFunctionWithName("tile_fragment_shader")
    
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexShader
    pipelineDescriptor.fragmentFunction = fragmentShader
    pipelineDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
    
    pipeline = try! device.newRenderPipelineStateWithDescriptor(pipelineDescriptor)
    
    let displayId = CGMainDisplayID()
    CVDisplayLinkCreateWithCGDisplay(displayId, &displayLink)
    CVDisplayLinkSetOutputCallback(displayLink!, drawFrame, nil)
    CVDisplayLinkStart(displayLink!)
}

func drawFrame(displayLink: CVDisplayLink,
               _ inNow: UnsafePointer<CVTimeStamp>,
                 _ inOutputTime:  UnsafePointer<CVTimeStamp>,
                   _ flagsIn: CVOptionFlags,
                     _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                       _ displayLinkContext: UnsafeMutablePointer<Void>) -> CVReturn {
    autoreleasepool {
        let vertices = updateAndRender(1.0 / 60.0)
        render(vertices)
    }
    
    return kCVReturnSuccess
}

func render(vertices: [Float]) {
    
//    let vertexBuffer = nextBuffer(mapBufferSource)
//    memcpy(vertexBuffer.contents(), vertices, vertices.count * sizeof(Float))
    
    let vertexBuffer = device.newBufferWithBytes(vertices, length: vertices.count * sizeof(Float), options: [])
    
    let commandBuffer = commandQueue.commandBuffer()
    
    let drawable = metalLayer.nextDrawable()!
    
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .Clear
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
    renderEncoder.setRenderPipelineState(pipeline)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
    renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertices.count / 8)
    renderEncoder.endEncoding()
    
    commandBuffer.presentDrawable(drawable)
    commandBuffer.addCompletedHandler({ commandBuffer in
        dispatch_semaphore_signal(mapBufferSource.bufferSemaphore)
    })
    commandBuffer.commit()
}
