//
//  PhotoCell.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import UIKit
import RxSwift

final class PhotoCell: UICollectionViewCell {
    
    private lazy var imageView = UIImageView(frame: CGRect(origin: CGPoint(x: frame.size.width * 0.05, y: frame.size.height * 0.05), size: CGSize(width: frame.size.width * 0.9, height: frame.size.height * 0.9)))
    
    var viewModel: PhotoCellViewModelProtocol! {
        didSet {
            downloadImageWith(url: viewModel?.photoUrl ?? "")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setImage()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage()
    }
    
    private func setImage() {
        contentView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 14
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 14).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 10)
        contentView.backgroundColor = .white
    }
    
    private func downloadImageWith(url: String) {
        guard let url = URL(string: url) else { return } 
        guard let viewModel = viewModel else { return }

        print(viewModel)
        
        viewModel.imageLoader.photoSenderObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { sel, image in
                sel.imageView.image = image?.resizeImageTo(size: sel.frame.size)
            }.disposed(by: viewModel.disposeBag)
        
        viewModel.imageLoader.getImageFrom(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
