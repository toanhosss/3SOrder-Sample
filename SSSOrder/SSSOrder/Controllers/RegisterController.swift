//
//  RegisterController.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/28/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

class RegisterController: NSObject {
    // create instance
    static let SharedInstance: RegisterController = {
        var controller = RegisterController()
        return controller
    }()

    let provider = MoyaProvider<APIService>()

    func register(name: String?, phone: String?, password: String?, confirmPassword: String?, callback: @escaping (_ user: User?, _ error: String?) -> Void) {
        guard (name != nil) && (name! != ""),
            (phone != nil) && (phone! != ""),
            (password != nil) && (password! != ""),
            (confirmPassword != nil) && (confirmPassword! != "")
            else {
                let error = "Name or phone or password cannot be empty"
                callback(nil, error)
                return
        }

        if confirmPassword != password {
            let error = "Confirm password and password not matched."
            callback(nil, error)
            return
        }

        let nameParam = phone!
        let phoneParam = phone!
        let passwordParam = password!

        self.provider.request(.register(name: nameParam, phone: phoneParam, password: passwordParam)) { (result) in
            switch result {
            case .success(let moyaResponse):
                do {
                    let data = try moyaResponse.mapJSON() as? [String:Any]
                    let status = data!["status"] as? Int
                    if status! == 200 {
                        let userData = data!["customerInfo"] as? [String:Any]
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
