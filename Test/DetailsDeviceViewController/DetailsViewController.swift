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
            let collectionViewDetails = PhotoCollectionViewViewModel(url: viewModel?.deviceDetails.images ?? [])
            collectionView.viewModel = collectionViewDetails
        }
    }
    
    private let collectionView = PhotoCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.shared.backgroundColor
        collectionView.backgroundColor = Colors.shared.backgroundColor
        setSubviewes()
        setConstraints()
        setNavController() 
    }
    
    private func setSubviewes() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 2)
        ])
    }
    
    private func setNavController() {
        navigationController?.navigationItem.backBarButtonItem = nil
    }
}
