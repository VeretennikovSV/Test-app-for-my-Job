//
//  AboutDeviceView.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import UIKit
import RxSwift

protocol ButtonTapped {
    func selectCategoryButtonTapped(sender: CustomButtonForDetails)
    func selectColorTapped(sender: SelectColorButton)
}

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
    private let imagesStackView = UIStackView()
    private let selectColorAndCapacityLabel = UILabel()
    
    private lazy var colorSelectScrollView = ColorSelectionScrollView(frame: CGRect(origin: .zero, size: CGSize(width: viewsHeight, height: viewsHeight)))
    private lazy var shopButton = CustomButtonForDetails(frame: .zero, buttonType: .shop, onTapDelegate: self)
    private lazy var detailsButton = CustomButtonForDetails(frame: .zero, buttonType: .details, onTapDelegate: self)
    private lazy var featuresButton = CustomButtonForDetails(frame: .zero, buttonType: .features, onTapDelegate: self)
    
    private lazy var cpu = CustomImageLabelView(frame: .zero, imageType: .cpu)
    private lazy var camera = CustomImageLabelView(frame: .zero, imageType: .camera)
    private lazy var sd = CustomImageLabelView(frame: .zero, imageType: .sd)
    private lazy var ssd = CustomImageLabelView(frame: .zero, imageType: .ssd)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewes(views: deviceNameLabel, likeButton, starStack, shopButton, detailsButton, featuresButton, imagesStackView, cpu, camera, sd, ssd, selectColorAndCapacityLabel, colorSelectScrollView)
        
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
            colorSelectScrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: (frame.width / 2) - insetsForOthers),
            colorSelectScrollView.topAnchor.constraint(equalTo: selectColorAndCapacityLabel.bottomAnchor, constant: betweenInsets),
            colorSelectScrollView.heightAnchor.constraint(equalToConstant: viewsHeight)
            
        ])
    }
    
    private func setupLabelsAndButtons() {
        
        guard let viewModel = viewModel else { return }
        
        viewModel.acceptDeviceDetails
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { sel, details in
                sel.deviceNameLabel.font = .boldSystemFont(ofSize: 22)
                sel.deviceNameLabel.tintColor = Colors.shared.darkPirple
                sel.deviceNameLabel.text = details.title
                
                sel.likeButton.layer.masksToBounds = true
                sel.likeButton.layer.cornerRadius = (sel.viewsHeight * 1.5) * 0.16
                
                sel.likeButton.setImage(sel.getHeart(), for: .normal)
                sel.likeButton.backgroundColor = Colors.shared.darkPirple
                
                for _ in 0...4 {
                    let starView = UIImageView(image: UIImage(named: "Star"))
                    sel.starStack.addArrangedSubview(starView)
                }
                
                sel.starStack.axis = .horizontal
                sel.starStack.spacing = 5
                
                sel.addImageLabelsWithDetails(details: details)
                
                sel.selectColorAndCapacityLabel.text = "Select color and capacity"
                sel.selectColorAndCapacityLabel.textColor = Colors.shared.darkPirple
                sel.selectColorAndCapacityLabel.font = .boldSystemFont(ofSize: 14)
                
                sel.imagesStackView.axis = .horizontal
                sel.imagesStackView.spacing = 0
                
                sel.setupButtonWith(sel.shopButton)
                sel.shopButton.underlineView.isHidden = false
                sel.shopButton.changeButtonState()
                
                sel.setupButtonWith(sel.detailsButton)
                sel.setupButtonWith(sel.featuresButton)
                
                
                for (buttonNumber, colorString) in details.color.enumerated() {
                    let button = SelectColorButton(frame: .zero, onTapDelegate: self)
                    button.setupButtonColorWithColor(color: colorString)
                    sel.colorSelectScrollView.addSubview(button)
                    if buttonNumber == 0 { button.isSelected = true }
                } 
                
            }.disposed(by: viewModel.disposeBag)
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

extension AboutDeviceView: ButtonTapped {
    func selectCategoryButtonTapped(sender: CustomButtonForDetails) {
        guard let buttons = subviews.filter({ $0 is CustomButtonForDetails }) as? [CustomButtonForDetails] else { return }
        
        buttons.forEach { 
            $0.underlineView.isHidden = true
            $0.changeButtonState()
        }
        
        sender.underlineView.isHidden = false
        sender.changeButtonState()
    }
    
    func selectColorTapped(sender: SelectColorButton) {
        guard let buttons = colorSelectScrollView.subviews.filter({ $0 is SelectColorButton }) as? [SelectColorButton] else { return }
        
        buttons.forEach {
            let button = $0
            button.isSelected = false
        }
        
        sender.isSelected = true
    }
}
