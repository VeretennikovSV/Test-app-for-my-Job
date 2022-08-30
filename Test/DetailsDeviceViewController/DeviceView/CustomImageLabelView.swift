//
//  CustomImageLabelView.swift
//  Test
//
//  Created by Сергей Веретенников on 30/08/2022.
//

import Foundation
import UIKit

internal enum ImageType: String {
    case cpu 
    case camera 
    case sd 
    case ssd
}

final class CustomImageLabelView: UIView {
    
    var viewModel: CustomImageLabelViewViewModel? {
        didSet {
            switch imageType {
            case .cpu:
                imageLabel.text = viewModel?.deviceDetails.cpu ?? ""
            case .camera:
                imageLabel.text = viewModel?.deviceDetails.camera ?? ""
            case .sd:
                imageLabel.text = viewModel?.deviceDetails.sd ?? ""
            case .ssd:
                imageLabel.text = viewModel?.deviceDetails.ssd ?? ""
            default: break
            }
        }
    }
    
    private var imageType: ImageType!
    
    private lazy var imageView = UIImageView()
    private lazy var imageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect, imageType: ImageType) {
        self.init(frame: frame)
        self.imageType = imageType
        
        imageView.image = UIImage(named: imageType.rawValue)
        setViewes()
        setConstraints()
    }
    
    private func setViewes() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageLabel)
        imageLabel.textAlignment = .center
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.font = .systemFont(ofSize: 12)
        imageLabel.textColor = .gray
    }
    
    private func setConstraints() {
        
        print(frame)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
