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
