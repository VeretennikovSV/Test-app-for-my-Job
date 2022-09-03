//
//  TabBarItemViewModel.swift
//  Test
//
//  Created by Сергей Веретенников on 27/08/2022.
//

import Foundation
import RxSwift
import RxRelay

final class TabBarItemViewModel {
    let tabItem: TabItems
    let onTap = PublishSubject<TabItems>()
    
    init(tabItem: TabItems) {
        self.tabItem = tabItem
    }
}
