//
//  BookingHistoryViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 7/17/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class BookingHistoryViewController: BaseController {

    var tableView: UITableView!
    let bookingHistory = HistoryBookingController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("history", comment: "")

    }
}
