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
    
    private let disposeBag = DisposeBag()
    private lazy var tableView = CartTableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        tableView.buttonTapped.withUnretained(self).bind { $0.present($1, animated: true) }.disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
        setRadiusTo(view: tableView, corners: [.topLeft, .topRight], size: CGSize(width: 30, height: 30))
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3)
        ])
    }
}
