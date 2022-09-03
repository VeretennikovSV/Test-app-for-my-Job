//
//  CustomDiscountPriceLabel.swift
//  Test
//
//  Created by Сергей Веретенников on 25/08/2022.
//

import Foundation
import UIKit

final class DiscountlessLabel: UIView {
    
    let price = UILabel()
    let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        price.font = UIFont(name: "Mark-Bold", size: 14)
        price.textColor = .gray
        line.backgroundColor = .gray
        
        addSubview(price)
        price.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(line, aboveSubview: price)
        price.textAlignment = .center
        
        NSLayoutConstraint.activate([
            price.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 1),
            line.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            line.centerYAnchor.constraint(equalTo: price.centerYAnchor),
            line.heightAnchor.constraint(equalToConstant: 1.5)
        ])

    }
    
    func setPriceWith(number: Int) {
        price.text = "$\(number)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
