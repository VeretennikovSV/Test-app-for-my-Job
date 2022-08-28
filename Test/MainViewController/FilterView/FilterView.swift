//
//  FilterView.swift
//  Test
//
//  Created by Сергей Веретенников on 28/08/2022.
//

import Foundation
import UIKit

final class FilterView: UIView {
    
    private let topLabel = UILabel()
    private let closeButton = UIButton()
    private let doneButton = UIButton()
    private let brandLabel = UILabel()
    private let brandFilterButton = CustomButtonForFilter()
    private let priceLabel = UILabel()
    private let priceFilterButton = CustomButtonForFilter()
    private let sizeLabel = UILabel()
    private let sizeFilterButton = CustomButtonForFilter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewes(viewes: topLabel, closeButton, doneButton, brandLabel, priceLabel, sizeLabel, brandFilterButton, priceFilterButton, sizeFilterButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.setInterface()
            self?.setContraints()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviewes(viewes: UIView...) {
        viewes.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    private func setInterface() {
        closeButton.backgroundColor = Colors.shared.darkPirple
        closeButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 5
        closeButton.setTitle("X", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        doneButton.backgroundColor = Colors.shared.orangeColor
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 5
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        topLabel.text = "Filter options"
        topLabel.textColor = Colors.shared.darkPirple
        topLabel.font = .boldSystemFont(ofSize: 22)
        
        brandLabel.text = "Brand"
        brandLabel.textColor = Colors.shared.darkPirple
        brandLabel.font = .boldSystemFont(ofSize: 22)
        
        brandFilterButton.translatesAutoresizingMaskIntoConstraints = false
        brandFilterButton.setButtonTitleWith(text: "Samsung")
        
        priceLabel.text = "Price"
        priceLabel.textColor = Colors.shared.darkPirple
        priceLabel.font = .boldSystemFont(ofSize: 22)
        
        priceFilterButton.translatesAutoresizingMaskIntoConstraints = false
        priceFilterButton.setButtonTitleWith(text: "$300 - $500")
        
        sizeLabel.text = "Size"
        sizeLabel.textColor = Colors.shared.darkPirple
        sizeLabel.font = .boldSystemFont(ofSize: 22)
        
        sizeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        sizeFilterButton.setButtonTitleWith(text: "4.5 to 5.5 inches")
        
    }
    
    private func setContraints() {
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: viewWidth * 0.1),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: viewHeight * 0.07),
            closeButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.1),
            closeButton.widthAnchor.constraint(equalToConstant: viewHeight * 0.1),
            
            doneButton.topAnchor.constraint(equalTo: closeButton.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -viewWidth * 0.07),
            doneButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.1),
            doneButton.widthAnchor.constraint(equalToConstant: viewWidth * 0.2),
            
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            topLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            
            brandLabel.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            brandLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            brandLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1),
            brandLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: viewHeight * 0.115),
            
            brandFilterButton.leadingAnchor.constraint(equalTo: brandLabel.leadingAnchor),
            brandFilterButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.1),
            brandFilterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -viewWidth * 0.07),
            brandFilterButton.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: viewHeight * 0.02),
            
            priceLabel.leadingAnchor.constraint(equalTo: brandFilterButton.leadingAnchor),
            priceLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            priceLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1),
            priceLabel.topAnchor.constraint(equalTo: brandFilterButton.bottomAnchor, constant: viewHeight * 0.05),
            
            priceFilterButton.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            priceFilterButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.1),
            priceFilterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -viewWidth * 0.07),
            priceFilterButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: viewHeight * 0.02),
            
            sizeLabel.leadingAnchor.constraint(equalTo: priceFilterButton.leadingAnchor),
            sizeLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            sizeLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1),
            sizeLabel.topAnchor.constraint(equalTo: priceFilterButton.bottomAnchor, constant: viewHeight * 0.05),
            
            sizeFilterButton.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            sizeFilterButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.1),
            sizeFilterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -viewWidth * 0.07),
            sizeFilterButton.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: viewHeight * 0.02)
        ])
        
    }
    
    @objc private func closeButtonTapped() {
        isHidden.toggle()
    }
    
    @objc private func doneButtonTapped() {             //Как и что менять непонятно по тз при выставлении фильтров
        isHidden.toggle()
    }
}

extension FilterView {
    var viewHeight: CGFloat {
        frame.height
    }
    
    var viewWidth: CGFloat {
        frame.width
    }
}
