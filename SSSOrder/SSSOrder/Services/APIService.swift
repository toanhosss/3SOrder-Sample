//
//  APIService.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/27/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

enum APIService {
    case login(phone: String, password: String, token: String)
    case register(name: String, phone: String, password: String, token: String)
    case getStoreByGPS(lat: String, long: String)
    case getCategoriesByStore(storeId: Int)
    case getOrderDetail(orderId: Int)
    case createOrder(customerId: Int, storeId: Int, amount: Double, bookedDate: String, status:  String, note: String, customerName: String, customerPhone: String, timer: Int64, productList: [SalonProductModel], staff: StaffModel, payment: PaymentModel)
    case getStaffSchedule(date: String, time: Int64, storeId: Int, productListId: [Int])
    case getListOrderToday(customerId: Int)
    case checkInCheckoutOrderQRCode(orderList:[OrderModel])
    case getNotificationList(customerId: Int)
    case updateNotificationStatus(customerId: Int, notificationId: Int)
    case confirmOrRejectOrder(notificationItem: NotificationModel, customerId: Int, action: Int)
}

// MARK: - TargetType Protocol Implementation
extension APIService: TargetType {
    /// The target's base `URL`.
    public var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }

    var path: String {
        switch self {
        case .login, .register:
            return "/api/Account/LoginOrRegister"
        case .getStoreByGPS:
            return "/api/Store/GetStoreByGPS"
        case .getCategoriesByStore:
            return "/api/Category/GetCategories"
        case .createOrder:
            return "/api/Order/CreateOrder"
        case .getOrderDetail:
            return "/api/Order/GetDetail"
        case .getStaffSchedule:
            return "/api/staff/GetStaffSchedule"
        case .getNotificationList:
            return "/api/Notification/GetNotifications"
        case .getListOrderToday:
            let url = URLConstant.qrUrl.components(separatedBy: "?")
            return url[0].replacingOccurrences(of: URLConstant.baseURL, with: "")
        case .checkInCheckoutOrderQRCode:
            return "/api/Order/CheckInCheckOutOrder"
        case .confirmOrRejectOrder:
            return "/api/Order/ConfirmRejectOrder"
        case .updateNotificationStatus:
            return "/api/Notification/Update"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .register, .createOrder, .getStaffSchedule, .checkInCheckoutOrderQRCode, .confirmOrRejectOrder:
            return .post
        case .getStoreByGPS, .getCategoriesByStore, .getListOrderToday, .getNotificationList, .getOrderDetail, .updateNotificationStatus:
            return .get
        }
    }

    var parameters: [String : Any]? {

        switch self {

        case .login(let phone, let password, let token):
            let user = ["name": "", "phoneNumber": phone, "password": password, "deviceToken": token]
            return ["customer": user,
                    "isRegister": false]
        case .register(let name, let phone, let password, let token):
            let user = ["name": name, "phoneNumber": phone, "password": password, "deviceToken": token]
            return ["customer": user,
                    "isRegister": true]
        case .getStoreByGPS(let lat, let long):
            var params: [String : AnyObject] = [:]
            params["longitude"] = long as AnyObject?
            params["latitude"] = lat as AnyObject?
            return params
        case .getCategoriesByStore(let storeId):
            return ["storeId": storeId]
        case .getStaffSchedule(let date, let time, let storeId, let productList):
            return ["date": date as Any,
                    "store": storeId as Any,
                    "services": productList as Any,
                    "time": time as Any]
        case .createOrder(let customerId, let storeId, let amount, let bookedDate, let status, let note, let customerName, let customerPhone, let timer, let productList, let staff, let payment):
            // Get Product data
            var orderDetail: [[String:Any]] = []
            for item in productList {
                var orderItem: [String: Any] = [:]
                orderItem["productId"] = item.productId as Any
                orderItem["price"] = item.price as Any
                orderItem["total"] = item.price*1 as Any
                orderDetail.append(orderItem)
            }

            return ["userId": customerId,
                    "storeId": storeId,
                    "totalAmount": amount,
                    "bookingDate": bookedDate,
                    "status": status,
                    "note": note,
                    "paymentMethod": payment.type.rawValue,
                    "customerNameOrder": customerName,
                    "phoneNumberOrder": customerPhone,
                    "pickupTime": timer,
                    "staffId": staff.staffId,
                    "orderDetails": orderDetail]

        case .getOrderDetail(let orderId):
            return ["orderId": orderId as Any]
        case .getListOrderToday(let customerId):
            var params: [String: Any] = [:]
            params["userId"] = customerId as Any
            return params

        case .checkInCheckoutOrderQRCode(let orderList):
            var param: [String:Any] = [:]
            var orderListParam = [[String: Any]]()
            for order in orderList {
                var orderParams: [String:Any] = [:]
                orderParams["id"] = order.orderId as Any
                orderParams["userId"] = order.customerId as Any
                orderParams["storeId"] = order.storeId as Any
                orderParams["status"] = order.status as Any
                orderParams["bookingDate"] = order.bookingDate as Any
                orderParams["pickupTime"] = order.timePickup as Any
                orderParams["totalAmount"] = order.totalPrice as Any

                orderListParam.append(orderParams)
            }

            param["orders"] = orderListParam

            return param

        case .getNotificationList(let customerId):
            return ["userId": customerId as Any]

        case .confirmOrRejectOrder(let notificationItem, let customerId, let action):
            let params = ["notificationId": notificationItem.notificationId as Any,
                          "userId": customerId,
                          "orderId": notificationItem.orderId as Any,
                          "Action": action as Any]
            return params
        case .updateNotificationStatus(let customerId, let notificationId):
            return ["notificationId": notificationId, "userId": customerId]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login, .register, .createOrder, .getStaffSchedule, .checkInCheckoutOrderQRCode, .confirmOrRejectOrder:
            return JSONEncoding.default
        case .getStoreByGPS, .getCategoriesByStore, .getListOrderToday, .getNotificationList, .getOrderDetail, .updateNotificationStatus:
            return URLEncoding.default
        }
    }

    var sampleData: Data {
        switch self {
        case .login, .register:
            return "{\"status\": 200,\"message\": \"Success\", \"customerInfor\": {\"Id\": 5,\"Name\":\"Anh Tran\",\"PhoneNumber\": \"1234567890\"}}".data(using: .utf8)!
        case .getStoreByGPS:
            return "{\"items\": [{\"id\": 1,\"name\": \"Crazy Nails\",\"address\": \"242 Bank Street Ottawa\",\"latitude\": 38.895546,\"longtitude\": -77.037842,\"image\": \"/Content/images/Stores/Store_20172228112226.jpg\",\"isActive\": true,\"owners\": []}]}".data(using: .utf8)!
        case .getCategoriesByStore:
            return "{\"message\":\"success\",\"data\":[{\"Name\":\"Nails and Spa\",\"CreatedDate\":\"2017-06-28T11:24:11.953\",\"UpdatedDate\": \"2017-06-28T11:24:11.953\",\"IsActive\": true,\"Description\": \"Nails and Spa\",\"Products\": [{\"CategoryId\": 16,\"Name\": \"Eyebrow Wax Clean Up\",\"Image\": \"null\",\"Description\": \"\",\"Price\": 100,\"Time\": \"10:0\",\"IsActive\": true,\"TimeHour\": 0,\"TimeMinute\": 0,\"Staffs\": [{\"Name\": \"Staff 01\",\"Surname\": \"ss\",\"UserName\": \"Staff\",\"FullName\":\"Staff 01 ss\",\"EmailAddress\": \"Staff01@gmail.com\",\"IsEmailConfirmed\": false,\"LastLoginTime\": null,\"IsActive\": true,\"CreationTime\":\"2017-06-28T16:20:17.537\",\"Id\": 10012}],\"Id\": 1024}],\"Id\": 16}],\"status\": 200}".data(using: .utf8)!
        case .createOrder:
            return "".data(using: .utf8)!
        case .getStaffSchedule:
            return "".data(using: .utf8)!
        case .getListOrderToday:
            return "".data(using: .utf8)!
        default:
            return "".data(using: .utf8)!
        }
    }

    var task: Task {
        switch self {

        default:
            return .request
        }
    }
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
