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

    func createOrder(nameCustomer: String?, note: String?, phoneNumber: String?, bookingDate: Date?,
                     timePickup: String?, storeId: Int, productList: [SalonProductModel], staffSelected: StaffModel, paymentMethod: PaymentModel, callback: @escaping (_ status: Bool, _ error: String?) -> Void) {
        guard let customerName = nameCustomer,
            let customerPhone = phoneNumber else {
            callback(false, "Customer name or phone number cannot be empty.")
            return
        }

        guard let dateBooked = bookingDate,
            let timeBooked = timePickup else {
            callback(false, "Please picked date book.")
            return
        }

        if dateBooked <= Date() {
            callback(false, "Date Booked invalid.")
            return
        }

        let user = UserDefaultUtils.getUser()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: dateBooked)

        var sum:Double = 0
        for item in productList {
            sum += item.price
        }

        self.provider.request(.createOrder(customerId: user!.userId, storeId: storeId, amount: sum, bookedDate: dateString, status: "New", note: note!, customerName: customerName, customerPhone: customerPhone, timer: timeBooked, productList: productList, staff: staffSelected, payment: paymentMethod)) { (result) in
            switch result {
            case .success(let response):
                do {
                    _ = try response.mapJSON() as? [String:Any]
//                    print(data!["message"])
                    callback(true, nil)
                } catch {
                    let error = "Cannot map data"
                    callback(false, error)
                }
            case .failure(let error):
                let errorString = error.errorDescription
                callback(false, errorString)
            }
        }
    }
}
