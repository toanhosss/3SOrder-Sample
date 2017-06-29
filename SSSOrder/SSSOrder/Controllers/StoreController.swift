//
//  HomeController.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/28/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

class StoreController: NSObject {
    // create instance
    static let SharedInstance: StoreController = {
        var controller = StoreController()
        return controller
    }()

    let provider = MoyaProvider<APIService>()

    func getStore(lat: String?, long: String?, callback: @escaping (_ store: [SalonStoreModel]?, _ error: String?) -> Void) {

        guard let latitude = lat,
            let longitude = long
        else {
            let error = "Can't get current your device location"
            callback(nil, error)
            return
        }

        provider.request(.getStoreByGPS(lat: latitude, long: longitude)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON() as? [String:Any]
                    let items = data!["data"] as? [[String:Any]]
                    var list: [SalonStoreModel] = []
                    for item in items! {
                        guard let id = item["Id"] as? Int,
                            let name = item["Name"] as? String,
                            let address = item["Address"] as? String,
                            let latP = item["Latitude"] as? Float,
                            let longP = item["Longtitude"] as? Float,
                            let image = item["Image"] as? String,
                            let distance = item["Distance"] as? Float
//                            let isActive = item["IsActive"] as? Bool,
//                            let owners = item["Owners"] as? [[String:Any]]
                            else {
                                break
                            }
                        let salon = SalonStoreModel(salonId: id, name: name, address: address, distance: distance, image: URLConstant.baseURL+image, latitude: latP, longitude: longP)
                        list.append(salon)
                    }
                    callback(list, nil)
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
