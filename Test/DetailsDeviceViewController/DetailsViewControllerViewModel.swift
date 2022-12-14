//
//  DetailsViewControllerViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import RxRelay
import RxSwift

protocol DetailsViewControllerViewModelProtocol {
    var deviceDetails: DeviceDetails { get }
    var deviceDetailsLoaded: PublishSubject<DeviceDetails> { get }
    var disposeBag: DisposeBag { get }
}

final class DetailsViewControllerViewModel: DetailsViewControllerViewModelProtocol {
    var deviceDetails: DeviceDetails
    var deviceDetailsLoaded = PublishSubject<DeviceDetails>()
    var disposeBag = DisposeBag()
    
    init(details: DeviceDetails) {
        deviceDetails = details
    }
}
