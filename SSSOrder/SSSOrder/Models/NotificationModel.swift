//
//  NotificationModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/26/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit

class NotificationModel: NSObject {
    var name: String
    var icon: UIImage
    var type: String
    var isReadable: Bool
    var dateString: String
    var content: String
    var isConfirmOder: Bool = false
    var orderId: Int? = nil

    init(name: String, icon: UIImage, content: String, type: String, dateString: String, isRead: Bool) {
        self.name = name
        self.icon = icon
        self.type = type
        self.isReadable = isRead
        self.dateString = dateString
        self.content = content
    }
}
