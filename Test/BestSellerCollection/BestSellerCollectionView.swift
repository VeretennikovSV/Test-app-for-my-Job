//
//  BestSellerCollectionView.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import UIKit
import RxSwift


final class BestSellerCollectionView: UICollectionView {
    
    let viewModel: BestSellerCollectionViewModelProtocol
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        viewModel = BestSellerCollectionViewModel()
        super.init(frame: frame, collectionViewLayout: BestSellerCollectionView.setLayout())
        
        self.register(BestSellerCell.self, forCellWithReuseIdentifier: BestSellerCell.cellId)
        dataSource = self
        delegate = self
        
        setBinding()
        backgroundColor = Colors.shared.backgroundColor
        
        self.alwaysBounceVertical = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBinding() {
        viewModel.observableAccepterOfData
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { sel, _ in
                sel.reloadData()
            }.disposed(by: viewModel.disposeBag)
    }
    
    static func setLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1)))
        item.contentInsets.leading = 8
        item.contentInsets.trailing = 8
        item.contentInsets.bottom = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 2)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 8
        section.contentInsets.trailing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .vertical
        
        return layout
    }
}

extension BestSellerCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestSellerCell.cellId, for: indexPath) as! BestSellerCell
        
        let viewModel = BestSellerCellViewModel(cellContent: viewModel.bestSellers[indexPath.item])
        cell.configureCellWith(viewModel: viewModel)
        cell.viewModel?.observableUrl.bind(onNext: { self.viewModel.observable.onNext($0) }).disposed(by: viewModel.disposeBag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? BestSellerCell)?.viewModel?.onTap.accept(())
        
    }
    
} 
