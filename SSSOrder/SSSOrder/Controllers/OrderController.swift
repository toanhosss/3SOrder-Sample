//
//  OrderController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/28/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import Moya

class OrderController: NSObject {
    // create instance
    static let SharedInstance: OrderController = {
        var controller = OrderController()
        return controller
    }()

    let provider = MoyaProvider<APIService>()

//    func createOrder(nameCustomer: String?, note: String?, phoneNumber: String?, bookingDate: Date?,
//                     timePickup: String?, storeId: Int, productList: [SalonProductModel], staffSelected: StaffModel,
    func createOrder(order: OrderModel, paymentMethod: PaymentModel, callback: @escaping (_ status: Bool, _ error: String?) -> Void) {

        guard let dateBooked = order.getDatefromBookingDate() else {
            callback(false, "FormatDate Invalid")
            return
        }

//        let timeBooked = DateUtil.convertDateTimeFromStringWithFormatInputOutput(with: order.timePickup, input: "hh:mm a", output: "HH:mm")

        let timeBooked = order.timePickup

        let user = UserDefaultUtils.getUser()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: dateBooked)

        var sum:Double = 0
        for item in order.productList {
            sum += item.price
        }

        self.provider.request(.createOrder(customerId: user!.userId, storeId: order.storeId, amount: sum, bookedDate: dateString, status: "New", note: order.note, customerName: user!.name, customerPhone: user!.phone, timer: timeBooked, productList: order.productList, staff: order.staff != nil ? order.staff!:StaffModel(staffId: -1, name: "", avatar: ""), payment: paymentMethod)) { (result) in
            switch result {
            case .success(let response):
                do {
                    _ = try response.mapJSON() as? [String:Any]
//                    print(data!["message"])
                    callback(true, nil)
                } catch {
                    let error = "Cannot map data"
                    callback(false, error)
                }
            case .failure(let error):
                let errorString = error.errorDescription
                callback(false, errorString)
            }
        }
    }

    /// Get calendar from current day
    func getSchedulerData() -> [MyCalendarObject] {
        var listItem: [MyCalendarObject] = []

        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())

        for i in -3 ... 14 {
            let dateFormat = DateFormatter()
            let dateFormat2 = DateFormatter()
            dateFormat.dateFormat = "E,dd"
            dateFormat2.dateFormat = "EEEE, MMMM dd, yyyy"

            let expectedDate = cal.date(byAdding: .day, value: i, to: date)!
            let calendarItem = MyCalendarObject(date: dateFormat.string(from: expectedDate), dateFull: dateFormat2.string(from: expectedDate), dateData: expectedDate)
            if i < 0 {
                calendarItem.canSelected = false
            }
            listItem.append(calendarItem)
        }

        return listItem
    }

    func getFreeTimeOfStoreOnDate(storeId: Int, on date: Date, callback: @escaping (_ listTime: [String],_ error: String?) -> Void) {
        callback(["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00"], nil)
    }

    /// Get FreeTime Of Staff list
    func getFreeTimeOfStaff(date: Date, storeId: Int, listSerVice: [SalonProductModel], callback: @escaping (_ staffList: [StaffModel], _ error: String?) -> Void) {
        // TODO: call API get free time data
        var listServiceId = [Int]()
        for service in listSerVice {
            listServiceId.append(service.productId)
        }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"

        self.provider.request(.getStaffSchedule(date: dateFormat.string(from: date), storeId: storeId, productListId: listServiceId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try response.mapJSON() as? [[String: Any]]
                    let data = json![0]
                    guard let date = data["date"] as? String,
                        let staffData = data["staffs"] as? [[String:Any]] else {
                            callback([], "Cannot map Data Staff")
                            return
                    }
                    print("Date was booked: \(date)")

                    let staffList = self.migrateDataStaff(data: staffData)
                    if staffList != nil {
                        callback(staffList!, nil)
                    } else {
                        callback([], "Cannot map Data Staff")
                    }

                } catch {
                    let error = "Cannot map data"
                    callback([], error)
                }
            case .failure(let error):
                let errorString = error.errorDescription
                callback([], errorString)
            }
        }
//        return ["9:00 AM","9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
//        "12:00 PM","12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM"]
    }

    private func migrateDataStaff(data:[[String:Any]]) -> [StaffModel]? {
        var staffList: [StaffModel] = []
        for itemData in data {
            guard let staffID = itemData["staffID"] as? Int,
                let profileImage = itemData["profileImageUrl"] as? String,
                let name = itemData["name"] as? String,
                let rating = itemData["rating"] as? Float,
                let amTime = itemData["availableTimeMorning"] as? [String],
                let pmTime = itemData["availableTimeAfternoon"] as? [String]
            else {
                return nil
            }
            let staff = StaffModel(staffId: staffID, name: name, avatar: profileImage)
            staff.ratingStar = rating
            staff.amTime = convertFormatTimeDate(listTime: amTime)
            staff.pmTime = convertFormatTimeDate(listTime: pmTime)
            staffList.append(staff)
        }

        return staffList
    }

    func convertFormatTimeDate(listTime: [String]) -> [String] {
        var newTime = [String]()
        for item in listTime {
            let dateformat = DateFormatter()
            dateformat.dateFormat = "HH:mm:ss"
            let time = dateformat.date(from: item)
            let outputFormater = DateFormatter()
            outputFormater.dateFormat = "hh:mm a"

            newTime.append(outputFormater.string(from: time!))

        }

        return newTime
    }

    func checkInCheckoutOrder(listOrder: [OrderModel], callback: @escaping (_ listOrder: [OrderModel], _ error: String?) -> Void) {
        self.provider.request(.checkInCheckoutOrderQRCode(orderList: listOrder)) { (result) in
            switch result {
            case .success(let response):
                var listOrder = [OrderModel]()
                do {
                    let json = try response.mapJSON() as? [[String:Any]]
                    for item in json! {
                        let order = self.migrateOrderData(jsonData: item)
                        if order != nil {
                            listOrder.append(order!)
                        }
                    }
                    callback(listOrder, nil)
                } catch {
                    let error = "Cannot map data"
                    callback([], error)
                }
            case .failure(let error):
                let errorString = error.errorDescription
                callback([], errorString)
            }
        }
    }

    func getListOrderToday(callback: @escaping (_ staffList: [OrderModel], _ error: String?) -> Void) {
        let user = UserDefaultUtils.getUser()
        self.provider.request(.getListOrderToday(customerId: user!.userId)) { (result) in
            switch result {
            case .success(let response):
                var listOrder = [OrderModel]()
                do {
                    let json = try response.mapJSON() as? [[String:Any]]
                    for item in json! {
                        let order = self.migrateOrderData(jsonData: item)
                        if order != nil {
                            listOrder.append(order!)
                        }
                    }
                    callback(listOrder, nil)
                } catch {
                    let error = "Cannot map data"
                    callback([], error)
                }
            case .failure(let error):
                let errorString = error.errorDescription
                callback([], errorString)
            }
        }
    }

    func migrateOrderData(jsonData: [String:Any]) -> OrderModel? {
        guard let storeId = jsonData["storeId"] as? Int,
            let customerId = jsonData["customerId"] as? Int,
            let status = jsonData["status"] as? String,
            let bookingDate = jsonData["bookingDate"] as? String,
            let totalPrice = jsonData["totalAmount"] as? Double,
            let bookingTime = jsonData["pickupTime"] as? String,
            let orderId = jsonData["id"] as? Int else {
            return nil
        }

        let order = OrderModel(orderId: orderId, storeId: storeId, customerId: customerId, status: status, note: "", bookingDate: bookingDate, timePickup: bookingTime, productList: [])
        order.totalPrice = totalPrice

        return  order
    }
}
