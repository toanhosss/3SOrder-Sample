//
//  User.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/27/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation

fileprivate enum UserKey {
    static let idKey = "_user_id"
    static let nameKey = "_user_name"
    static let phoneKey = "_user_phone"
    static let emailKey = "_user_email"
    static let avatarKey = "_user_avatar"
}

class User: NSObject, NSCoding {

    var userId: Int
    var name: String
    var phone: String
    var email: String = ""
    var avatar: String?

    init(userId: Int, name: String, phone: String) {
        self.userId = userId
        self.name = name
        self.phone = phone
    }

    init(userId: Int, name: String, phone: String, email: String, avatar: String) {
        self.userId = userId
        self.name = name
        self.phone = phone
        self.email = email
        self.avatar = avatar
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: UserKey.idKey) as? Int,
            let name = aDecoder.decodeObject(forKey: UserKey.nameKey) as? String,
            let phone = aDecoder.decodeObject(forKey: UserKey.phoneKey) as? String
            else {
                return nil
        }

        let email = aDecoder.decodeObject(forKey: UserKey.emailKey) as? String
        let avatar = aDecoder.decodeObject(forKey: UserKey.avatarKey) as? String

        self.init(userId: id, name: name, phone: phone)
        self.email = email != nil ? email!:""
        self.avatar = avatar
    }

    func encode(with aCoder: NSCoder) {

        aCoder.encode(self.userId, forKey: UserKey.idKey)
        aCoder.encode(self.name, forKey: UserKey.nameKey)
        aCoder.encode(self.phone, forKey: UserKey.phoneKey)
        aCoder.encode(self.email, forKey: UserKey.emailKey)
        aCoder.encode(self.avatar, forKey: UserKey.avatarKey)
    }
}
