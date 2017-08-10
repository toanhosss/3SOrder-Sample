//
//  SalonStoreModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation

class SalonStoreModel: NSObject {

    var salonId: Int!
    var name: String!
    var address: String!
    var phoneNumber: String?
    var image: String!
    var descriptionText: String = ""
    var distance: Float!
    var latitude: Float!
    var longitude: Float!

    init(salonId: Int, name: String, address: String, description: String, distance: Float, image: String, latitude: Float, longitude: Float) {

        super.init()
        self.salonId = salonId
        self.name = name
        self.address = address
        self.descriptionText = description
        self.distance = distance
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }

    func getDataCategories() -> [String] {

        return ["MANICURES & PEDICURES", "EYEBROW BAR", "FACIAL WAXING", "FACIAL CARE"]
    }

}
