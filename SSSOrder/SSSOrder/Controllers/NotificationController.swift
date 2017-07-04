//
//  NotificationController.swift
//  SSSOrder
//
//  Created by Toan Ho on 7/4/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

class NotificationController: NSObject {
    // create instance
    static let SharedInstance: NotificationController = {
        var controller = NotificationController()
        return controller
    }()

    let provider = MoyaProvider<APIService>()

    let notificationType = ["Promotion", "System Notification"]

    /// Get list notification
    func getListNotification(callback: @escaping(_ notifications: [NotificationModel], _ error: String?) -> Void) {
        let notification = [ NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
                             NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
                             NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
                             NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true),
                             NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true),
                             NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true)]
        callback(notification, nil)
    }
}
