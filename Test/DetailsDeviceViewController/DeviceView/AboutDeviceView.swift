//
//  AboutDeviceView.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import UIKit
import RxSwift

internal enum ButtonTypeForDetails: String {
    case shop = "Shop"
    case details = "Details"
    case features = "Features"
}

final class AboutDeviceView: UIView {
    
    var viewModel: AboutDeviceViewViewModelProtocol? {
        didSet {
            setupLabelsAndButtons()
        }
    }
    
    private let deviceNameLabel = UILabel()
    private let likeButton = UIButton()
    private let starStack = UIStackView()
    private let selectColorAndCapacityLabel = UILabel()
    private let addToCartButton = UIButton()
    
    internal lazy var colorSelectScrollView = ColorSelectionScrollView(frame: CGRect(origin: .zero, size: CGSize(width: viewsHeight, height: viewsHeight)))
    internal lazy var memorySelectionScrollView = MemorySeclectionScrollView(frame: CGRect(origin: .zero, size: CGSize(width: viewsHeight, height: viewsHeight)))
    
    private lazy var shopButton = CustomButtonForDetails(frame: .zero, buttonType: .shop, onTapDelegate: self)
    private lazy var detailsButton = CustomButtonForDetails(frame: .zero, buttonType: .details, onTapDelegate: self)
    private lazy var featuresButton = CustomButtonForDetails(frame: .zero, buttonType: .features, onTapDelegate: self)
    
    private lazy var cpu = CustomImageLabelView(frame: .zero, imageType: .cpu)
    private lazy var camera = CustomImageLabelView(frame: .zero, imageType: .camera)
    private lazy var sd = CustomImageLabelView(frame: .zero, imageType: .sd)
    private lazy var ssd = CustomImageLabelView(frame: .zero, imageType: .ssd)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewes(views: deviceNameLabel, likeButton, starStack, shopButton, detailsButton, featuresButton, cpu, camera, sd, ssd, selectColorAndCapacityLabel, colorSelectScrollView, memorySelectionScrollView, addToCartButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.setContraints()
        }
    }
    
    private func setContraints() {
        
        NSLayoutConstraint.activate([
            deviceNameLabel.heightAnchor.constraint(equalToConstant: viewsHeight),
            deviceNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insetsForHeader),
            deviceNameLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            deviceNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInsets),
        
            likeButton.centerYAnchor.constraint(equalTo: deviceNameLabel.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: viewsHeight * 1.3),
            likeButton.heightAnchor.constraint(equalToConstant: viewsHeight * 1.3),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insetsForHeader),
            
            starStack.topAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: insetToStars),
            starStack.leadingAnchor.constraint(equalTo: deviceNameLabel.leadingAnchor),
            
            shopButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shopButton.widthAnchor.constraint(equalToConstant: frame.width * 0.33),
            shopButton.heightAnchor.constraint(equalToConstant: viewsHeight),
            shopButton.topAnchor.constraint(equalTo: starStack.bottomAnchor, constant: betweenInsets),
            
            detailsButton.leadingAnchor.constraint(equalTo: shopButton.trailingAnchor),
            detailsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            detailsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            detailsButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            
            featuresButton.leadingAnchor.constraint(equalTo: detailsButton.trailingAnchor),
            featuresButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            featuresButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            featuresButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            
            cpu.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imageLabelsLeadingInsets),
            cpu.topAnchor.constraint(equalTo: featuresButton.underlineView.bottomAnchor, constant: betweenInsets),
            cpu.widthAnchor.constraint(equalToConstant: imageLabelsWidth),
            cpu.heightAnchor.constraint(equalToConstant: 45),
            
            camera.leadingAnchor.constraint(equalTo: cpu.trailingAnchor),
            camera.heightAnchor.constraint(equalTo: cpu.heightAnchor),
            camera.widthAnchor.constraint(equalTo: cpu.widthAnchor),
            camera.centerYAnchor.constraint(equalTo: cpu.centerYAnchor),
            
            sd.leadingAnchor.constraint(equalTo: camera.trailingAnchor),
            sd.heightAnchor.constraint(equalTo: cpu.heightAnchor),
            sd.widthAnchor.constraint(equalTo: cpu.widthAnchor),
            sd.centerYAnchor.constraint(equalTo: cpu.centerYAnchor),
            
            ssd.leadingAnchor.constraint(equalTo: sd.trailingAnchor),
            ssd.heightAnchor.constraint(equalTo: cpu.heightAnchor),
            ssd.widthAnchor.constraint(equalTo: cpu.widthAnchor),
            ssd.centerYAnchor.constraint(equalTo: cpu.centerYAnchor),
            
            selectColorAndCapacityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insetsForOthers),
            selectColorAndCapacityLabel.topAnchor.constraint(equalTo: cpu.bottomAnchor, constant: betweenInsets),
            selectColorAndCapacityLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            
            colorSelectScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insetsForOthers),
            colorSelectScrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: -(frame.width / 2) - insetsForOthers),
            colorSelectScrollView.topAnchor.constraint(equalTo: selectColorAndCapacityLabel.bottomAnchor, constant: betweenInsets),
            colorSelectScrollView.heightAnchor.constraint(equalToConstant: viewsHeight), 
            
            memorySelectionScrollView.leadingAnchor.constraint(equalTo: colorSelectScrollView.trailingAnchor),
            memorySelectionScrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: -(frame.width / 2) - insetsForOthers),
            memorySelectionScrollView.topAnchor.constraint(equalTo: selectColorAndCapacityLabel.bottomAnchor, constant: betweenInsets),
            memorySelectionScrollView.heightAnchor.constraint(equalToConstant: viewsHeight),
            
            addToCartButton.topAnchor.constraint(equalTo: memorySelectionScrollView.bottomAnchor, constant: betweenInsets),
            addToCartButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -(insetsForOthers * 2)),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -betweenInsets),
            addToCartButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func setupLabelsAndButtons() {
        //MARK: Выглядит грязно, знаю...
        guard let viewModel = viewModel else { return }
        
        viewModel.acceptDeviceDetails
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { sel, details in
                
                sel.selectColorAndCapLabel() 
                sel.setupLikeButton()
                sel.setupStarStack()
                
                sel.addImageLabelsWithDetails(details: details)
                sel.setAddToCartButtonWith(details: details)
                sel.setColorsButtonsWith(details: details)
                sel.setMemoryButtonsWith(details: details)
                sel.setupDeviceNameWith(details: details)
                sel.setupButtonsWith(details: details)
            }.disposed(by: viewModel.disposeBag)
    }
    
    private func setupDeviceNameWith(details: DeviceDetails) {
        deviceNameLabel.font = UIFont(name: "Mark-Bolds", size: 22)
        deviceNameLabel.tintColor = Colors.shared.darkPirple
        deviceNameLabel.text = details.title
    }
    
    private func setupLikeButton() {
        likeButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = (viewsHeight * 1.5) * 0.16
        
        likeButton.setImage(getHeart(), for: .normal)
        likeButton.backgroundColor = Colors.shared.darkPirple
    }
    
    private func setupStarStack() {
        for _ in 0...4 {
            let starView = UIImageView(image: UIImage(named: "Star"))
            starStack.addArrangedSubview(starView)
        }
        
        starStack.axis = .horizontal
        starStack.spacing = 5
    }
    
    private func selectColorAndCapLabel() {
        selectColorAndCapacityLabel.text = "Select color and capacity"
        selectColorAndCapacityLabel.textColor = Colors.shared.darkPirple
        selectColorAndCapacityLabel.font = UIFont(name: "Mark-Bold", size: 14)
    }
    
    private func addImageLabelsWithDetails(details: DeviceDetails) {
        guard let customImages = subviews.filter ({$0 is CustomImageLabelView}) as? [CustomImageLabelView] else { return }
        customImages.forEach { $0.viewModel = CustomImageLabelViewViewModel(details: details) }
    }
    
    private func setupButtonWith(_ button: CustomButtonForDetails) {
        button.setTitleColor(Colors.shared.orangeColor, for: .normal)
        button.underlineView.isHidden = true
        button.onTapDelegate = self
        button.changeButtonState()
    }
    
    private func setupButtonsWith(details: DeviceDetails) {
        setupButtonWith(shopButton)
        shopButton.underlineView.isHidden = false
        shopButton.changeButtonState()
        
        setupButtonWith(detailsButton)
        setupButtonWith(featuresButton)
    }
    
    private func setColorsButtonsWith(details: DeviceDetails) {
        for (buttonNumber, colorString) in details.color.enumerated() {
            let button = SelectColorButton(frame: .zero, onTapDelegate: self)
            button.setupButtonColorWithColor(color: colorString)
            colorSelectScrollView.addSubview(button)
            if buttonNumber == 0 { button.isSelected = true }
        } 
    }
    
    private func setMemoryButtonsWith(details: DeviceDetails) {
        for (buttonNumber, memory) in details.capacity.enumerated() {
            let button = SelectMemoryButton(frame: .zero, onTapDelegate: self)
            button.setupButtonMemory(memory: memory)
            memorySelectionScrollView.addSubview(button)
            if buttonNumber == 0 { button.isSelected = true }
        }
    }
    
    private func setAddToCartButtonWith(details: DeviceDetails) {
        guard let viewModel = viewModel else { return }
        addToCartButton.setTitle("$\(details.price)", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.masksToBounds = true
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.titleLabel?.font = UIFont(name: "Mark-Bold", size: 22)
        addToCartButton.backgroundColor = Colors.shared.orangeColor
        addToCartButton.rx.tap.bind { _ in
            UserDefaultsManager.shared?.saveToCartWith(key: deviceURL)
        }.disposed(by: viewModel.disposeBag)
    }
    
    private func addSubviewes(views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false; addSubview($0) }
    }
    
    private func getHeart() -> UIImage? {
        let image = UIImage(named: "HighQualityHeart")
        
        return image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Appearance

extension AboutDeviceView {
    
    var viewsHeight: CGFloat {
        frame.height * 0.07
    }
    
    var insetToStars: CGFloat {
        frame.height * 0.02
    }
    
    var insetsForHeader: CGFloat {
        frame.width * 0.1
    }
    
    var insetsForOthers: CGFloat {
        frame.width * 0.08
    }
    
    var imageLabelsLeadingInsets: CGFloat {
        frame.width * 0.06
    }
    
    var imageLabelsWidth: CGFloat {
        (frame.width - imageLabelsLeadingInsets * 2) * 0.25
    }
    
    var topBottomInsets: CGFloat {
        frame.height * 0.08
    }
    
    var insetFromHeader: CGFloat {
        frame.height * 0.07
    }
    
    var betweenInsets: CGFloat {
        frame.height * 0.05
    }
}
