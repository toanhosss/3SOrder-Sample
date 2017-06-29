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
    var customerId: Int!
    var status: String!
    var note: String!
    var bookingDate: String!
    var isCheckedIn: Bool
    var isCheckedOut: Bool
    var timePickup: String
    var productList: [SalonProductModel] = []

    init(orderId: Int, storeId: Int, customerId: Int, status: String, note: String,
         bookingDate: String, isCheckedIn: Bool, isCheckedOut: Bool, timePickup: String,
         productList: [SalonProductModel]) {
        self.orderId = orderId
        self.storeId = storeId
        self.customerId = customerId
        self.status = status
        self.note = note
        self.bookingDate = bookingDate
        self.isCheckedIn = isCheckedIn
        self.isCheckedOut = isCheckedOut
        self.timePickup = timePickup
        self.productList = productList
    }
}
