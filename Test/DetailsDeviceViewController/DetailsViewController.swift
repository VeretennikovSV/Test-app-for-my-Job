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
        let path = UIBezierPath(roundedRect: deviceView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        deviceView.layer.mask = maskLayer
    }
    
    private func setNavController() {
        navigationController?.navigationItem.backBarButtonItem = nil
    }
}
