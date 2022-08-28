//
//  HotSalesCollectionViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import RxSwift

protocol HotSalesCollectionViewModelProtocol {
    var hotSalesCollectionData: [HomeStore] { get set }
    var observableAccepterOfData: PublishSubject<[HomeStore]> { get }
    var disposeBag: DisposeBag { get }
    
    func setCellViewModelWith(indexPath: IndexPath) -> HotSalesCellViewModelProtocol
}

final class HotSalesCollectionViewModel: HotSalesCollectionViewModelProtocol {
    var hotSalesCollectionData: [HomeStore] = []
    var observableAccepterOfData: PublishSubject<[HomeStore]>
    let disposeBag = DisposeBag()
    
    init() {
        observableAccepterOfData = PublishSubject<[HomeStore]>()
        
        observableAccepterOfData
            .withUnretained(self)
            .bind { sel, data in
                sel.hotSalesCollectionData = data
            }.disposed(by: disposeBag)
    }
    
    func setCellViewModelWith(indexPath: IndexPath) -> HotSalesCellViewModelProtocol {
        HotSalesCellViewModel(cellContent: hotSalesCollectionData[indexPath.item])
    }
}
