//
//  ProductController.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/28/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

class ProductController: NSObject {
    // create instance
    static let SharedInstance: ProductController = {
        var controller = ProductController()
        return controller
    }()

    let provider = MoyaProvider<APIService>()

    func getData(storeId: Int,
                 callback: @escaping (_ categories: [(id: Int, name: String, product: [SalonProductModel])]?, _ error: String?) -> Void) {
        provider.request(.getCategoriesByStore(storeId: storeId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON() as? [String:Any]
                    let status = data!["status"] as? Int
                    if status != nil && status! == 200 {
                        let dataList = data!["data"] as? [String:Any]
                        let categoryList = dataList!["Categories"] as? [[String:Any]]
                        var category:[(id: Int, name: String, product: [SalonProductModel])] = []
                        for item in categoryList! {
                            let nameCategory = item["Name"] as? String
                            let idCategory = item["Id"] as? Int
                             let productList = self.dataToProductObject(data: item["Products"] as? [[String:Any]])
                            category.append((id: idCategory!, name: nameCategory!, product: productList != nil ? productList!:[]))

                        }

//                        let staffList = dataList!["Staffs"] as? [[String: Any]]
//                        var staffs: [StaffModel] = []
//                        for staff in staffList! {
//                            let staffId = staff["Id"] as? Int
//                            let staffName = staff["Name"] as? String
//                            let staffItem = StaffModel(staffId: staffId!, name: staffName!, avatar: "")
//                            staffs.append(staffItem)
//                        }

                        callback(category, nil)
                    } else {
                        let error = data!["message"] as? String
                        callback(nil, error!)
                    }
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

    private func dataToProductObject(data: [[String:Any]]?) -> [SalonProductModel]? {
        if data == nil {
            return nil
        }

        var result: [SalonProductModel] = []
        for item in data! {
            let categoryId = item["CategoryId"] as? Int
            let productName = item["Name"] as? String
            let imageProduct = item["Image"] as? String
            let description = item["Description"] as? String
            let price = item["Price"] as? Double
            let time = item["Time"] as? String
            let duration = getTimeDuration(timeString: time)
            let productId = item["Id"] as? Int
            let productObject = SalonProductModel(productId: productId!, name: productName!, image: imageProduct!, price: price!, duration: duration, categoryId: categoryId!, description: description!)
            let staff = getStaffList(data: item["Staffs"] as? [[String:Any]])
            productObject.staffAvailable = staff != nil ? staff! : []
            result.append(productObject)
        }

        return result
    }

    private func getTimeDuration(timeString: String?) -> String {
        guard let time = timeString else {
            return ""
        }

        let timeArray = time.components(separatedBy: ":")
        var timeHour = ""
        var timeMinute = ""
        if timeArray[0] != "00" {
            timeHour = "\(timeArray[0])h"
        }
        if timeArray[1] != "00" {
            timeMinute = "\(timeArray[1])m"
        }

        return "\(timeHour) \(timeMinute)"
    }

    private func getStaffList(data: [[String: Any]]?) -> [StaffModel]? {
        if data == nil {
            return nil
        }
        var staffList: [StaffModel] = []

        for item in data! {
            let name = item["Name"] as? String
            let staffId = item["Id"] as? Int
            let staff = StaffModel(staffId: staffId!, name: name!, avatar: "")
            staffList.append(staff)
        }

        return staffList
    }
}
