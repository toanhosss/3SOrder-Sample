//
//  LoginController.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/28/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

class LoginController: NSObject {
    // create instance
    static let SharedInstance: LoginController = {
        var controller = LoginController()
        return controller
    }()

    let provider = MoyaProvider<APIService>()

    func login(phone: String?, password: String?, callback: @escaping (_ user: User?, _ error: String?) -> Void) {
        guard (phone != nil) && (phone! != ""),
            (password != nil) && (password! != "")
        else {
            let error = "Phone or password cannot be empty"
            callback(nil, error)
            return
        }

        let phoneParam = phone!
        let passwordParam = password!

        self.provider.request(.login(phone: phoneParam, password: passwordParam)) { (result) in
            switch result {
            case .success(let moyaResponse):
                do {
                    let data = try moyaResponse.mapJSON() as? [String:Any]
                    let status = data!["status"] as? Int
                    if status! == 200 {
                        let userData = data!["customerInfor"] as? [String:Any]
                        let user = User(userId: (userData!["Id"] as? Int)!, name: (userData!["Name"] as? String)!, phone: (userData!["PhoneNumber"] as? String)!)
                        UserDefaultUtils.storeUser(user: user)
                        callback(user, nil)

                    } else {
                        let error = data!["message"] as? String
                        callback(nil, error!)
                    }

                } catch {
                    let error = "Cannot map data"
                    callback(nil, error)
                }

            case .failure(let error):
                let errorString = error.errorDescription
                callback(nil, errorString)
            }
        }
    }
}
