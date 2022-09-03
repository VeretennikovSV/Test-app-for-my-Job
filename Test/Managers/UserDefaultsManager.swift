//
//  UserDefaultsManager.swift
//  Test
//
//  Created by Сергей Веретенников on 28/08/2022.
//

import Foundation
import RxSwift

final class UserDefaultsManager: Codable {
    
    private init() {}
    
    static let shared = UserDefaultsManager().getSelf()
    
    private var favorites = [String: String]() // Тут можно было бы сохранять ссылки на любимые девайсы

    private var cart = [String: Int]()
    
    private var devicePrices = [String: Double]()
    
    lazy var countOfDevices = PublishSubject<Int>()
    lazy var countOfExactDevice = PublishSubject<Int>()
    lazy var totalPriceSubject = PublishSubject<String>()
    
    private func getSelf() -> UserDefaultsManager? {
        
        if UserDefaults.standard.value(forKey: "Manager") == nil {
            saveSelf()
        }
        
        guard let userData = UserDefaults.standard.value(forKey: "Manager") as? Data else { 
            fatalError("Can't get userdefaults")
        }
        
        do {
            let selfData = try JSONDecoder().decode(UserDefaultsManager.self, from: userData)
            return selfData
        } catch {
            fatalError("Can't get userdefaults")
        }
    }
    
    func savePriceOfDevice(string: String, price: Double) {
        devicePrices[string] = price
    }
    
    func getTotalPrice() -> String {
        var price = 0.0
        cart.forEach { key, count in
            autoreleasepool { 
                price += devicePrices[key] ?? 0 * Double(count)
            }
        }
        return String(price)
    }
    
    func getCurrentDeviceCountWith(string: String) -> Int? {
        cart[string]
    }
    
    func saveSelf() {
        do {
            let selfData = try JSONEncoder().encode(self)
            UserDefaults.standard.set(selfData, forKey: "Manager")
        } catch {
            fatalError("Can't save userdefaults")
        }
    }
    
    func deleteFromCartWith(key: String) {
        defer { saveSelf()
            countOfDevices.onNext(cart.count)
            countOfExactDevice.onNext(cart[key] ?? 0) 
            totalPriceSubject.onNext(getTotalPrice())
        }
        guard cart[key] != 0 else { return }
        cart[key]? -= 1
        if cart[key] == 0 { cart[key] = nil }
    }
    
    func saveToCartWith(key: String) {
        defer { saveSelf()
            countOfDevices.onNext(cart.count)
            countOfExactDevice.onNext(cart[key] ?? 0) 
            totalPriceSubject.onNext(getTotalPrice())
        }
        guard cart[key] != nil else { cart[key] = 1; return }
        cart[key]? += 1
    }
    
    func getCartDevices() -> [String: Int] {
        cart
    }
    
    func getIsFavoriteStatus(key: String, url: String) -> Bool? {
        defer { saveSelf() }
        let isFavorite = UserDefaults.standard.value(forKey: key) as? Bool
        
        guard let isFavorite = isFavorite else { return nil }
        if isFavorite {
            favorites[key] = url
        } else {
            favorites.removeValue(forKey: key)
            favorites[key] = nil
        }
        
        return isFavorite 
    }
    
    func saveToUserDefaults<T>(value: T, andKey key: String) {
        defer { saveSelf() }
        UserDefaults.standard.set(value, forKey: key)
    }
    
    deinit {
        saveSelf()
    }
}
