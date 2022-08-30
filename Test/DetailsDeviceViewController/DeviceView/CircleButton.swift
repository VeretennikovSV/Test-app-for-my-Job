//
//  CircleButton.swift
//  Test
//
//  Created by Сергей Веретенников on 30/08/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class SelectColorButton: UIButton {
    
    var onTapDelegate: ButtonTapped!
    private let disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? (setImage(UIImage(systemName: "checkmark"), for: .normal)) : (setImage(nil, for: .normal))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
    }
    
    convenience init(frame: CGRect, onTapDelegate: ButtonTapped) {
        self.init(frame: frame)
        self.onTapDelegate = onTapDelegate
        
        tintColor = .white
        
        rx.tap.bind {
            onTapDelegate.selectColorTapped(sender: self)
        }.disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
    }
    
    func setupButtonColorWithColor(color: String) {
        isHidden = false
        
        self.backgroundColor = UIColor(hex: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
