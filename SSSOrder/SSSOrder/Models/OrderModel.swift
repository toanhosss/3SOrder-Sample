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
    var bookingDate: String! // Current date format: EEEE, MMMM dd, yyyy
    var timePickup: String
    var staff: StaffModel?
    var productList: [SalonProductModel] = []
    var totalPrice: Double = 0

    init(orderId: Int, storeId: Int, customerId: Int, status: String, note: String, bookingDate: String, timePickup: String, productList: [SalonProductModel]) {
        self.orderId = orderId
        self.storeId = storeId
        self.customerId = customerId
        self.status = status
        self.note = note
        self.bookingDate = bookingDate
        self.timePickup = timePickup
        self.productList = productList
    }

    func getDatefromBookingDate() -> Date? {
        let formatList = ["EEEE, MMMM dd, yyyy", "yyyy-MM-dd'T'HH:mm:ss.sssZ", "yyyy-MM-dd", "yyyy-MM-dd'T'HH:mm:ss"]
        var date: Date?
        for i in 0..<formatList.count {
            let formater = DateFormatter()
            formater.dateFormat = formatList[i]
            if formater.date(from: bookingDate) != nil {
                date = formater.date(from: bookingDate)
            }
        }
        return date
    }

    func getTotalPrice() -> Double {
        return totalPrice
    }
}
