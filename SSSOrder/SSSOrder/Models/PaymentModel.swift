//
//  PaymentModel.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/29/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation

enum PaymentType: String {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case paypal = "Paypal"
    case visaCard = "Visa Card"
}

class PaymentModel: NSObject {

    var type: PaymentType!
    var name: String?
    var cardNumber: String?
    var expiredDay: String?

    init(type: PaymentType) {
        self.type = type
    }

}
