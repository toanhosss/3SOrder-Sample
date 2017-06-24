//
//  CartViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class CartViewController: BaseController {

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("service", comment: "")
        self.backTitle = NSLocalizedString("back", comment: "")
    }
}
