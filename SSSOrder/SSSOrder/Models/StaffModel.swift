//
//  StaffModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation

class StaffModel: NSObject {
    var staffId: Int!
    var name: String!
    var ratingStar: Float = 0.0
    var avatar: String!

    init(staffId: Int, name: String, avatar: String) {
        self.staffId = staffId
        self.name = name
        self.avatar = avatar
    }

}
