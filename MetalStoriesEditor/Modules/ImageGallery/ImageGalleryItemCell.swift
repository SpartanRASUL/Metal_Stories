//
//  ImageGalleryItemCell.swift
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 29.11.2020.
//

import UIKit

final class ImageGalleryItemCell: UICollectionViewCell {
    
    var additionalHeight: CGFloat = 0 {
        didSet {
            //recalculateAspectFit()
        }
    }
    
    private var imageView: UIImageView?
    private var imageViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func createView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        //recalculateAspectFit()
        
        self.imageView = imageView
    }
    
    private func recalculateAspectFit() {
        let constraint: NSLayoutConstraint?
        
        if imageViewHeightConstraint != nil {
            constraint = imageViewHeightConstraint
            constraint?.constant = 60 + additionalHeight
        } else {
            constraint = imageView?.heightAnchor.constraint(equalToConstant: 60 + additionalHeight)
        }
        
        constraint?.isActive = true
        imageView?.updateConstraints()
    }
    
}
