//
//  ImageGalleryItem.swift
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 06.12.2020.
//

import UIKit

struct ImageGalleryItem: Hashable {
    let height: CGFloat
    let color: UIColor
    
    private let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: ImageGalleryItem, rhs: ImageGalleryItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
