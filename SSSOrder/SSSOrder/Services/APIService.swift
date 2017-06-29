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
    case login(phone: String, password: String)
    case register(name: String, phone: String, password: String)
    case getStoreByGPS(lat: String, long: String)
    case getCategoriesByStore(storeId: Int)
    case createOrder(customerId: Int, storeId: Int, amount: Double, bookedDate: String, status: String,  note: String, customerName: String, customerPhone: String, timer: String, productList: [SalonProductModel], staff: StaffModel, payment: PaymentModel)
}

// MARK: - TargetType Protocol Implementation
extension APIService: TargetType {
    /// The target's base `URL`.
    public var baseURL: URL {
        return URL(string: "http://192.168.2.65:8889")!
    }

    var path: String {
        switch self {
        case .login, .register:
            return "/api/UserMobile/LoginOrRegister"
        case .getStoreByGPS:
            return "/api/Store/GetStoreByGPS"
        case .getCategoriesByStore:
            return "/api/Category/GetCategories"
        case .createOrder:
            return "/api/Order/CreateOrder"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .register, .createOrder:
            return .post
        case .getStoreByGPS, .getCategoriesByStore:
            return .get
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .login(let phone, let password):
            let user = ["Name": "", "PhoneNumber": phone, "Password": password]
            return ["customer": user,
                    "IsRegister": false]
        case .register(let name, let phone, let password):
            let user = ["Name": name, "PhoneNumber": phone, "Password": password]
            return ["customer": user,
                    "IsRegister": true]
        case .getStoreByGPS(let lat, let long):
            var params: [String : AnyObject] = [:]
            params["longitude"] = long as AnyObject?
            params["latitude"] = lat as AnyObject?
            return params
        case .getCategoriesByStore(let storeId):
            return ["storeId": storeId]
        case .createOrder(let customerId, let storeId, let amount, let bookedDate, let status, let note, let customerName, let customerPhone, let timer, let productList, let staff, let payment):
            // Get Product data
            var orderDetail: [[String:Any]] = []
            for item in productList {
                var orderItem: [String: Any] = [:]
                orderItem["productId"] = item.productId as Any
                orderItem["staffId"] = staff.staffId as Any
                orderItem["price"] = item.price as Any
                orderItem["total"] = 0
                orderDetail.append(orderItem)
            }
            var params = ["customerId": customerId,
                          "storeId": storeId,
                          "totalAmount": amount,
                          "bookingDate": bookedDate,
                          "status": status,
                          "note": note,
                          "paymentMethod": payment.type.rawValue,
                          "customerNameOrder": customerName,
                          "phoneNumberOrder": customerPhone,
                          "pickupTime": timer,
                          "orderDetails": orderDetail ] as [String : Any]

                return ["customerId": customerId,
                "storeId": storeId,
                "totalAmount": amount,
                "bookingDate": bookedDate,
                "status": status,
                "note": note,
                "paymentMethod": payment.type.rawValue,
                "customerNameOrder": customerName,
                "phoneNumberOrder": customerPhone,
                "pickupTime": timer,
                "orderDetails": orderDetail ]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login, .register, .createOrder:
            return JSONEncoding.default
        case .getStoreByGPS, .getCategoriesByStore:
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
        }
    }

    var task: Task {
        switch self {

        default:
            return .request
        }
    }
}
