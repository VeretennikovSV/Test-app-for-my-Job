//
//  CategorySelectionCell.swift
//  Test
//
//  Created by Сергей Веретенников on 26/08/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class CategorySelectionCell: UICollectionViewCell {
    
    static let cellId = "CategoryCell"
    var viewModel: CategorySelectionCellViewModelProtocol?
    
    private let circle = UIView()
    private let icon = UIImageView()
    private let label = UILabel()
    private var isSelectedObserver = PublishSubject<Bool>()
    
    override func prepareForReuse() {
        setInterface()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.circle.layer.masksToBounds = true
            self?.circle.layer.cornerRadius = (self?.circle.frame.width ?? 0) / 2
        }
    }
    
    private func addSubviewes() {
        contentView.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        circle.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Mark-Regular", size: 11)
        label.textAlignment = .center
    }
    
    
    private func setupContraints() {

        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: topAnchor),
            circle.widthAnchor.constraint(equalToConstant: frame.width * 0.85),
            circle.centerXAnchor.constraint(equalTo: centerXAnchor),
            circle.heightAnchor.constraint(equalToConstant: frame.width * 0.85),
            
            icon.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            
            label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.centerXAnchor.constraint(equalTo: circle.centerXAnchor)
        ])
        
    }
    
    private func configureViewesWith(viewModel: CategorySelectionCellViewModelProtocol) {
        
        let image = UIImage(named: viewModel.getButtonString())
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        icon.image = tintedImage
        
        label.text = viewModel.getButtonString()
        
        viewModel.onTap
            .withUnretained(self)
            .bind { sel, _ in
                sel.setColors()
            }.disposed(by: viewModel.disposeBag)
        
    }
    
    private func setColors() {
        isSelected ? (icon.tintColor = .white) : (icon.tintColor = .gray)
        isSelected ? (circle.backgroundColor = Colors.shared.orangeColor) : (circle.backgroundColor = .white)
        isSelected ? (label.textColor = Colors.shared.orangeColor) : (label.textColor = .black)
    }
    
    private func setInterface() {
        addSubviewes()
        setupContraints()
        setColors()
    }
    
    func configureCellWith(viewModel: CategorySelectionCellViewModelProtocol) {
        self.viewModel = viewModel
        configureViewesWith(viewModel: viewModel)
        setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
