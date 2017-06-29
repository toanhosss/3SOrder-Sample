//
//  OrderController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/28/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

class OrderController: NSObject {
    // create instance
    static let SharedInstance: OrderController = {
        var controller = OrderController()
        return controller
    }()

    let provider = MoyaProvider<APIService>()

    
}
