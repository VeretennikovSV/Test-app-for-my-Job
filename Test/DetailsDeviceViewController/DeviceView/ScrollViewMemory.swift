//
//  MemoryScroll.swift
//  Test
//
//  Created by Сергей Веретенников on 31/08/2022.
//

import Foundation
import UIKit

final class MemorySeclectionScrollView: UIScrollView {
    
    private var spacing: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(subviews.count)
        
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        view.frame.size.height = bounds.height
        view.frame.size.width = bounds.height * 2.5
        view.layer.masksToBounds = true
        
        addView(view: view)
    }
    
    private func addView(view: UIView) {
        let currentButtons = subviews.filter { $0 is SelectMemoryButton }
        if currentButtons.count > 1 { 
            spacing = view.frame.width / 2
        }
        view.frame.origin.x = CGFloat(currentButtons.count - 1) * frame.height * 2 + spacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
