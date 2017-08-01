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
//                let notificationList = [NotificationModel(name: "Order #210", icon: ImageConstant.IconCloud!, content: "Gel clear, Polish Application", type: "2", dateString: "2017-07-28T15:30", isRead: false),
//                                        NotificationModel(name: "Order #232", icon: ImageConstant.IconCloud!, content: "Stone studded nails, Paint nails or toenails", type: "2", dateString: "2017-07-28T13:30", isRead: false),
//                NotificationModel(name: "Order #205", icon: ImageConstant.IconCloud!, content: "Pedicure, Polish toes, Spa Pedicure, Soothing Foot Massage-30 min", type: "2", dateString: "2017-07-28T9:30", isRead: false)]
                var listNotification = [NotificationModel]()
                do {
                    let json = try response.mapJSON() as? [[String:Any]]
                    for item in json! {
                        let order = self.migrateNotificationData(jsonData: item)
                        if order != nil {
                            listNotification.append(order!)
                        }
                    }
//                    let indexPrice: [Double] = [32, 53, 55]
//                    var index = 0
//                    for item in notificationList {
//                        item.orderId = index
//                        item.price = indexPrice[index]
//                        item.isConfirmOder = true
//                        listNotification.append(item)
//                        index+=1
//                    }

                    callback(listNotification, nil)
                } catch {
                    let error = "Cannot map data"
                    callback([], error)
                }
            }
        }
    }

    /// Send confirmed Order
    func confirmOrderAPI(notificationItem: NotificationModel, action: Int, callback: @escaping(_ listNotification: [NotificationModel], _ error: String?) -> Void) {
        let user = UserDefaultUtils.getUser()
        self.provider.request(.confirmOrRejectOrder(notificationItem: notificationItem, customerId: user!.userId, action: action)) { (result) in
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
    }

    func migrateNotificationData(jsonData: [String:Any]) -> NotificationModel? {
        guard let notificationId = jsonData["id"] as? Int,
            let title = jsonData["title"] as? String,
            let dateCreated = jsonData["createDate"] as? String,
            let isConfirmOrder = jsonData["isConfirmOrder"] as? Bool,
            let type = jsonData["notificationType"] as? Int,
            let status = jsonData["status"] as? Bool else {
            return nil
        }

        let orderId = jsonData["orderId"] as? Int
        let description = jsonData["description"] as? String
        let service = jsonData["services"] as? String
        let price = jsonData["price"] as? Double

        let notification = NotificationModel(notificationId: notificationId, title: title, type: type, dateString: dateCreated, isRead: status)

        notification.isConfirmOder = isConfirmOrder
        notification.content = description

        if type == 2 {
            notification.orderId = orderId!
            notification.services = service!
            notification.price = price!
        }

        return notification
    }

}
