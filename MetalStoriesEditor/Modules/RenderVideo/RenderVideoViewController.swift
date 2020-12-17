//
//  RenderVideoViewController.swift
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 13.12.2020.
//

import UIKit
import MetalKit

final class RenderVideoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayLink?.isPaused = false
    }
    
    var renderer: Renderer? {
        didSet {
            guard let renderer = renderer else {
                return
            }
            renderView?.drawableSize = renderer.drawableSize
        }
    }
    
    //MARK: - Private
    
    private var renderView: MTKView?
    private var displayLink: CADisplayLink?
    
    private func createViews() {
        let mtkView = MTKView()
        mtkView.backgroundColor = .white
        //TODO: Move this to renederer class
        mtkView.clearColor = MTLClearColorMake(1, 1, 1, 1)
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.device = MTLCreateSystemDefaultDevice()
        view.addSubview(mtkView)
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //Better to use safeAreaLayoutGuide for leading and trailing anchors too, if you
            //will support horizontal orientation. But i won't, so don't care
            mtkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mtkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mtkView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mtkView.heightAnchor.constraint(equalTo: mtkView.widthAnchor, multiplier: 16/9)
        ])
        
        mtkView.delegate = self
        mtkView.framebufferOnly = false
        
        displayLink = CADisplayLink(target: self, selector: #selector(render))
        displayLink?.preferredFramesPerSecond = 60
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc private func render() {
        guard let view = renderView else {
            return
        }
        draw(in: view)
    }
}

extension RenderVideoViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard
            let drawable = view.currentDrawable,
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let renderer = self.renderer
        else {
            if self.renderer != nil {
                print("Dropped frame")
            }
            return
        }
        
        renderer.render(
            on: drawable.texture,
            passDescriptor: renderPassDescriptor, completed: { _ in
                view.currentDrawable?.present()
            }
        )
    }
}
