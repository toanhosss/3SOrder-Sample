//
//  StaffModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation

class StaffModel: NSObject {
    var name: String!
    var avatar: String!

    init(name: String, avatar: String) {
        self.name = name
        self.avatar = avatar
    }
}
