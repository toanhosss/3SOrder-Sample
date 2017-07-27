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
        let user = UserDefaultUtils.getUser()
        self.provider.request(.getNotificationList(customerId: user!.userId)) { (result) in
            switch result {
            case .failure(let error):
                let errorString = error.errorDescription
                callback([], errorString)
            case .success(let response):
                var listNotification = [NotificationModel]()
                do {
                    let json = try response.mapJSON() as? [[String:Any]]
                    for item in json! {
                        let order = self.migrateNotificationData(jsonData: item)
                        if order != nil {
                            listNotification.append(order!)
                        }
                    }
                    callback(listNotification, nil)
                } catch {
                    let error = "Cannot map data"
                    callback([], error)
                }
            }
        }
//        let notification = [ NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
//                             NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
//                             NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
//                             NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true),
//                             NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true),
//                             NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true)]
//        callback(notification, nil)
    }

    func migrateNotificationData(jsonData: [String:Any]) -> NotificationModel? {
        guard let title = jsonData["title"] as? String,
            let dateCreated = jsonData["createDate"] as? String,
            let isConfirmOrder = jsonData["isConfirmOrder"] as? Bool,
            let description = jsonData["description"] as? String,
            let type = jsonData["type"] as? Int,
            let status = jsonData["status"] as? Bool else {
            return nil
        }

        let orderId = jsonData["orderId"] as? Int

        let notification = NotificationModel(name: title, icon: ImageConstant.IconMail!, content: description, type: String(type), dateString: dateCreated, isRead: status)
        notification.isConfirmOder = isConfirmOrder
        if type == 2 {
            notification.orderId = orderId!
        }
        return notification
    }
}
