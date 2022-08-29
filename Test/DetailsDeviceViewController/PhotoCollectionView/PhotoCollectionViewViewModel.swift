//
//  PhotoCollectionViewViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation

protocol PhotoCollectionViewViewModelProtocol {
    var imageUrls: [String] { get }
    func getCellViewModelWith(indexPath: IndexPath) -> PhotoCellViewModelProtocol
}

final class PhotoCollectionViewViewModel: PhotoCollectionViewViewModelProtocol {
    let imageUrls: [String]
    
    init(url: [String]) {
        self.imageUrls = url
    }
    
    func getCellViewModelWith(indexPath: IndexPath) -> PhotoCellViewModelProtocol {
        PhotoCellViewModel(url: imageUrls[indexPath.item])
    }
}
