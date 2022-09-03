//
//  CellViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 01/09/2022.
//

import Foundation
import RxSwift

protocol CellViewModelProtocol {
    var cellDeviceUrl: String { get }
    var cellDeviceDetails: DeviceDetails? { get set }
    var fetchDetails: Observable<DeviceDetails> { get }
    var disposeBag: DisposeBag { get }
    var imageLoader: PhotoCache { get }
    
    func getSummPrice() -> String
}

final class CellViewModel: CellViewModelProtocol {
    let cellDeviceUrl: String
    var cellDeviceDetails: DeviceDetails? {
        didSet {
            
        }
    }
    let fetchDetails: Observable<DeviceDetails>
    let disposeBag = DisposeBag()
    let imageLoader = PhotoCache()
    
    
    init(cellDeviceUrl: String) {
        self.cellDeviceUrl = cellDeviceUrl
        
        fetchDetails = NetworkManager().performGet(urlString: cellDeviceUrl)
        
        fetchDetails.bind { self.cellDeviceDetails = $0 }.disposed(by: disposeBag)
    }
    
    func getSummPrice() -> String {
        "\(Double(UserDefaultsManager.shared?.getCurrentDeviceCountWith(string: deviceURL) ?? 0) * Double(cellDeviceDetails?.price ?? 0))"
    }
}
