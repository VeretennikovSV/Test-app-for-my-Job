//
//  UserDefaultsManager.swift
//  Test
//
//  Created by Сергей Веретенников on 28/08/2022.
//

import Foundation

final class UserDefaultsManager: Codable {
    
    private init() {}
    
    static let shared = UserDefaultsManager().getSelf()
    
    private var favorites = [String: String]() // Тут можно было бы сохранять ссылки на любимые девайсы
//    private var addedToCart = [String: String]()
    
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
    
    func saveSelf() {
        do {
            let selfData = try JSONEncoder().encode(self)
            UserDefaults.standard.set(selfData, forKey: "Manager")
        } catch {
            fatalError("Can't save userdefaults")
        }
    }
    
    func getIsFavoriteStatus(key: String, url: String) -> Bool? {
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
    
    func saveToUserDefaults<T>(boolean: T, andKey key: String) {
        UserDefaults.standard.set(boolean, forKey: key)
    }
    
    deinit {
        saveSelf()
    }
}
