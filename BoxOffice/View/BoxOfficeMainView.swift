//
//  BoxOfficeMainView.swift
//  BoxOffice
//
//  Created by EtialMoon, Minsup on 2023/08/13.
//

import UIKit

final class BoxOfficeMainView: UIView {
    typealias IconSize = BoxOfficeMainViewController.Layout.IconSize
    
    let boxOfficeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        return collectionView
    }()
    
    let indicatorView = UIActivityIndicatorView()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        configureCollectionViewListLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionViewReloadItem(indexPaths: [IndexPath]) {
        boxOfficeCollectionView.reloadItems(at: indexPaths)
    }
    
    func collectionViewReloadData() {
        boxOfficeCollectionView.reloadData()
    }
    
    func configureCollectionViewListLayout() {
        boxOfficeCollectionView.register(cellClass: BoxOfficeCollectionViewListCell.self)
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        boxOfficeCollectionView.collectionViewLayout = layout
    }
    
    func configureCollectionViewIconLayout(size: CGSize) {
        boxOfficeCollectionView.register(cellClass: BoxOfficeCollectionViewIconCell.self)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(size.width),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 12,
            bottom: 8,
            trailing: 12
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(size.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        boxOfficeCollectionView.collectionViewLayout = layout
    }
}

// MARK: - Configure UI

extension BoxOfficeMainView {
    private func configureUI() {
        setUpView()
        addSubviews()
        setUpConstraints()
    }
    
    private func setUpView() {
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        [boxOfficeCollectionView, indicatorView].forEach {
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        setUpBoxOfficeCollectionViewConstraints()
        setUpIndicatorViewConstraints()
    }
    
    private func setUpBoxOfficeCollectionViewConstraints() {
        boxOfficeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            boxOfficeCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            boxOfficeCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            boxOfficeCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            boxOfficeCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setUpIndicatorViewConstraints() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
