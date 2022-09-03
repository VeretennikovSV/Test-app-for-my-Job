//
//  CartViewController.swift
//  Test
//
//  Created by Сергей Веретенников on 31/08/2022.
//

import Foundation
import UIKit
import RxSwift

final class CartViewController: UIViewController {
    
    private let cartLabel = UILabel()
    private let disposeBag = DisposeBag()
    private lazy var tableView = CartTableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.shared.backgroundColor
        
        tableView.buttonTapped.withUnretained(self).bind { $0.present($1, animated: true) }.disposed(by: disposeBag)
        setInterface()
        setNavController() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
        setRadiusTo(view: tableView, corners: [.topLeft, .topRight], size: CGSize(width: 30, height: 30))
    }
    
    private func setInterface() {
        view.addSubview(cartLabel)
        cartLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        cartLabel.font = UIFont(name: "Mark-Bold", size: 30)
        cartLabel.textColor = .black
        cartLabel.text = "My Cart"
        
    }
    
    private func setNavController() {
        navigationItem.hidesBackButton = true
        
        let backButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 36)))
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.backgroundColor = Colors.shared.darkPirple
        backButton.tintColor = .white
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 7
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        
        let lozationButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        lozationButton.setImage(UIImage(systemName: "location.circle"), for: .normal)
        lozationButton.backgroundColor = Colors.shared.orangeColor
        lozationButton.tintColor = .white
        lozationButton.layer.masksToBounds = true
        lozationButton.layer.cornerRadius = 8
        lozationButton.addTarget(self, action: #selector(locationMarkTapped), for: .touchUpInside)
        
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: lozationButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
            
            cartLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.2),
            cartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.07),
            cartLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1)
        ])
    }
    
    @objc private func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func locationMarkTapped() {
        let alert = UIAlertController(title: "Location selection", message: "Select location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
}
