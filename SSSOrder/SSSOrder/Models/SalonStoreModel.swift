//
//  SalonStoreModel.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation

class SalonStoreModel: NSObject {
    var name: String!
    var address: String!
    var image: String!
    var descriptionText: String!
    var distance: Float!

    init(name: String, address: String, distance: Float, image: String, description: String) {

        super.init()
        self.name = name
        self.address = address
        self.distance = distance
        self.image = image
        self.descriptionText = description
    }

    func getDataCategories() -> [String] {

        return ["MANICURES & PEDICURES", "EYEBROW BAR", "FACIAL WAXING", "FACIAL CARE"]
    }

    func getProductListByStore(index: Int) -> [SalonProductModel] {
        switch index {
        case 1:
            return [
                SalonProductModel(name: "Eyebrow Wax", image: "https://previews.123rf.com/images/sergeyp/sergeyp1503/sergeyp150300017/37028670-Closeup-shot-of-female-closed-eye-and-brows-with-day-makeup-Stock-Photo.jpg", price: 22, duration: 40, description: ""),
                SalonProductModel(name: "Eyebrow & Upper Lip", image: "http://www.rosebeautysalon-mcr.com/images/threading-pic.jpg", price: 30, duration: 40, description: ""),
                SalonProductModel(name: "Eyebrow/Upper Lip/Chin", image: "https://i2.wp.com/www.zingalalaa.com/wp-content/uploads/2017/02/Eyebrow-shaping-tips.jpg?resize=800%2C350", price: 35, duration: 40, description: ""),
                SalonProductModel(name: "Eyebrow Tinting", image: "http://www.pureblissbcs.com/wp-content/uploads/sites/30/2016/01/scottsdale-eyebrow-tinting-1.jpg", price: 15, duration: 40, description: "")
            ]
        case 2:
            return [
                SalonProductModel(name: "Side of Face or Neck", image: "https://image.shutterstock.com/z/stock-photo-young-woman-getting-neck-massage-in-spa-center-489755176.jpg", price: 10, duration: 40, description: ""),
                SalonProductModel(name: "Upper Lip/ Chin", image: "", price: 15, duration: 40, description: ""),
                SalonProductModel(name: "Upper Lip", image: "", price: 10, duration: 40, description: ""),
                SalonProductModel(name: "Upper Lip/ Chin/ Side of Face", image: "", price: 25, duration: 40, description: "")
            ]
        case 3:
            return [
                SalonProductModel(name: "Skin Bar Facial 30 minutes", image: "", price: 35, duration: 30, description: "cost of service may be used towards same day product purchase"),
                SalonProductModel(name: "Skin Deep Facial", image: "", price: 100, duration: 50, description: ""),
                SalonProductModel(name: "Moisture Drench Facial", image: "", price: 125, duration: 40, description: ""),
                SalonProductModel(name: "Energy Lift Facial", image: "", price: 125, duration: 50, description: "")
            ]
        default:
            return [
                SalonProductModel(name: "Manicure", image: "https://cdn.spafinder.com/2015/10/manicure.jpg",
                                  price: 28, duration: 40, description: ""),
                SalonProductModel(name: "French Polish Manicure", image: "https://s-media-cache-ak0.pinimg.com/736x/57/c0/dc/57c0dc8e2f5efeef136e7655063c5db7--french-manicure-ombre-american-french-manicure.jpg",
                                  price: 38, duration: 40, description: ""),
                SalonProductModel(name: "Polish Change", image: "https://nebula.wsimg.com/obj/MDhFRTQwN0ZBRUNCMENFMkMxRjE6OTYyMjZjZmViMWIzMTdlNWMxMTg0ZTJlYWU1MGEzZTk6Ojo6OjA=",
                                  price: 15, duration: 40, description: ""),
                SalonProductModel(name: "French Polish Change", image: "https://www.thepronails.com/public/uploads/service/french-polish-change-on-hands-74768107.jpg",
                                  price: 25, duration: 40, description: "")
            ]
        }
    }

}
