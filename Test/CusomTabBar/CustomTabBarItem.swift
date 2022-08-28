//
//  CustimTabBarItem.swift
//  Test
//
//  Created by Сергей Веретенников on 27/08/2022.
//

import UIKit



class CustimTabBarItem: UIView {
    
    let image = UIImageView()
    
    var viewModel: TabBarItemViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.shared.darkPirple
        
        isUserInteractionEnabled = true
        
        addSubviewes()
        setConstraints()
        
    }
    
    func tabBarItemTapped() {
        
    }
    
    private func addSubviewes() {
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewWith(viewModel: TabBarItemViewModel) {
        self.viewModel = viewModel
        image.image = UIImage(named: viewModel.tabItem.rawValue)
    }
}
