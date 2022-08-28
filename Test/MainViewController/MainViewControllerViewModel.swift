//
//  File.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import RxSwift

protocol MainViewControllerViewModelProtocol {
    var shopData: InputData? { get set }
    var fetchPublisher: Observable<InputData> { get set }
    var disposedBad: DisposeBag { get }
    func setFilterViewHeight() -> CGFloat
}

final class MainViewControllerViewModel: MainViewControllerViewModelProtocol {
    private let fetchAdress = "https://run.mocky.io/v3/654bd15e-b121-49ba-a588-960956b15175"
    private var filterViewHeight: CGFloat = 0
    var shopData: InputData?
    var fetchPublisher: Observable<InputData>
    var disposedBad = DisposeBag()
    
    init() {
        let fetchResultSender = PublishSubject<InputData>()
        
        fetchPublisher = NetworkManager().performGet(urlString: fetchAdress)
        
        fetchPublisher.bind { data in
            fetchResultSender.onNext(data)
        }.disposed(by: disposedBad)
    }
    
    func setFilterViewHeight() -> CGFloat {
        switch filterViewHeight {
        case 0:
            filterViewHeight = -(UIScreen.main.bounds.height * 0.3)
            return filterViewHeight
        default: 
            filterViewHeight = UIScreen.main.bounds.height * 0.3
            return filterViewHeight
        }
    }
}
