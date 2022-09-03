//
//  AddRadiustoViewExtension.swift
//  Test
//
//  Created by Сергей Веретенников on 31/08/2022.
//

import Foundation
import UIKit

public func setRadiusTo(view: UIView, corners: UIRectCorner, size: CGSize) {
    let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: size)
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    
    view.layer.mask = maskLayer
}
