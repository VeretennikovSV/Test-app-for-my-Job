//
//  HotSalesCollectionView.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class HotSalesCollection: UICollectionView {
    
    var viewModel: HotSalesCollectionViewModelProtocol
    
    static func setLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.leading = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .paging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        
        return layout
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        viewModel = HotSalesCollectionViewModel()
        super.init(frame: frame, collectionViewLayout: HotSalesCollection.setLayout())
        
        self.register(HotSalesCell.self, forCellWithReuseIdentifier: HotSalesCell.cellID)
        
        dataSource = self
        delegate = self
        
        setBinding()
        backgroundColor = Colors.shared.backgroundColor
        
        self.alwaysBounceVertical = false
    }
    
    private func setBinding() {
        viewModel.observableAccepterOfData
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { sel, _ in
                sel.reloadData()
            }.disposed(by: viewModel.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HotSalesCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.hotSalesCollectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSalesCell.cellID, for: indexPath) as! HotSalesCell
        
        cell.configureCellWith(viewModel: viewModel.setCellViewModelWith(indexPath: indexPath))
        
        return cell
    }
} 
