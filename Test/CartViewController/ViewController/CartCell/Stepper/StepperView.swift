//
//  StepperView.swift
//  Test
//
//  Created by Сергей Веретенников on 01/09/2022.
//

import Foundation
import UIKit 
import RxRelay
import RxSwift

final class CustomStepperForCell: UIView {
    
    lazy var devicesCount = UILabel(frame: CGRect(x: 0, y: (frame.height * 0.5 - (frame.width * 0.25)), width: frame.width, height: (frame.width * 0.5)))
    private let disposeBag = DisposeBag()
    private lazy var plusButton = UIButton(frame: CGRect(x: frame.width * 0.1, y: frame.width * 0.1, width: frame.width * 0.8, height: frame.width * 0.8))
    private lazy var minusButton = UIButton(frame: CGRect(x: frame.width * 0.1, y: frame.height - frame.width * 0.9, width: frame.width * 0.8, height: frame.width * 0.8))    
    
    var delegate: CartTableViewControllerProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
        backgroundColor = .darkGray
        
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        plusButton.tintColor = .white
        minusButton.tintColor = .white
        
        devicesCount.textAlignment = .center
        
        UserDefaultsManager.shared?.countOfExactDevice.bind { self.devicesCount.text = "\($0)" }.disposed(by: disposeBag)
        
        addSubview(plusButton)
        addSubview(minusButton)
        addSubview(devicesCount)
        
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func minusButtonTapped() {
        UserDefaultsManager.shared?.deleteFromCartWith(key: deviceURL)
        delegate?.reloadData()
    }
    
    @objc private func plusButtonTapped() {
        UserDefaultsManager.shared?.saveToCartWith(key: deviceURL)
        delegate?.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
