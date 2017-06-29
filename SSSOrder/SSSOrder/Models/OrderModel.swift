//
//  OrderModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/29/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
class OrderModel: NSObject {

    var orderId: Int!
    var storeId: Int!
    var productList: [SalonProductModel] = []
}
