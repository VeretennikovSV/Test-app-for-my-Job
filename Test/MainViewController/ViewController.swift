//
//  ViewController.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {
    
    private var viewModel: MainViewControllerViewModelProtocol!
    
    private var scrollView = UIScrollView()
    private let selectCatLabel = UILabel()
    private let viewAllButton: UIButton = {
        let button = UIButton(frame: .zero)
        var config: UIButton.Configuration = .borderless()
        
        config.title = "View all"
        config.baseForegroundColor = Colors.shared.orangeColor
        button.configuration = config
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        
        return button
    }()
    
    private let hotSalesLabel = UILabel()
    private let hotSalesSeeMoreButton: UIButton = {
        let button = UIButton(frame: .zero)
        var config: UIButton.Configuration = .borderless()
        
        config.title = "See more"
        config.baseForegroundColor = Colors.shared.orangeColor
        button.configuration = config
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        
        return button
    }()
    
    private let bestSellerLabel = UILabel()
    private let bestSellerSeeMoreButton: UIButton = {
        let button = UIButton(frame: .zero)
        var config: UIButton.Configuration = .borderless()
        
        config.title = "See more"
        config.baseForegroundColor = Colors.shared.orangeColor
        button.configuration = config
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        
        return button
    }()
    
    private let topCollectionView = CategoryCollectionView()
    private let hotSalesCollectionView = HotSalesCollection()
    private let bestSellerCollectionView = BestSellerCollectionView()
    
    private let search = UISearchBar()
    private let filterView = FilterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.shared.backgroundColor
        viewModel = MainViewControllerViewModel()
        fetchData()
        setNavController()
        setInterface()
        
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setRadius()
        setConstraints()
        scrollView.contentSize.height = bestSellerCollectionView.frame.maxY
    }
    
    func addNavBarTitile() {
        guard let navController = self.navigationController else { return }
        
        let label = UILabel()
        label.text = "Zihuatanejo, Gro"
        
        let image = UIImage(named: "PositionMark")?.resizeImageTo(size: CGSize(width: 15, height: 20))
        let imageView = UIImageView(image: image)
        
        let container = UIStackView(frame: navController.navigationBar.frame)
        
        container.addArrangedSubview(imageView)
        container.addArrangedSubview(label)
        imageView.contentMode = .scaleAspectFit

        container.axis = .horizontal
        container.spacing = 8
        
        navigationItem.titleView = container
    }
    
    private func setNavController() {
        let filterImage = UIImage(named: "Vector")?.resizeImageTo(size: CGSize(width: 15, height: 15))
        let filterBarItem = UIBarButtonItem(image: filterImage, style: .plain, target: self, action: #selector(filterTapped))
        filterBarItem.tintColor = .black
        
        navigationItem.rightBarButtonItem = filterBarItem
        
        
        addNavBarTitile()
    }
    
    private func fetchData() {
        viewModel.fetchPublisher
            .withUnretained(self)
            .bind { sel, data in
                sel.hotSalesCollectionView.viewModel.observableAccepterOfData.onNext(data.homeStore)
                sel.bestSellerCollectionView.viewModel.observableAccepterOfData.onNext(data.bestSeller)
                
                sel.bestSellerCollectionView.viewModel.observable.bind { url in
                    let detailsViewController = DetailsViewController()
                    sel.show(detailsViewController, sender: nil)
                    let detailsModel: Observable<DeviceDetails> = NetworkManager().performGet(urlString: url)  //Ошибся на стадии создания коллекции.
                                                                                                               //Нужно было в коллекции хранить массив с моделями ячеек а не модели данных для ячеек
                                                                                                               //Не надо было бы такие длинные байндинги прокладывать
                    detailsModel.bind { deviceDetails in
                        detailsViewController.viewModel = DetailsViewControllerViewModel(details: deviceDetails)
                        detailsViewController.viewModel?.deviceDetailsLoaded.onNext(deviceDetails)
                    }.disposed(by: sel.viewModel.disposedBad)
                    detailsModel.bind { device in
                        print(device)
                    }.disposed(by: sel.viewModel.disposedBad)
                }.disposed(by: sel.viewModel.disposedBad)
            }.disposed(by: viewModel.disposedBad)
    }
    
    @objc private func filterTapped() {
        filterView.isHidden.toggle()
    }
    
    private func setInterface() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        selectCatLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        hotSalesLabel.translatesAutoresizingMaskIntoConstraints = false
        hotSalesSeeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        hotSalesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        bestSellerLabel.translatesAutoresizingMaskIntoConstraints = false
        bestSellerSeeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        bestSellerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        search.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        
        view.addSubview(scrollView)
        view.addSubview(filterView)
        filterView.isHidden = true
        filterView.backgroundColor = .white
        filterView.layer.masksToBounds = true
//        filterView.layer.cornerRadius = 18
        
        scrollView.addSubview(selectCatLabel)
        scrollView.addSubview(viewAllButton)
        scrollView.addSubview(topCollectionView)
        
        scrollView.addSubview(hotSalesLabel)
        scrollView.addSubview(hotSalesSeeMoreButton)
        scrollView.addSubview(hotSalesCollectionView)
        
        scrollView.addSubview(bestSellerLabel)
        scrollView.addSubview(bestSellerSeeMoreButton)
        scrollView.addSubview(bestSellerCollectionView)
        
        scrollView.addSubview(search)
        
        search.placeholder = "Search"
        search.layer.borderColor = UIColor.clear.cgColor
        search.layer.borderWidth = 0
        search.searchTextField.layer.masksToBounds = true
        search.searchTextField.layer.cornerRadius = 20
        search.searchTextField.font = .systemFont(ofSize: 13)
        search.backgroundImage = UIImage()
        
        selectCatLabel.font = .boldSystemFont(ofSize: 26)
        selectCatLabel.text = "Select Category"
        
        hotSalesLabel.font = .boldSystemFont(ofSize: 26)
        hotSalesLabel.text = "Hot Sales"
        
        bestSellerLabel.font = .boldSystemFont(ofSize: 26)
        bestSellerLabel.text = "Best Seller"
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            selectCatLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            selectCatLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            selectCatLabel.heightAnchor.constraint(equalToConstant: screenHeight * 0.05),
            selectCatLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.45),
            
            viewAllButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            viewAllButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            viewAllButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.05),
            
            topCollectionView.topAnchor.constraint(equalTo: selectCatLabel.bottomAnchor,constant: 16),
            topCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            topCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: screenHeight * 0.11),
            
            search.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 16),
            search.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: screenWidth * 0.04),
            search.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -(screenWidth * 0.2)),
            
            hotSalesLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            hotSalesLabel.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 16),
            hotSalesLabel.heightAnchor.constraint(equalToConstant: screenHeight * 0.05),
            hotSalesLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.45),
            
            hotSalesSeeMoreButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            hotSalesSeeMoreButton.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 16),
            hotSalesSeeMoreButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.05),
            
            hotSalesCollectionView.topAnchor.constraint(equalTo: hotSalesSeeMoreButton.bottomAnchor,constant: 16),
            hotSalesCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hotSalesCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hotSalesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            bestSellerLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            bestSellerLabel.topAnchor.constraint(equalTo: hotSalesCollectionView.bottomAnchor, constant: 16),
            bestSellerLabel.heightAnchor.constraint(equalToConstant: screenHeight * 0.05),
            bestSellerLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.45),
            
            bestSellerSeeMoreButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            bestSellerSeeMoreButton.topAnchor.constraint(equalTo: hotSalesCollectionView.bottomAnchor, constant: 16),
            bestSellerSeeMoreButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.05),
            
            bestSellerCollectionView.topAnchor.constraint(equalTo: bestSellerSeeMoreButton.bottomAnchor,constant: 16),
            bestSellerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bestSellerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bestSellerCollectionView.heightAnchor.constraint(equalToConstant: screenHeight * 0.6),
            
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.topAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    private func setRadius() {
        let path = UIBezierPath(roundedRect: filterView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        filterView.layer.mask = maskLayer
    }
}


//MARK: Appearence
extension ViewController {
    
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
}

