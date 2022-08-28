//
//  Cache.swift
//  Test
//
//  Created by Сергей Веретенников on 24/08/2022.
//

import Foundation
import UIKit
import RxSwift

protocol ImageCacheProtocol {
    var photoSenderObserver: PublishSubject<UIImage?> { get }
    func getImageFrom(url: URL?)
}

private final class Cache {
    private init(){}
    
    static let shared = Cache()
    
    var cache: NSCache<NSString, NSData> = {
        let cache = NSCache<NSString, NSData>()
        
        return cache
    }()
}

final class PhotoCache: ImageCacheProtocol {
    
    private var cache = Cache.shared.cache
    
    var photoSenderObserver = PublishSubject<UIImage?>()
    
    private let queue = DispatchQueue(label: "CacheSaving", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .workItem)
    private let lock = NSLock()
    
    private func saveToCache(with url: URL, and data: Data) {
        guard let image = UIImage(data: data)?.jpegData(compressionQuality: 1) else { return }
        lock.lock(); defer { lock.unlock() }
        cache.setObject(NSData(data: image), forKey: NSString(string: url.absoluteString))
    }
    
    private func loadImageFromCacheFrom(url: URL) -> UIImage? {
        guard let data = cache.object(forKey: NSString(string: url.absoluteString)) else { return nil }
        lock.lock(); defer { lock.unlock() }
        return UIImage(data: data as Data)
    }
    
    
    func getImageFrom(url: URL?) {
        
        queue.async { [weak self] in
        guard let url = url else {
            
            let image = UIImage(systemName: "person")
            self?.photoSenderObserver.onNext(image)
            return
        }
        
            if let imageFromCache = self?.loadImageFromCacheFrom(url: url) {
                self?.photoSenderObserver.onNext(imageFromCache)
                return
            } 
            
            guard let data = try? Data(contentsOf: url) else { 
                let image = UIImage(systemName: "person")
                self?.photoSenderObserver.onNext(image)
                return
            }
            let image = UIImage(data: data) ?? UIImage(systemName: "person")
            self?.saveToCache(with: url, and: data)
            self?.photoSenderObserver.onNext(image)
        }
    }
}
