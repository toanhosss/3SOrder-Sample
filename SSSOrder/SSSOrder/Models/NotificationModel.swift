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
    var name: String
    var icon: UIImage
    var type: String
    var isReadable: Bool
    private var _dateString: String
    var dateString: String {
        get {
            return getDateString(dateString: _dateString)
        }

        set {
            _dateString = newValue
        }
    }

    var content: String
    var price: Double = 0
    var isConfirmOder: Bool = false
    var orderId: Int?

    init(name: String, icon: UIImage, content: String, type: String, dateString: String, isRead: Bool) {
        self.name = name
        self.icon = icon
        self.type = type
        self.isReadable = isRead
        self._dateString = dateString
        self.content = content
    }

    private func getDateString(dateString: String) -> String {

        let result = DateUtil.convertDateTimeFromStringToDateTimeAgo(dateString: dateString, format: "yyyy-MM-dd'T'HH:mm")

        return result
    }
}
