//
//  HistoryBooking.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 7/17/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation

class HistoryBookingController: NSObject {
    static let SharedInstance: HistoryBookingController = {
        var controller = HistoryBookingController()
        return controller
    }()
}
