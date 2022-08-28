//
//  CategorySelectionCellViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 26/08/2022.
//

import Foundation
import RxSwift
import RxRelay

internal enum ButtonType: String {
    case phones = "Phones"
    case computers = "Computer"
    case health = "Health"
    case books = "Books"
}

protocol CategorySelectionCellViewModelProtocol {
    var buttonType: ButtonType { get }
    var disposeBag: DisposeBag { get }
    var onTap: PublishRelay<Void> { get }
    func getButtonString() -> String 
}

final class CategorySelectionCellViewModel: CategorySelectionCellViewModelProtocol {
    var buttonType: ButtonType
    var disposeBag = DisposeBag()
    let onTap = PublishRelay<Void>()
    
    init(buttonType: ButtonType) {
        self.buttonType = buttonType
     
    }
    
    
    func getButtonString() -> String {
        buttonType.rawValue
    }
}
