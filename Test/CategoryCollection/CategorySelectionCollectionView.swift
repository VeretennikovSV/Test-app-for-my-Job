//
//  CustomClasses.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import UIKit

final class CategoryCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let viewModel: CategoryCollectionViewModelProtocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.buttonsInCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySelectionCell.cellId, for: indexPath) as! CategorySelectionCell
        
        cell.configureCellWith(viewModel: viewModel.configureCellViewModelWith(indexPath: indexPath))
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        
        return cell
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        viewModel = CategoryCollectionViewModel()
        super.init(frame: frame, collectionViewLayout: CategoryCollectionView.setLayout())
        
        self.register(CategorySelectionCell.self, forCellWithReuseIdentifier: CategorySelectionCell.cellId)
        
        dataSource = self
        delegate = self
        
        backgroundColor = Colors.shared.backgroundColor
        
        self.alwaysBounceVertical = false
    }
    
    static func setLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.leading = 8
        item.contentInsets.trailing = 8
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        
        return layout
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as! CategorySelectionCell).viewModel?.onTap.accept(())
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as! CategorySelectionCell).viewModel?.onTap.accept(())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
