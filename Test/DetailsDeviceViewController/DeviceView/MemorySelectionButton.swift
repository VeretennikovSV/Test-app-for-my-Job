//
//  MemorySelectionButton.swift
//  Test
//
//  Created by Сергей Веретенников on 31/08/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SelectMemoryButton: UIButton {
    
    var onTapDelegate: ButtonTapped!
    private let disposeBag = DisposeBag()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = Colors.shared.orangeColor
                setTitleColor(.white, for: .normal)
            } else {
                backgroundColor = nil
                setTitleColor(.gray, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true
    }
    
    convenience init(frame: CGRect, onTapDelegate: ButtonTapped) {
        self.init(frame: frame)
        self.onTapDelegate = onTapDelegate
        
        setTitleColor(.gray, for: .normal)
        titleLabel?.font = UIFont(name: "Mark-Regular", size: 14)
        
        rx.tap.bind {
            onTapDelegate.selectMemoryTapped(sender: self)
        }.disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
    
    func setupButtonMemory(memory: String) {
        isHidden = false
        
        setTitle("\(memory) GB", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
