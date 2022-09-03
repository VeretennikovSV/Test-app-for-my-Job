//
//  CartViewViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 01/09/2022.
//

import Foundation
import RxSwift

protocol CartViewViewModelProtocol {
    var cart: [String: Int] { get }
    var cartDevices: [String] { get }
    var disposeBag: DisposeBag { get } 
    func reloadData()
    func setCellViewModelWith(indexPath: IndexPath) -> CellViewModelProtocol
}

final class CartViewViewModel: CartViewViewModelProtocol {
    var cart = [String: Int]()
    var cartDevices = [String]()
    let disposeBag = DisposeBag()
    
    init() {
        getData()
    }
    
    private func getData() {
        cart = UserDefaultsManager.shared?.getCartDevices() ?? [:]
        cartDevices = cart.keys.sorted()
    }
    
    func reloadData() {
        getData()
    }
    
    func setCellViewModelWith(indexPath: IndexPath) -> CellViewModelProtocol {
        CellViewModel(cellDeviceUrl: cartDevices[indexPath.row])
    }
    
}
