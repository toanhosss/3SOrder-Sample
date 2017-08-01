//
//  SalonProductModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
class SalonProductModel: NSObject {

    var categoryId: Int!
    var productId: Int!
    var image: String!
    var name: String!
    var price: Double = 0
    var duration: String!
    var descriptionText: String = ""
    var staffAvailable: [StaffModel] = []

    init(productId: Int, name: String, image: String, price: Double, duration: String, categoryId: Int, description: String) {
        super.init()
        self.productId = productId
        self.name = name
        self.image = image
        self.categoryId = categoryId
        self.price = price
        self.duration = duration
        self.descriptionText = description
    }

    
}
