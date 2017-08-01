//
//  MyTabbar.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 7/9/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class MyTabbar: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = ScreenSize.ScreenHeight*0.08

        return sizeThatFits
    }
}

extension MyTabbar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let navigation = viewController as? UINavigationController
        if navigation != nil && navigation!.viewControllers.first is NotificationViewController {
            tabBarController.tabBar.items?[1].badgeValue = nil
        }
    }
}
