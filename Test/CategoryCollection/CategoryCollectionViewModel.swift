//
//  CategoryCollectionViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation

protocol CategoryCollectionViewModelProtocol {
    var buttonsInCollection: [ButtonType] { get }
    func configureCellViewModelWith(indexPath: IndexPath) -> CategorySelectionCellViewModelProtocol
}

final class CategoryCollectionViewModel: CategoryCollectionViewModelProtocol {
    var buttonsInCollection: [ButtonType] = [
        .phones,
        .computers,
        .health,
        .books,
        .phones
    ]
    
    func configureCellViewModelWith(indexPath: IndexPath) -> CategorySelectionCellViewModelProtocol {
        CategorySelectionCellViewModel(buttonType: buttonsInCollection[indexPath.item])
    }
}
