//
//  CustomButtonForDetails.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class CustomButtonForDetails: UIButton {
    
    var onTapDelegate: ButtonTapped!
    var underlineView = UIView()
    var buttonTypeForDetails: ButtonTypeForDetails!
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, buttonType: ButtonTypeForDetails, onTapDelegate: ButtonTapped) {
        self.init(frame: frame)
        self.buttonTypeForDetails = buttonType
        self.onTapDelegate = onTapDelegate
        
        setTitle(buttonType.rawValue, for: .normal)
        
        self.rx.tap
            .withUnretained(self)
            .bind { sel, _ in
                sel.onTapDelegate?.selectCategoryButtonTapped(sender: self)
            }.disposed(by: disposeBag)
        
        setUnderlineView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func changeButtonState() {
        setLabelColor()
        setLabelFont()
    }
    
    private func setLabelColor() {
        let color = underlineView.isHidden ? .gray : Colors.shared.darkPirple
        setTitleColor(color, for: .normal)
    }
    
    private func setLabelFont() {
        titleLabel?.font = underlineView.isHidden ? UIFont(name: "Mark-Regular", size: 18) : UIFont(name: "Mark-Bold", size: 22)
    }
    
    private func setUnderlineView() {
        addSubview(underlineView)
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        underlineView.backgroundColor = Colors.shared.orangeColor
        underlineView.layer.masksToBounds = true
        underlineView.layer.cornerRadius = 0.75
    }
    
    private func setConstraints() {
        guard let titleLabel = titleLabel else { return }
        NSLayoutConstraint.activate([
            underlineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 3),
            underlineView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, constant: 30),
            underlineView.topAnchor.constraint(equalTo: bottomAnchor, constant: 2)
        ])
    }
}
