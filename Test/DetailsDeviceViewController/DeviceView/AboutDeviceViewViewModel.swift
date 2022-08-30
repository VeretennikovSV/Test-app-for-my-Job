//
//  AboutDeviceViewViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import RxSwift

protocol AboutDeviceViewViewModelProtocol {
    var deviceDetails: DeviceDetails { get }
    var acceptDeviceDetails: PublishSubject<DeviceDetails> { get }
    var disposeBag: DisposeBag { get }
}

final class AboutDeviceViewViewModel: AboutDeviceViewViewModelProtocol {
    var deviceDetails: DeviceDetails
    
    var acceptDeviceDetails = PublishSubject<DeviceDetails>()
    var disposeBag = DisposeBag()
    
    init(details: DeviceDetails) {
        deviceDetails = details
    }
}
