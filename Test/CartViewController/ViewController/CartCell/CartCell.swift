//
//  CartCell.swift
//  Test
//
//  Created by Сергей Веретенников on 31/08/2022.
//

import Foundation
import UIKit 
import RxSwift

final class CartCell: UITableViewCell {
    static let cellID = "CartCell"
    
    var viewModel: CellViewModelProtocol? 
    var customStepper: CustomStepperForCell?
    
    private var image: UIImageView?
    private var cellTitile: UILabel?
    private var price: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.shared.darkPirple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellWith(viewModel: CellViewModelProtocol) {
        self.viewModel = viewModel
        
        viewModel.fetchDetails
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { sel, details in
                sel.cellTitile?.text = viewModel.cellDeviceDetails?.title ?? ""
                sel.cellTitile?.sizeToFit()
                
                sel.calcPriceLabel()
                
                sel.customStepper?.devicesCount.text = "\(UserDefaultsManager.shared?.getCurrentDeviceCountWith(string: deviceURL) ?? 0)"
                
                viewModel.imageLoader.photoSenderObserver
                    .observe(on: MainScheduler.instance)
                    .withUnretained(self)
                    .bind { sel, image in
                        sel.image?.image = image
                        sel.image?.layer.masksToBounds = true
                        sel.image?.layer.cornerRadius = 15
                }.disposed(by: viewModel.disposeBag)
                
                guard let imageUrl = URL(string: details.images[0]) else { return }
                viewModel.imageLoader.getImageFrom(url: imageUrl)
            }.disposed(by: viewModel.disposeBag)
        
        
        image = UIImageView(frame: CGRect(x: frame.height * 0.1, y: frame.height * 0.1, width: frame.height * 0.8, height: frame.height * 0.8))
        cellTitile = UILabel(frame: CGRect(x: frame.height, y: frame.height * 0.1, width: frame.width * 0.45, height: frame.height * 0.4))
        price = UILabel(frame: CGRect(x: frame.height, y: frame.height * 0.6, width: frame.width * 0.45, height: frame.height * 0.3))
        customStepper = CustomStepperForCell(frame: CGRect(x: frame.width * 0.75, y: frame.height * 0.18, width: frame.width * 0.07, height: frame.height * 0.64))
        
        
        price?.font = UIFont(name: "Mark-Bold", size: 22)
        price?.textColor = Colors.shared.orangeColor
        price?.sizeToFit()
        
        UserDefaultsManager.shared?.countOfExactDevice.bind { [unowned self] _ in
            calcPriceLabel()
        }.disposed(by: viewModel.disposeBag)
        
        image?.contentMode = .scaleAspectFit
        
        cellTitile?.textColor = .white
        cellTitile?.lineBreakMode = .byTruncatingTail
        cellTitile?.numberOfLines = 0
        
        cellTitile?.font = UIFont(name: "Mark-Regular", size: 20)
        
        contentView.addSubview(image ?? UIImageView())
        contentView.addSubview(cellTitile ?? UILabel())
        contentView.addSubview(price ?? UILabel())
        contentView.addSubview(customStepper ?? CustomStepperForCell())
    }
    
    private func calcPriceLabel() {
        price?.text = viewModel?.getSummPrice()
        price?.sizeToFit()
    }
}
