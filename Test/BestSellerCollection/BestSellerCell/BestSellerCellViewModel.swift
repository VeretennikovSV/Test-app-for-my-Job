//
//  BestSellerCellViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 25/08/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol BestSellerCellViewModelProtocol {
    var onTap: PublishRelay<Void> { get }
    var observableUrl: Observable<String> { get }
    var cellContent: BestSeller { get }
    var imageLoader: PhotoCache { get }
    var disposeBag: DisposeBag { get }
    
    func getImageName() -> String
    func changeStateOfButton()
}

final class BestSellerCellViewModel: BestSellerCellViewModelProtocol {
    var cellContent: BestSeller
    let imageLoader = PhotoCache()
    let disposeBag = DisposeBag()
    var onTap = PublishRelay<Void>()
    var observableUrl: Observable<String>
    
    init(cellContent: BestSeller) {
        
        if UserDefaultsManager.shared?.getIsFavoriteStatus(key: "\(cellContent.title)", url: cellContent.picture) == nil {
            UserDefaultsManager.shared?.saveToUserDefaults(boolean: cellContent.isFavorites, andKey: "\(cellContent.title)")
        }
        
        let subject = PublishSubject<String>()
        
        observableUrl = subject.asObservable()
        
        onTap.bind { _ in
            subject.onNext("https://run.mocky.io/v3/6c14c560-15c6-4248-b9d2-b4508df7d4f5")
        }.disposed(by: disposeBag)
        
        self.cellContent = cellContent
    }
    
    func getImageName() -> String {
        guard let isFavorite: Bool = UserDefaultsManager.shared?.getIsFavoriteStatus(key: "\(cellContent.title)", url: cellContent.picture) else { return "HeartFilled" }
        return isFavorite ? "HeartFilled" : "HeartNotFilled"
        
    }
    
    func changeStateOfButton() {
        cellContent.isFavorites.toggle()
        UserDefaultsManager.shared?.saveToUserDefaults(boolean: cellContent.isFavorites, andKey: "\(cellContent.title)")
    }
}
