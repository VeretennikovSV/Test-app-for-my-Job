//
//  PhotoCellViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import RxSwift

protocol PhotoCellViewModelProtocol {
    var photoUrl: String { get }
    var imageLoader: PhotoCache { get }
    var disposeBag: DisposeBag { get }
}

final class PhotoCellViewModel: PhotoCellViewModelProtocol {
    let photoUrl: String
    let imageLoader = PhotoCache()
    let disposeBag = DisposeBag()
    
    init(url: String) {
        photoUrl = url
    }
}
