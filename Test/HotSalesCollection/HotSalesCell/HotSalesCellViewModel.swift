//
//  HotSalesCellViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 24/08/2022.
//

import Foundation
import RxSwift

protocol HotSalesCellViewModelProtocol {
    var cellContent: HomeStore { get } 
    var disposeBag: DisposeBag { get }
    var imageLoader: PhotoCache { get }
}

final class HotSalesCellViewModel: HotSalesCellViewModelProtocol {
    let cellContent: HomeStore
    let disposeBag = DisposeBag()
    let imageLoader = PhotoCache()
    
    init(cellContent: HomeStore) {
        self.cellContent = cellContent
    }
}
