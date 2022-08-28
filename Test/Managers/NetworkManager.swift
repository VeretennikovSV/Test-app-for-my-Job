//
//  NetworkManager.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import RxSwift
import RxCocoa

enum FetchErrors: String, Error {
    case wrongUrl = "Wrong URL adress"
    case corruptedData = "Data corrupted"
    case decodingError = "Decoding error happened"
}


protocol HttpClientProtocol {
    func performGet<T: Decodable>(urlString: String) -> Observable<T> 
}


final class NetworkManager: HttpClientProtocol {
    
    private let urlSession: URLSession
    
    func performGet<T: Decodable>(urlString: String) -> Observable<T> {
        guard let url = URL(string: urlString) else { return .error(FetchErrors.wrongUrl) }
        let request = URLRequest(url: url)
        
        return urlSession.rx.data(request: request)
            .retry()
            .subscribe(on: SerialDispatchQueueScheduler(internalSerialQueueName: "com.doc24.network"))
            .map { return try JSONDecoder().decode(T.self, from: $0) }
    }
    
    
    init(
        session: URLSession = .shared
    ) {
        self.urlSession = session
    }
    
}
