//
//  SalonProductModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
class SalonProductModel: NSObject {

    var image: String!
    var name: String!
    var price: Double = 0
    var duration: Int = 0
    var descriptionText: String = ""

    init(name: String, image: String, price: Double, duration: Int, description: String) {
        super.init()
        self.name = name
        self.image = image
        self.price = price
        self.duration = duration
        self.descriptionText = description
    }
}
