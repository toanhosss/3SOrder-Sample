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
    var amTime: [String] = []
    var pmTime: [String] = []

    init(staffId: Int, name: String, avatar: String) {
        self.staffId = staffId
        self.name = name
        self.avatar = avatar
    }

    func getFreeTime(time: [String]) {
        for item in time {
            if item.contains("AM") {
                amTime.append(item)
            } else {
                pmTime.append(item)
            }
        }
    }
}
