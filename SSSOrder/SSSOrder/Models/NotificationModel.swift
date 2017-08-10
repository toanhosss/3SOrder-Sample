//
//  NotificationModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/26/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit
import DateToolsSwift

class NotificationModel: NSObject {
    var notificationId: Int
    var title: String
    var type: Int
    var isReadable: Bool // Status

    private var _dateString: String
    var dateString: String {
        get {
            return getDateString(dateString: _dateString)
        }

        set {
            _dateString = newValue
        }
    }

    var icon: UIImage { return setIconByType() }

    var notificationName: String {return setNotificationName() }

    var content: String?
    var price: Double = 0
    var isConfirmOder: Bool = false
    var orderId: Int?
    var services: String?

    init(notificationId: Int, title: String, type: Int, dateString: String, isRead: Bool) {

        self.notificationId = notificationId
        self.title = title
        self.type = type
        self.isReadable = isRead
        self._dateString = dateString
    }

    ///
    /// Get content for notication
    ///
    /// - Returns: string value
    func getContentForNotification() -> String {
        if type == 2 {
            return self.services!
        }

        if type == 3 {
            return "Booking Completed."
        }
        return self.content!
    }

    /// Get date time ago
    ///
    /// - Parameter dateString: string value of date
    /// - Returns: value was formatted by dateTimeAgo
    private func getDateString(dateString: String) -> String {

        let result = DateUtil.convertDateTimeFromStringToDateTimeAgo(dateString: dateString, format: "yyyy-MM-dd'T'HH:mm:ss.SSS")

        return result
    }

    func getRawDateString() -> String { return _dateString }

    private func setIconByType() -> UIImage {
        switch type {
        case 2:
            return ImageConstant.IconCloud!
        default:
            return ImageConstant.IconCloud!
        }

    }

    private func setNotificationName() -> String {
        if type == 2 && isConfirmOder {
            return "Booking #\(orderId!)"
        }

        return title
    }
}
