//
//  ViewController.swift
//  SwiftBot-Prototyper
//
//  Created by Sean Hickey on 6/12/16.
//
//

import Cocoa
import SwiftBot
import Metal
import QuartzCore
import CoreVideo
import simd

let device = MTLCreateSystemDefaultDevice()!
let commandQueue = device.newCommandQueue()

var metalLayer : CAMetalLayer! = nil

var mapVertices : [Float] = []
var levelTransform : float4x4 = float4x4(1.0)

var mapBufferSource : BufferSource! = nil
var pipeline : MTLRenderPipelineState! = nil
var displayLink : CVDisplayLink? = nil

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        
    }
    
    override func viewDidAppear() {
        setup(0)
    }


    func buildMapVertices(map: Map) {
        
        for y in 0..<map.size.height {
            for x in 0..<map.size.width {
                
                let originX = Float(x);
                let originY = Float(y);
                
                var color : float4 = float4(1.0, 1.0, 1.0, 1.0)
                if map.tileAtLocation(Point(x, y)) == .Wall {
                    color = float4(0.0, 0.0, 1.0, 1.0)
                }
                
                let v0 = float4(originX,       originY,       0.0, 1.0)
                let v1 = float4(originX + 1.0, originY,       0.0, 1.0)
                let v2 = float4(originX + 1.0, originY + 1.0, 0.0, 1.0)
                let v3 = float4(originX,       originY + 1.0, 0.0, 1.0)
                
                let quad = Quad(v0, v1, v2, v3, color)
                
                mapVertices += quad.data
            }
        }
        
        let scale : Float = 2.0 / Float(map.size.width)
        levelTransform[0][0] = scale
        levelTransform[1][1] = -scale
        
        // Invert y and move map into position
        levelTransform[3][0] = -1.0
        levelTransform[3][1] = 1.0
        
    }

    func setup(levelIndex : Int) {
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .BGRA8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.frame
        
        view.layer?.addSublayer(metalLayer)
        
        let level = levels[0]
        
        buildMapVertices(level.map)
        mapBufferSource = BufferSource(device: device, numBuffers: 3, bufferSize: mapVertices.count * sizeof(Float))
        
        
//        let shaderSourceString = try! String(contentsOfURL: NSBundle.mainBundle().URLForResource("Shaders", withExtension: "metal")!)
        let library = device.newDefaultLibrary()!
//        let library = try! device.newLibraryWithSource(shaderSourceString, options: nil)
        let vertexShader = library.newFunctionWithName("tile_vertex_shader")
        let fragmentShader = library.newFunctionWithName("tile_fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader
        pipelineDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        pipeline = try! device.newRenderPipelineStateWithDescriptor(pipelineDescriptor)
        
        let displayId = CGMainDisplayID()
        CVDisplayLinkCreateWithCGDisplay(displayId, &displayLink)
        CVDisplayLinkSetOutputCallback(displayLink!, drawLoop, nil)
        CVDisplayLinkStart(displayLink!)
    }

}

func drawLoop(displayLink: CVDisplayLink,
              _ inNow: UnsafePointer<CVTimeStamp>,
                _ inOutputTime:  UnsafePointer<CVTimeStamp>,
                  _ flagsIn: CVOptionFlags,
                    _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                      _ displayLinkContext: UnsafeMutablePointer<Void>) -> CVReturn {
    autoreleasepool {
        render()
    }
    
    return kCVReturnSuccess
}

func render() {
    
    let vertexBuffer = nextBuffer(mapBufferSource)
    memcpy(vertexBuffer.contents(), mapVertices, mapVertices.count * sizeof(Float))
    
    let transformBuffer = device.newBufferWithBytes([levelTransform], length: sizeof(float4x4), options: [])
    
    let commandBuffer = commandQueue.commandBuffer()
    
    let drawable = metalLayer.nextDrawable()!
    
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .Clear
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
    renderEncoder.setRenderPipelineState(pipeline)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
    renderEncoder.setVertexBuffer(transformBuffer, offset: 0, atIndex: 1)
    renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: mapVertices.count / 8)
    renderEncoder.endEncoding()
    
    commandBuffer.presentDrawable(drawable)
    commandBuffer.addCompletedHandler({ commandBuffer in
        dispatch_semaphore_signal(mapBufferSource.bufferSemaphore)
    })
    commandBuffer.commit()
}