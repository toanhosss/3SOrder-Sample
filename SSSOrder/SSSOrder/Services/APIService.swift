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
        case .getStoreByGPS(let lat, let long):
            return "/api/Store/GetStoreByGPS?longitude=\(lat)&latitude=\(long)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
        case .getStoreByGPS:
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
        default:
            return nil
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login, .register:
            return JSONEncoding.default
        case .getStoreByGPS:
            return URLEncoding.default
        }
    }

    var sampleData: Data {
        switch self {
        case .login:
            return "{\"status\": 200,\"message\": \"Success\", \"customerInfor\": {\"Id\": 5,\"Name\":\"Anh Tran\",\"PhoneNumber\": \"1234567890\"}}".data(using: .utf8)!
        case .register:
            return "".data(using: .utf8)!
        case .getStoreByGPS:
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
