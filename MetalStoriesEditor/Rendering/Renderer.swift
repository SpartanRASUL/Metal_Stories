//
//  Renderer.swift
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 16.12.2020.
//

import MetalKit

protocol Renderer {
    var drawableSize: CGSize { get }
    
    func render(
        on inputTexture: MTLTexture,
        passDescriptor: MTLRenderPassDescriptor,
        completed: @escaping (MTLTexture) -> Void
    )
}

final class LinearTransitionRenderer: Renderer {
    let drawableSize: CGSize
    
    //TODO: rewrite for better architecture
    private let device: MTLDevice
    private let pipelineState: MTLComputePipelineState
    private let commandQueue: MTLCommandQueue
    private let texture: MTLTexture
    private let color: CGColor
    
    private let threadgroupSize = MTLSize(width: 16, height: 16, depth: 1)
    private let threadgroupCount: MTLSize
    
    private var currentFrameNumber = 0
    
    init?(image: UIImage, overlayColor: UIColor) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue(),
            let library = device.makeDefaultLibrary(),
            let function = library.makeFunction(name: "linear"),
            let pipelineState = try? device.makeComputePipelineState(function: function),
            let image = image.cgImage,
            let texture = try? MTKTextureLoader(device: device).newTexture(cgImage: image, options: [:])
        else {
            //TODO: Change this to Error
            return nil
        }
        
        threadgroupCount = MTLSize(
            width: (image.width + threadgroupSize.width) / threadgroupSize.width,
            height: (image.height + threadgroupSize.height) / threadgroupSize.height,
            depth: 1
        )
        
        self.drawableSize = CGSize(width: image.width, height: image.height)
        self.device = device
        self.commandQueue = commandQueue
        self.pipelineState = pipelineState
        self.color = overlayColor.cgColor
        self.texture = texture
    }
    
    func render(
        on inputTexture: MTLTexture,
        passDescriptor: MTLRenderPassDescriptor,
        completed: @escaping (MTLTexture) -> Void
    ) {
        guard
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let encoder = commandBuffer.makeComputeCommandEncoder()
        else {
            print("failed to render")
            return
        }
        
        var complete = simd_float1(calculateOverlay())
        print(complete)
        
        encoder.setComputePipelineState(pipelineState)
        encoder.setTexture(texture, index: 0)
        encoder.setTexture(inputTexture, index: 1)
        encoder.setBytes(&complete, length: MemoryLayout<simd_float1>.size, index: 0)
        encoder.dispatchThreadgroups(threadgroupCount, threadsPerThreadgroup: threadgroupSize)
        encoder.endEncoding()
        completed(inputTexture)
        commandBuffer.commit()
        //this method actually blocks execution thread, so better to add completion handler
        //but fir this app, we don't need ultra render speed, but we need a serial-ish execution.
        commandBuffer.waitUntilCompleted()
        currentFrameNumber += 1
    }
    
    private func calculateOverlay() -> CGFloat {
        let delay = Int(60)
        guard currentFrameNumber > delay else {
            return 0
        }
        return min(CGFloat(currentFrameNumber - delay) / 120, 1)
    }
}
