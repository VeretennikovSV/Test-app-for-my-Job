//
//  CartViewController.swift
//  Test
//
//  Created by Сергей Веретенников on 31/08/2022.
//

import Foundation
import UIKit
import RxSwift

protocol CartTableViewControllerProtocol {
    func reloadData()
}

final class CartTableViewController: UIView {
    
    let buttonTapped = PublishSubject<UIAlertController>()
    let viewModel: CartViewViewModelProtocol
    
    private lazy var cartTableView = UITableView()
    private lazy var checkOutButton = UIButton()
    private lazy var titlesLabelsStack = UIStackView()
    private lazy var priceLabelsStack = UIStackView()
    
    override init(frame: CGRect) {
        viewModel = CartViewViewModel()
        super.init(frame: frame)
        
        cartTableView.backgroundColor = Colors.shared.darkPirple
        backgroundColor = Colors.shared.darkPirple
        addSubviewes(views: cartTableView, checkOutButton, titlesLabelsStack, priceLabelsStack)
        setupButton()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(CartCell.self, forCellReuseIdentifier: CartCell.cellID)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.setupStacks()
            self?.setTitlesLabels()
            self?.setConstraints()
        }
    }
    
    private func addSubviewes(views: UIView...) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        cartTableView.topAnchor.constraint(equalTo: topAnchor, constant: frame.height * 0.067),
        cartTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
        cartTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        cartTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(frame.height * 0.27)),
        
        titlesLabelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width * 0.1),
        titlesLabelsStack.topAnchor.constraint(equalTo: cartTableView.bottomAnchor, constant: frame.height * 0.03),
        titlesLabelsStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
        
        priceLabelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(frame.width * 0.1)),
        priceLabelsStack.topAnchor.constraint(equalTo: cartTableView.bottomAnchor, constant: frame.height * 0.03),
        priceLabelsStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
        
        checkOutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        checkOutButton.topAnchor.constraint(equalTo: titlesLabelsStack.bottomAnchor, constant: frame.height * 0.03),
        checkOutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(frame.height * 0.03)),
        checkOutButton.widthAnchor.constraint(equalToConstant: frame.width * 0.8)
        ])
    }
    
    private func setupStacks() {
        titlesLabelsStack.axis = .vertical
        titlesLabelsStack.spacing = frame.height * 0.03
        
        priceLabelsStack.axis = .vertical
        priceLabelsStack.spacing = frame.height * 0.03
    }
    
    private func setupButton() {
        checkOutButton.backgroundColor = Colors.shared.orangeColor
        checkOutButton.setTitle("Checkout", for: .normal)
        checkOutButton.layer.masksToBounds = true
        checkOutButton.layer.cornerRadius = 8
        checkOutButton.addTarget(self, action: #selector(checkOut), for: .touchUpInside)
    }
    
    private func setTitlesLabels() {
        let total = UILabel()
        let delivery = UILabel()
        
        total.font = UIFont(name: "Mark-Regular", size: 14)
        total.textColor = .white
        total.text = "Total"
        
        delivery.font = UIFont(name: "Mark-Regular", size: 14)
        delivery.textColor = .white
        delivery.text = "Delivery"
        
        titlesLabelsStack.addArrangedSubview(total)
        titlesLabelsStack.addArrangedSubview(delivery)
    }
    
    private func setPrices() {
        let price = UILabel()
        let discount = UILabel()
        
        price.font = UIFont(name: "Mark-Regular", size: 14)
        price.textColor = .white
        price.text = UserDefaultsManager.shared?.getTotalPrice() ?? ""
        UserDefaultsManager.shared?.totalPriceSubject.bind { price.text = $0 }.disposed(by: viewModel.disposeBag)
        price.textAlignment = .right
        
        discount.font = UIFont(name: "Mark-Regular", size: 14)
        discount.textColor = .white
        discount.text = "Free"
        discount.textAlignment = .right
        
        titlesLabelsStack.addArrangedSubview(price)
        titlesLabelsStack.addArrangedSubview(discount)
    }
    
    @objc private func checkOut() {
        print("Здесь какая-то оплата")
        let alertController = UIAlertController(title: "Take My Money", message: "And accept me for a job", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "I will accept you", style: .default))
        alertController.addAction(UIAlertAction(title: "I will accept you", style: .destructive))
        
        buttonTapped.onNext(alertController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.cellID, for: indexPath) as! CartCell
        
        if cell.viewModel == nil {      //Тут в ячейку стоило бы передавать уникальный айди каждого девайся и дальше его прокидывать в ячайке в степпер
                                        //Но в данном контексте с одним девайсом использую просто глобальную ссылку на девайс
            cell.configureCellWith(viewModel: viewModel.setCellViewModelWith(indexPath: indexPath))
            cell.customStepper?.delegate = self
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height * 0.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CartTableViewController: CartTableViewControllerProtocol {
    func reloadData() {
        viewModel.reloadData()
        cartTableView.reloadData()
    }
}
