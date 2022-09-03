//
//  DetailsViewController.swift
//  Test
//
//  Created by Сергей Веретенников on 29/08/2022.
//

import Foundation
import UIKit

final class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewControllerViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            let collectionViewDetails = PhotoCollectionViewViewModel(url: viewModel.deviceDetails.images)
            collectionView.viewModel = collectionViewDetails
            
            viewModel.deviceDetailsLoaded
                .withUnretained(self)
                .bind { sel, details in
                    sel.deviceView.viewModel = AboutDeviceViewViewModel(details: details)
                    sel.deviceView.viewModel?.acceptDeviceDetails.onNext(details)
                }.disposed(by: viewModel.disposeBag)
        }
    }
    
    private let pageController = UIPageControl()
    private let collectionView = PhotoCollectionView()
    private lazy var deviceView = AboutDeviceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.shared.backgroundColor
        title = "Product Details"
        
        collectionView.backgroundColor = Colors.shared.backgroundColor
        setSubviewes()
        setNavController()
        
        deviceView.backgroundColor = .white
        deviceView.layer.masksToBounds = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setRadius()
    }
    
    private func setSubviewes() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(deviceView)
        deviceView.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 2.35),
            
            deviceView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            deviceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deviceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deviceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setRadius() {
        setRadiusTo(view: deviceView, corners: [.topLeft, .topRight], size: CGSize(width: 30, height: 30))
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
        
        
        let basketButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        basketButton.setImage(UIImage(systemName: "cart"), for: .normal)
        basketButton.backgroundColor = Colors.shared.orangeColor
        basketButton.tintColor = .white
        basketButton.layer.masksToBounds = true
        basketButton.layer.cornerRadius = 8
        basketButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: basketButton)
    }
    
    @objc private func openCart() {
        show(CartViewController(), sender: nil)
    }
    
    @objc private func dismissView() {
        navigationController?.popViewController(animated: true)
    }
}
