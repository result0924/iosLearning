//
//  ViewController.swift
//  collectionViewTest
//
//  Created by justin on 2024/6/28.
//  Copyright © 2024 h2. All rights reserved.
//

import UIKit
import Kingfisher

struct TabStickerModel: Hashable {
    let id = UUID()
    let tab: String
    let stickers: [String]
}

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    typealias TabDataSource = UICollectionViewDiffableDataSource<Section, TabStickerModel>
    typealias StickerDataSource = UICollectionViewDiffableDataSource<Section, String>

    lazy var tabCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()

    lazy var stickerCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createStickerLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        return collectionView
    }()
    
    private var tabDataSource: TabDataSource?
    private var stickerDataSource: StickerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Inset Items Grid"
        configureHierarchy()
        configureDataSource()
        loadData()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        Task { @MainActor in
            selectFirstItem()
        }
    }
}

extension ViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemWidth: CGFloat = 54
        let padding: CGFloat = 4
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                               heightDimension: .absolute(itemWidth))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createStickerLayout() -> UICollectionViewLayout {
        let itemWidth: CGFloat = 98
        let verticalPadding: CGFloat = 14
        let numberOfItemsPerRow: CGFloat = 3
        
        let totalWidth = UIScreen.main.bounds.width
        let totalHorizontalPadding = (totalWidth - (itemWidth * numberOfItemsPerRow)) / (numberOfItemsPerRow + 1)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: verticalPadding,
            leading: 0,
            bottom: verticalPadding,
            trailing: 0
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(itemWidth + verticalPadding * 2)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(totalHorizontalPadding)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: totalHorizontalPadding, bottom: 0, trailing: totalHorizontalPadding)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func selectFirstItem() {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        tabCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: [])
        collectionView(tabCollectionView, didSelectItemAt: firstIndexPath)
    }
    
    func configureHierarchy() {
        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tabCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabCollectionView.backgroundColor = .systemBackground
        tabCollectionView.delegate = self
        view.addSubview(tabCollectionView)
        
        // Configure vertical collection view
        stickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createStickerLayout())
        stickerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        stickerCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stickerCollectionView.backgroundColor = .systemBackground
        stickerCollectionView.delegate = self
        view.addSubview(stickerCollectionView)
        
        NSLayoutConstraint.activate([
            tabCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabCollectionView.heightAnchor.constraint(equalToConstant: 54),
            
            stickerCollectionView.topAnchor.constraint(equalTo: tabCollectionView.bottomAnchor),
            stickerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, TabStickerModel> { (cell, indexPath, model) in
            cell.imageView.kf.setImage(with: URL(string: model.tab))
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.clipsToBounds = true
        }
        
        tabDataSource = UICollectionViewDiffableDataSource<Section, TabStickerModel>(collectionView: tabCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: TabStickerModel) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        
        // Configure vertical data source
        let verticalCellRegistration = UICollectionView.CellRegistration<ImageCell, String> { (cell, indexPath, urlString) in
            cell.imageView.kf.setImage(with: URL(string: urlString))
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.clipsToBounds = true
        }
        
        stickerDataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: stickerCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, urlString: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: verticalCellRegistration, for: indexPath, item: urlString)
        }
    }
    
    func loadData() {
        // Load data from your source
        let tab1 = "https://dev.health2sync.com/images/stickers/s_014.png"
        let sticker1 = [
            "https://dev.health2sync.com/images/stickers/s_014.png",
            "https://dev.health2sync.com/images/stickers/s_015.png",
            "https://dev.health2sync.com/images/stickers/s_016.png",
            "https://dev.health2sync.com/images/stickers/s_017.png",
            "https://dev.health2sync.com/images/stickers/s_018.png",
        ]
        
        let tab2 = "https://dev.health2sync.com/images/stickers/s_019.png"
        let sticker2 = [
            "https://dev.health2sync.com/images/stickers/s_019.png",
            "https://dev.health2sync.com/images/stickers/s_020.png",
            "https://dev.health2sync.com/images/stickers/s_021.png",
            "https://dev.health2sync.com/images/stickers/s_022.png",
            "https://dev.health2sync.com/images/stickers/s_023.png",
        ]
        
        let models = [
            TabStickerModel(tab: tab1, stickers: sticker1),
            TabStickerModel(tab: tab2, stickers: sticker2),
            TabStickerModel(tab: tab1, stickers: sticker1),
            TabStickerModel(tab: tab2, stickers: sticker2),
            TabStickerModel(tab: tab1, stickers: sticker1),
            TabStickerModel(tab: tab2, stickers: sticker2),
            TabStickerModel(tab: tab1, stickers: sticker1),
            TabStickerModel(tab: tab2, stickers: sticker2),
            TabStickerModel(tab: tab1, stickers: sticker1),
            TabStickerModel(tab: tab2, stickers: sticker2),
            TabStickerModel(tab: tab1, stickers: sticker1),
            TabStickerModel(tab: tab2, stickers: sticker2),
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, TabStickerModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        tabDataSource?.apply(snapshot, animatingDifferences: false)
        
        if let firstModel = models.first {
            updateStickerDataSource(with: firstModel.stickers)
        }
    }
    
    func updateStickerDataSource(with stickers: [String]) {
        var stickerSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        stickerSnapshot.appendSections([.main])
        stickerSnapshot.appendItems(stickers)
        stickerDataSource?.apply(stickerSnapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCell else { return }
            cell.contentView.backgroundColor = UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1)
            
            // Deselect other cells
            for visibleCell in collectionView.visibleCells {
                if let visibleImageCell = visibleCell as? ImageCell, visibleImageCell != cell {
                    visibleImageCell.contentView.backgroundColor = .clear
                }
            }
            
            // Get the selected TabStickerModel
            if let selectedModel = tabDataSource?.itemIdentifier(for: indexPath) {
                // Update stickerCollectionView with the selected model's stickerImageURLs
                updateStickerDataSource(with: selectedModel.stickers)
            }
        }
        
        print("didSelectItemAt:\(indexPath.row)")
    }
}

class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

