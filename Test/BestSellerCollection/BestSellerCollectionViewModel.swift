//
//  BestSellerCollectionViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import RxSwift

protocol BestSellerCollectionViewModelProtocol {
    var bestSellers: [BestSeller] { get set }
    var observableAccepterOfData: PublishSubject<[BestSeller]> { get }
    var disposeBag: DisposeBag { get }
    var observable: PublishSubject<String> { get }
}

final class BestSellerCollectionViewModel: BestSellerCollectionViewModelProtocol {
    var bestSellers: [BestSeller] = []
    var observableAccepterOfData: PublishSubject<[BestSeller]>
    let disposeBag = DisposeBag()
    var observable = PublishSubject<String>()
    
    init() {
        observableAccepterOfData = PublishSubject<[BestSeller]>()
        
        observableAccepterOfData.withUnretained(self).bind { sel, data in
            sel.bestSellers = data
        }.disposed(by: disposeBag)
        
    }
}
