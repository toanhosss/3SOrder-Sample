//
//  UserDefault.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/27/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
final class UserDefaultUtils {
    static let userKey = "_user"
    static let deviceKey = "_device_token_key"

    /// Store user to local
    static func storeUser(user: User) {
        let userDefault = UserDefaults.standard
        let endcode = NSKeyedArchiver.archivedData(withRootObject: user)

        userDefault.removeObject(forKey: userKey)
        userDefault.set(endcode, forKey: userKey)
    }

    /// Get user from local
    static func getUser() -> User? {
        let decoder = UserDefaults.standard.object(forKey: userKey) as? NSData
        if decoder == nil {
            return nil
        }
        let user = NSKeyedUnarchiver.unarchiveObject(with: decoder! as Data) as? User
        return user != nil ? user : nil
    }

    /// Remove user from local
    static func removeUser() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: userKey)
    }

    /// set key device token
    static func storeDeviceToken(deviceToken: String) {
        let userDefault = UserDefaults.standard

        userDefault.removeObject(forKey: deviceKey)
        userDefault.set( deviceToken, forKey: deviceKey)
    }

    /// get key device token
    static func getDeviceToken() -> String? {
        return UserDefaults.standard.string(forKey: deviceKey)
    }
}
