//
//  HotSalesCell.swift
//  Test
//
//  Created by Сергей Веретенников on 24/08/2022.
//

import Foundation
import UIKit
import RxSwift

final class HotSalesCell: UICollectionViewCell {
    
    var viewModel: HotSalesCellViewModelProtocol?
    
    private let image = UIImageView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let titleStack = UIStackView()
    private let button = UIButton()
    private let circle = UIBezierPath(arcCenter: .zero, radius: 30, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
    private lazy var circleLayer = CAShapeLayer()
    private let view = UIView()
    private let isNewLabel = UILabel()
    
    static let cellID = "HotSalesCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setInterface()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setInterface()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setInterface() {
        image.translatesAutoresizingMaskIntoConstraints = false
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        isNewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        title.textAlignment = .left
        title.textColor = .white
        title.font = UIFont(name: "Mark-Bold", size: 25)
        subtitle.textAlignment = .left
        subtitle.textColor = .white
        subtitle.font = UIFont(name: "Mark-Regular", size: 16)
        
        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(subtitle)
        titleStack.spacing = frame.size.height * 0.025
        titleStack.axis = .vertical
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Mark-Bold", size: 14)
        button.addTarget(self, action: #selector(buyNowTapped), for: .touchUpInside)
        button.isHidden = true
        
        view.backgroundColor = Colors.shared.orangeColor
        view.layer.masksToBounds = true
        view.isHidden = true
        
        isNewLabel.font = UIFont(name: "Mark-Bold", size: 11)
        isNewLabel.text = "New"
        
        view.addSubview(isNewLabel)
        image.addSubview(view)
        contentView.addSubview(image)
        contentView.addSubview(titleStack)
        contentView.addSubview(button)
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 15
    }
    
    @objc private func buyNowTapped() {
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            titleStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
            titleStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
            button.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: insetFromStack),
            button.widthAnchor.constraint(equalToConstant: buttonWidth),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            view.leadingAnchor.constraint(equalTo: titleStack.leadingAnchor),
            view.heightAnchor.constraint(equalToConstant: buttonHeight),
            view.widthAnchor.constraint(equalToConstant: buttonHeight),
            view.bottomAnchor.constraint(equalTo: titleStack.topAnchor, constant: -insetFromStack),
            
            isNewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            isNewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func downloadImageWith(viewModel: HotSalesCellViewModelProtocol) {
        guard let url = URL(string: viewModel.cellContent.picture) else { return }
        
        viewModel.imageLoader.photoSenderObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { sel, image in
                sel.image.image = image?.resizeImageTo(size: sel.frame.size)
                sel.afterFetchActions()
            }.disposed(by: viewModel.disposeBag)
        
        viewModel.imageLoader.getImageFrom(url: url)
    }
    
    private func afterFetchActions() {
        button.isHidden = false
        view.layer.cornerRadius = view.frame.width / 2
        view.isHidden = viewModel?.cellContent.isNew ?? false
    }
    
    func configureCellWith(viewModel: HotSalesCellViewModelProtocol) {
        self.viewModel = viewModel
        downloadImageWith(viewModel: viewModel)
        
        title.text = viewModel.cellContent.title
        subtitle.text = viewModel.cellContent.subtitle
        
        button.setTitle("Buy now", for: .normal)
    }
}

//MARK: Apperance
extension HotSalesCell {
    
    var leadingInset: CGFloat {
        frame.size.width * 0.07
    }
    
    var buttonWidth: CGFloat {
        frame.size.width * 0.27
    }
    
    var insetFromStack: CGFloat {
        frame.height * 0.08
    }
    
    var buttonHeight: CGFloat {
        frame.height * 0.15
    }
}
