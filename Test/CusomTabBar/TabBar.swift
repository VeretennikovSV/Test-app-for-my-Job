//
//  ViewController.swift
//  Test
//
//  Created by Сергей Веретенников on 27/08/2022.
//

import UIKit
import RxSwift

enum TabItems: String {
    case bag
    case favorites
    case profile
}

class CustomBar: UITabBarController, UIGestureRecognizerDelegate {
        
    private let disposeBag = DisposeBag()
    private lazy var explorerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (barWidth * 0.5), height: barHeight))

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.masksToBounds = true
        tabBar.backgroundColor = Colors.shared.darkPirple
        tabBar.isTranslucent = false
        tabBar.barTintColor = Colors.shared.darkPirple
        
        explorerLabel.text = "\u{2022} Explorer"
        explorerLabel.font = UIFont(name: "Mark-Regular", size: 16)
        explorerLabel.textColor = .white
        explorerLabel.textAlignment = .center
        
        addSubviewes()
        
        addControllers(controllerType: [.bag, .favorites, .profile])
    }
    
    private func addSubviewes() {
        tabBar.addSubview(explorerLabel)
    }
    
    func addControllers(controllerType: [TabItems]) {
        var numberOfItems: CGFloat = 0
        controllerType.forEach { items in
            var itemType: TabItems
            switch items {
            case .bag:
                itemType = .bag
            case .favorites:
                itemType = .favorites
            default:
                itemType = .profile
            }
            let view = CustimTabBarItem(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
            let viewViewModel = TabBarItemViewModel(tabItem: itemType)
            view.setViewWith(viewModel: viewViewModel)
            
            print(viewViewModel)
            
            view.viewModel?.onTap.bind { tabItem in
                switch tabItem {
                case .bag:
                    self.selectedViewController = self.viewControllers?[1]
                default:
                    self.selectedViewController = self.viewControllers?[0]
                }
            }.disposed(by: disposeBag)
            
            tabBar.addSubview(view)
            
            let viewWidth = (barWidth * 0.6) / CGFloat(controllerType.count)
            let xOffset = viewWidth * numberOfItems
            
            view.frame = CGRect(x: (barWidth * 0.4) + xOffset, y: 0, width: viewWidth, height: barHeight)
            numberOfItems += 1
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if touch.view?.isDescendant(of: tabBar) == true {
            return false
         }
         return true
    }
}

extension CustomBar {
    var barHeight: CGFloat {
        tabBar.frame.height
    }
    
    var barWidth: CGFloat {
        tabBar.frame.width
    }
}
