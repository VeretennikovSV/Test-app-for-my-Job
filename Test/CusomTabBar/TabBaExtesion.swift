//
//  TabBat.swift
//  Test
//
//  Created by Сергей Веретенников on 27/08/2022.
//

import UIKit


extension UITabBar {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let pointInTabBar = super.point(inside: point, with: event)
        
        if pointInTabBar {
            for subview in subviews {
                if let sw = subview as? CustimTabBarItem {
                    let pointInSubview = sw.convert(point, from: self)
                    if sw.point(inside: pointInSubview, with: event)  {
                        sw.tabBarItemTapped()
                        return false
                    }
                }
            }
        }
        return false
    }
}
