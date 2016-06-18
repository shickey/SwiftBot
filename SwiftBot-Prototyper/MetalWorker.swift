import Cocoa
import Metal
import QuartzCore
import CoreVideo
import simd

let device = MTLCreateSystemDefaultDevice()!
let commandQueue = device.newCommandQueue()

var metalLayer : CAMetalLayer! = nil

var pipeline : MTLRenderPipelineState! = nil
var displayLink : CVDisplayLink? = nil

let libSwiftBotPath = "/Users/seanhickey/Library/Developer/Xcode/DerivedData/SwiftBot-adchmvnplykviremwidjfmfzobcv/Build/Products/Debug/libSwiftBot.dylib"
typealias updateAndRenderSignature = @convention(c) (Double, UnsafeMutablePointer<Void>) -> (Int)

typealias dylibHandle = UnsafeMutablePointer<Void>
var libSwiftBot : dylibHandle = nil
var lastModTime : NSDate! = nil
var updateAndRender : ((Double, UnsafeMutablePointer<Void>) -> (Int))! = nil

let MAX_VERTICES = 0xFFFF // 65535
var renderMemory : UnsafeMutablePointer<Void> = nil

func beginRendering(hostLayer: CALayer) {
    
    metalLayer = CAMetalLayer()
    metalLayer.device = device
    metalLayer.pixelFormat = .BGRA8Unorm
    metalLayer.framebufferOnly = true
    metalLayer.frame = hostLayer.frame
    
    hostLayer.addSublayer(metalLayer)
    
    let library = device.newDefaultLibrary()!
    let vertexShader = library.newFunctionWithName("tile_vertex_shader")
    let fragmentShader = library.newFunctionWithName("tile_fragment_shader")
    
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexShader
    pipelineDescriptor.fragmentFunction = fragmentShader
    pipelineDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
    
    pipeline = try! device.newRenderPipelineStateWithDescriptor(pipelineDescriptor)
    
    try! getLastWriteTime(libSwiftBotPath)
    loadLibSwiftBot()
    
    renderMemory = malloc(MAX_VERTICES * 8 * sizeof(Float))
    
    let displayId = CGMainDisplayID()
    CVDisplayLinkCreateWithCGDisplay(displayId, &displayLink)
    CVDisplayLinkSetOutputCallback(displayLink!, drawFrame, nil)
    CVDisplayLinkStart(displayLink!)
}

func loadLibSwiftBot() {
    libSwiftBot = dlopen(libSwiftBotPath, RTLD_LAZY|RTLD_GLOBAL)
    let updateAndRenderSym = dlsym(libSwiftBot, "_TF8SwiftBot15updateAndRenderFTSd12renderMemoryGSpT___Si")
    updateAndRender = unsafeBitCast(updateAndRenderSym, updateAndRenderSignature.self)
    lastModTime = try! getLastWriteTime(libSwiftBotPath)
}

func unloadLibSwiftBot() {
    updateAndRender = nil
    dlclose(libSwiftBot)
    dlclose(libSwiftBot) // THIS IS AWFUL. But ObjC runtimes opens all opened dylibs so you *have* to unload twice in order to get the reference count down to 0
    libSwiftBot = nil
}

func getLastWriteTime(filePath : String) throws -> NSDate {
    let attrs = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath)
    return attrs[NSFileModificationDate] as! NSDate
}

var lastFrameTime : Int64! = nil

func drawFrame(displayLink: CVDisplayLink,
               _ inNow: UnsafePointer<CVTimeStamp>,
                 _ inOutputTime:  UnsafePointer<CVTimeStamp>,
                   _ flagsIn: CVOptionFlags,
                     _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                       _ displayLinkContext: UnsafeMutablePointer<Void>) -> CVReturn {
    autoreleasepool {
        do {
            let libSwiftBotWriteTime = try getLastWriteTime(libSwiftBotPath)
            if libSwiftBotWriteTime.compare(lastModTime!) == .OrderedDescending {
                unloadLibSwiftBot()
                loadLibSwiftBot()
                print("libSwiftBot reloaded")
            }
        } catch {
            print("Missed libSwiftBot live reload")
        } // Eat the error on purpose. If we can't reload this frame, we can try again next frame.
        
        let nextFrame = inOutputTime.memory
        
        var dt : Double = Double(nextFrame.videoRefreshPeriod) / Double(nextFrame.videoTimeScale)
        if lastFrameTime != nil {
            dt = Double(nextFrame.videoTime - lastFrameTime) / Double(nextFrame.videoTimeScale)
        }
        
        let numVerticesToDraw = updateAndRender(dt, renderMemory)
        render(renderMemory, numVerticesToDraw)
        
        lastFrameTime = nextFrame.videoTime
    }
    
    return kCVReturnSuccess
}

func render(vertices: UnsafeMutablePointer<Void>, _ vertexCount : Int) {
    
    let vertexBuffer = device.newBufferWithBytes(vertices, length: vertexCount * 8 * sizeof(Float), options: [])
    
    let commandBuffer = commandQueue.commandBuffer()
    
    let drawable = metalLayer.nextDrawable()!
    
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .Clear
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
    renderEncoder.setRenderPipelineState(pipeline)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
    renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount)
    renderEncoder.endEncoding()
    
    commandBuffer.presentDrawable(drawable)
    commandBuffer.commit()
}
