//
//  PhotoCollectionView.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import UIKit

final class PhotoCollectionView: UICollectionView {
    
    var viewModel: PhotoCollectionViewViewModelProtocol? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }
    static let cellID = "DetailsViewCell"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: PhotoCollectionView.setLayout())
        register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCollectionView.cellID)
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func setLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.8)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: UIScreen.main.bounds.width * 0.05, bottom: UIScreen.main.bounds.width * 0.09, trailing: UIScreen.main.bounds.width * 0.05)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(UIScreen.main.bounds.width * 0.66), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        group.contentInsets.leading = UIScreen.main.bounds.width * 0.17
        group.contentInsets.trailing = UIScreen.main.bounds.width * 0.17
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = UIScreen.main.bounds.width * 0.17
        section.contentInsets.trailing = UIScreen.main.bounds.width * 0.17
        
        section.orthogonalScrollingBehavior = .paging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        
        return layout
    }
}

extension PhotoCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionView.cellID, for: indexPath) as! PhotoCell
        
        let cellViewModel = viewModel?.getCellViewModelWith(indexPath: indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.imageUrls.count ?? 0
    }
}
