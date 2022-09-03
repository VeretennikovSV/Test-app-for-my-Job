//
//  CustimTabBarItem.swift
//  Test
//
//  Created by Сергей Веретенников on 27/08/2022.
//

import UIKit
import RxCocoa
import RxSwift


class CustimTabBarItem: UIView {
    
    private let image = UIImageView()
    private let onTapGesture = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()
    private lazy var countView = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: frame.width / 4, height: frame.width / 4)))
    
    var viewModel: TabBarItemViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.shared.darkPirple
        
        countView.backgroundColor = Colors.shared.orangeColor
        
        isUserInteractionEnabled = true
        
        addGestureRecognizer(onTapGesture)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.setConstraints()
        }
        
        addSubviewes()
        tabBarItemTapped()
    }
    
    private func addSubviewes() {
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(countView)
        countView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            countView.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -(frame.height * 0.1)),
            countView.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: frame.width * 0.1),
            countView.heightAnchor.constraint(equalToConstant: 18),
            countView.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func setViewWith(viewModel: TabBarItemViewModel) {
        self.viewModel = viewModel
        countView.isHidden = !(viewModel.tabItem == .bag)
        countView.textColor = .white
        countView.textAlignment = .center
        countView.font = UIFont(name: "Mark-Regular", size: 10)
        countView.text = "\(UserDefaultsManager.shared?.getCartDevices().count ?? 0)"
        
        if viewModel.tabItem == .bag { UserDefaultsManager.shared?.countOfDevices.bind { self.countView.text = "\($0)"}.disposed(by: disposeBag) }
        
        image.image = UIImage(named: viewModel.tabItem.rawValue)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.countView.layer.masksToBounds = true
            self?.countView.layer.cornerRadius = 9
        }
    }
    
    func tabBarItemTapped() {
        guard let viewModel = viewModel else { return }

        viewModel.onTap.onNext(viewModel.tabItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
