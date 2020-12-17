//
//  ViewController.swift
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 29.11.2020.
//

import UIKit

final class CompositionViewController: UIViewController {
    
    override func loadView() {
        self.view = createView()
    }
    
    //MARK: - UI Related
    
    private func createView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        let playButton = UI.makePlayButton()
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(openRenderView), for: .touchUpInside)
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let contentView = UI.makeContentView()
        view.addSubview(contentView)
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery)))
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 8),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 16/9)
        ])
        
        return view
    }
    
    //To not spam viewcontroller with useless functions
    private struct UI {
        static func makePlayButton() -> UIButton {
            let button = UIButton()
            button.backgroundColor = .clear
            button.setImage(UIImage(systemName: "eye"), for: .normal)
            button.tintColor = .white
            button.titleLabel?.textAlignment = .center
            //make the touch area bigger
            button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
            return button
        }
        
        static func makeContentView() -> UIView {
            let view = UIView()
            view.backgroundColor = .white
            
            let addPhotoView = makeAddPhotoView()
            view.addSubview(addPhotoView)
            addPhotoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addPhotoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                addPhotoView.widthAnchor.constraint(lessThanOrEqualToConstant: 150)
            ])
            
            return view
        }
        
        static func makeAddPhotoView() -> UIView {
            let view = UIStackView()
            view.distribution = .fillProportionally
            view.alignment = .center
            view.spacing = 8
            view.axis = .vertical
            
            let imageView = UIImageView(image: UIImage(systemName: "doc.badge.plus"))
            imageView.tintColor = .gray
            imageView.contentMode = .scaleAspectFit
            imageView.setContentHuggingPriority(.required, for: .vertical)
            imageView.setContentCompressionResistancePriority(.required, for: .vertical)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 45),
                imageView.widthAnchor.constraint(equalToConstant: 45)
            ])
            
            let label = UILabel()
            label.text = "Добавить\nфото или видео"
            label.textColor = .gray
            label.numberOfLines = 2
            label.textAlignment = .center
            label.setContentHuggingPriority(.required, for: .vertical)
            view.addArrangedSubview(label)
            
            return view
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc private func openGallery() {
        let galleryVC = ImageGalleryViewController()
        present(galleryVC, animated: true)
    }
    
    @objc private func openRenderView() {
        let renderView = RenderVideoViewController()
        renderView.renderer = LinearTransitionRenderer(
            image: UIImage(named: "testimg")!,
            overlayColor: .white
        )
        present(renderView, animated: true)
    }
}

