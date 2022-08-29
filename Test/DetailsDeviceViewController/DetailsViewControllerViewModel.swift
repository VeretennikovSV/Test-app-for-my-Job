//
//  DetailsViewControllerViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation

protocol DetailsViewControllerViewModelProtocol {
    var deviceDetails: DeviceDetails { get }
}

final class DetailsViewControllerViewModel: DetailsViewControllerViewModelProtocol {
    var deviceDetails: DeviceDetails
    
    init(details: DeviceDetails) {
        deviceDetails = details
    }
}
