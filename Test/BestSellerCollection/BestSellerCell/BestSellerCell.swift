//
//  BestSellerCell.swift
//  Test
//
//  Created by Сергей Веретенников on 25/08/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class BestSellerCell: UICollectionViewCell {
    
    static var cellId = "BestSellerCell"
    
    var onTap = PublishRelay<Void>()
    var viewModel: BestSellerCellViewModelProtocol?
    
    private let discountlessPrice = DiscountlessLabel()
    private let discountPrice = UILabel()
    private let deviceName = UILabel()
    private let image = UIImageView()
    private lazy var likeButton = UIButton(frame: CGRect(origin: CGPoint(x: frame.width - buttonSize.width * 1.5, y: buttonSize.height * 0.5), size: buttonSize))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        layer.masksToBounds = true
        layer.cornerRadius = 14
        
    }
    
    private func loadImageWith(viewModel: BestSellerCellViewModelProtocol) {
        
        guard let url = URL(string: viewModel.cellContent.picture) else { return }
        
        viewModel.imageLoader.photoSenderObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { sel, image in
                sel.image.image = image?.resizeImageTo(size: CGSize(width: sel.frame.width, height: sel.frame.width * 0.9))
            }.disposed(by: viewModel.disposeBag)
        
        viewModel.imageLoader.getImageFrom(url: url)
    }
    
    private func addSubviewes() {
        contentView.addSubview(discountlessPrice)
        contentView.addSubview(discountPrice)
        contentView.addSubview(deviceName)
        contentView.addSubview(image)
        contentView.addSubview(likeButton)
        
        discountlessPrice.translatesAutoresizingMaskIntoConstraints = false
        discountPrice.translatesAutoresizingMaskIntoConstraints = false
        deviceName.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setContraints() {
        image.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: frame.height * 0.7),
            
            discountPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            discountPrice.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor, multiplier: 0.1),
            discountPrice.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: frame.height * 0.14),
            
            discountlessPrice.leadingAnchor.constraint(equalTo: discountPrice.trailingAnchor, constant: 5),
            discountlessPrice.price.bottomAnchor.constraint(equalTo: discountPrice.bottomAnchor),
            
            deviceName.leadingAnchor.constraint(equalTo: discountPrice.leadingAnchor),
            deviceName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deviceName.topAnchor.constraint(equalTo: discountPrice.bottomAnchor),
        ])
    }
    
    private func setButtonStateWith(viewModel: BestSellerCellViewModelProtocol) {
        let image = UIImage(named: viewModel.getImageName())
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        
        likeButton.imageView?.tintColor = Colors.shared.orangeColor
        likeButton.setImage(tintedImage, for: .normal)
        
    }
    
    func configureCellWith(viewModel: BestSellerCellViewModelProtocol) {
        self.viewModel = viewModel
        
        setButtonStateWith(viewModel: viewModel)
        
        discountPrice.text = "$\(viewModel.cellContent.discountPrice)"
        discountPrice.font = UIFont(name: "Mark-Bold", size: 19)
        
        deviceName.text = viewModel.cellContent.title
        deviceName.numberOfLines = 0
        deviceName.font = UIFont(name: "Mark-Regular", size: 12)
        
        likeButton.layer.cornerRadius = likeButton.frame.width / 2
        likeButton.backgroundColor = .white
        likeButton.layer.masksToBounds = false
        likeButton.layer.shadowColor = UIColor.black.cgColor
        likeButton.layer.shadowRadius = 8
        likeButton.layer.shadowOpacity = 0.2
        likeButton.layer.shadowPath = UIBezierPath(roundedRect: likeButton.bounds, cornerRadius: likeButton.frame.width / 2).cgPath
        likeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        likeButton.rx
            .tap
            .withUnretained(self)
            .bind { sel, _ in
                viewModel.changeStateOfButton()
                sel.setButtonStateWith(viewModel: viewModel)
            }.disposed(by: viewModel.disposeBag)
        
        loadImageWith(viewModel: viewModel)
        discountlessPrice.setPriceWith(number: viewModel.cellContent.priceWithoutDiscount)
        
        addSubviewes()
        setContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BestSellerCell {
    var buttonSize: CGSize {
        CGSize(width: 30, height: 30)
    } 
}
