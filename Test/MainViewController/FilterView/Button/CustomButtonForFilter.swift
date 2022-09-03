//
//  CustomButtonForFilter.swift
//  Test
//
//  Created by Сергей Веретенников on 28/08/2022.
//

import UIKit

class CustomButtonForFilter: UIButton {

    var viewModel: CustomButtonViewModel?
    var image = UILabel()
    
    private lazy var buttonText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 4
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.3
        addSubview(buttonText)
        buttonText.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.text = "\u{2304}"
        image.font = UIFont(name: "Mark-Bold", size: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonTitleWith(text: String) {
        self.viewModel = CustomButtonViewModel(label: text)
        
        buttonText.text = text
        buttonText.textColor = Colors.shared.darkPirple
        buttonText.font = UIFont(name: "Mark-Regular", size: 16)
        
        NSLayoutConstraint.activate([
            buttonText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width * 0.5),
            buttonText.heightAnchor.constraint(equalToConstant: frame.height),
            buttonText.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonText.trailingAnchor.constraint(equalTo: centerXAnchor),
            
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(frame.width * 0.05)),
            image.heightAnchor.constraint(equalToConstant: frame.height),
            image.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            image.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
