//
//  ImageGalleryViewController.swift
//  MetalStoriesEditor
//
//  Created by Murad Tataev on 29.11.2020.
//

import UIKit

final class ImageGalleryViewController: UIViewController {
    
    override func loadView() {
        self.view = createView()
    }
    
    
    //MARK: - UI Related
    
    private func createView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        photos = (0...250).map { (_) -> Int in
            Int.random(in: 0...60)
        }
        
        let collectionView = UI.makeCollectionView()
        collectionView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ImageGalleryItemCell.self, forCellWithReuseIdentifier: UI.cellIdentifier)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
        
        return view
    }
    
    private struct UI {
        static func makeCollectionView() -> UICollectionView {
            let collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: makeCollectionViewLayout()
            )
            
            return collectionView
        }
        
        private static func makeCollectionViewLayout() -> UICollectionViewLayout {
            //TODO: Deal with layout
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(1)
            ))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            ), subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return UICollectionViewCompositionalLayout(section: section)
        }
        
        static let cellIdentifier = "photoCell"
    }
    
    //MARK: - Logic
    
    private var photos: [Int] = []
}

extension ImageGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UI.cellIdentifier, for: indexPath)
        
        return cell
    }
    
}
