//
//  OnTapProtocolPattern.swift
//  Test
//
//  Created by Сергей Веретенников on 31/08/2022.
//

import Foundation
import UIKit

protocol ButtonTapped {
    func selectCategoryButtonTapped(sender: CustomButtonForDetails)
    func selectColorTapped(sender: SelectColorButton)
    func selectMemoryTapped(sender: SelectMemoryButton)
}

extension AboutDeviceView: ButtonTapped {
    func selectCategoryButtonTapped(sender: CustomButtonForDetails) {
        guard let buttons = subviews.filter({ $0 is CustomButtonForDetails }) as? [CustomButtonForDetails] else { return }
        
        buttons.forEach { 
            $0.underlineView.isHidden = true
            $0.changeButtonState()
        }
        
        sender.underlineView.isHidden = false
        sender.changeButtonState()
    }
    
    func selectColorTapped(sender: SelectColorButton) {
        guard let buttons = colorSelectScrollView.subviews.filter({ $0 is SelectColorButton }) as? [SelectColorButton] else { return }
        
        buttons.forEach {
            let button = $0
            button.isSelected = false
        }
        
        sender.isSelected = true
    }
    
    func selectMemoryTapped(sender: SelectMemoryButton) {
        guard let buttons = memorySelectionScrollView.subviews.filter({ $0 is SelectMemoryButton }) as? [SelectMemoryButton] else { return }
        
        buttons.forEach {
            let button = $0
            button.isSelected = false
        }
        
        sender.isSelected = true
    }
}
