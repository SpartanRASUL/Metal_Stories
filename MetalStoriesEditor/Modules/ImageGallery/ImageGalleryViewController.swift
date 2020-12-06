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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    //MARK: - UI Related
    private var collectionView: UICollectionView?
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, ImageGalleryItem>?
    private var dataSource: UICollectionViewDiffableDataSource<Section, ImageGalleryItem>?
    
    private enum Section {
        case main
    }
    
    func configureDataSource() {
        guard let collectionView = self.collectionView else {
            preconditionFailure()
        }
        dataSource = UICollectionViewDiffableDataSource<Section, ImageGalleryItem>(collectionView: collectionView) {
            [weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: ImageGalleryItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UI.cellIdentifier, for: indexPath)
            cell.contentView.backgroundColor = self?.randomColor()
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            return cell
        }
        currentSnapshot = intialSnapshot()
        dataSource?.apply(currentSnapshot!, animatingDifferences: false)
    }
    
    private func intialSnapshot() -> NSDiffableDataSourceSnapshot<Section, ImageGalleryItem> {
        let itemCount = 200
        var items = [ImageGalleryItem]()
        for _ in 0..<itemCount {
            let height = CGFloat.random(in: 88..<121)
            let color = UIColor(hue:CGFloat.random(in: 0.1..<0.9), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            let item = ImageGalleryItem(height: height, color: color)
            items.append(item)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageGalleryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        return snapshot
    }
    
    private struct UI {
        static let cellIdentifier = "photoCell"
    }
    
    //MARK: - Logic
    
    
}

extension ImageGalleryViewController {
    
    private func createView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        let collectionView = makeCollectionView()
        collectionView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageGalleryItemCell.self, forCellWithReuseIdentifier: UI.cellIdentifier)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
        self.collectionView = collectionView
        
        return view
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
        
        return collectionView
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: provideSection)
        return layout
    }
    
    private func provideSection(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        //To be honest - based on this gist https://gist.github.com/breeno/f16330c5ef06075b0fc476c65d9b00d8
        var leadingGroupItems = [NSCollectionLayoutItem]()
        var trailingGroupItems = [NSCollectionLayoutItem]()
        guard
            let items = self.currentSnapshot?.itemIdentifiers,
            let numberOfItems = self.currentSnapshot?.numberOfItems
        else {
            preconditionFailure()
        }
        
        let totalHeight = items.reduce(0) { $0 + $1.height }
        let columnHeight = CGFloat(totalHeight / 2.0)
        
        //TODO: Add check for height of 2 columns, for the case when there is too different height of content
        
        var runningHeight = CGFloat(0.0)
        for index in 0..<numberOfItems {
            let item = items[index]
            let isLeading = runningHeight < columnHeight
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(item.height))
            let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
            
            runningHeight += item.height
            
            if isLeading {
                leadingGroupItems.append(layoutItem)
            } else {
                trailingGroupItems.append(layoutItem)
            }
        }
        
        //We just need 2 vertical groups to create a waterflow
        let screenHeight = UIScreen.main.bounds.height
        let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(screenHeight))
        let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitems:leadingGroupItems)
        
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(screenHeight))
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, subitems: trailingGroupItems)
        
        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(screenHeight))
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup, trailingGroup])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        return section
    }
    
    private func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .white, .blue, .brown, .cyan,
            .darkGray, .gray, .lightGray, .link,
            .orange, .red, .magenta
        ]
        
        let randomIndex = Int.random(in: 0..<colors.count)
        return colors[randomIndex]
    }
}
