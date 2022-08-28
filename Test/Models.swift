//
//  Models.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation

struct InputData: Codable {
    let homeStore: [HomeStore]
    let bestSeller: [BestSeller]
    
    enum CodingKeys: String, CodingKey {
        case homeStore = "home_store"
        case bestSeller = "best_seller"
    }
}

struct HomeStore: Codable {
    let id: Int
    let isNew: Bool?
    let title, subtitle: String
    let picture: String
    let isBuy: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case isNew = "is_new"
        case title, subtitle, picture
        case isBuy = "is_buy"
    }
}

struct BestSeller: Codable {
    let id: Int
    var isFavorites: Bool 
    let title: String
    let priceWithoutDiscount: Int
    let discountPrice: Int
    let picture: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, picture
        case isFavorites = "is_favorites"
        case priceWithoutDiscount = "price_without_discount"
        case discountPrice = "discount_price"
    }
}

struct DeviceDetails: Codable {
    let cpu: String
    let camera: String
    let capacity: [String]
    let color: [String]
    let id: String
    let images: [String]
    let isFavorites: Bool
    let price: Double
    let rating: Double
    let sd: String
    let ssd: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case camera, capacity, color, id, images, price, rating, sd, ssd, title, isFavorites
        case cpu = "CPU"
    }
}
