//
//  Extensions.swift
//  Test
//
//  Created by Сергей Веретенников on 23/08/2022.
//

import Foundation
import UIKit


extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return scaledImage
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (hexString.hasPrefix("#")) {
            hexString.remove(at: hexString.startIndex)
        }
        
        var color = UInt64(0)
        Scanner(string: hexString).scanHexInt64(&color)
        
        let red = CGFloat((color & 0xFF0000) >> 16) / 255
        let green = CGFloat((color & 0x00FF00) >> 8) / 255
        let blue = CGFloat(color & 0x0000FF) / 255 
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
