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

    func createOrder(order: OrderModel, paymentMethod: PaymentModel, callback: @escaping (_ status: Bool, _ orderId: Int?, _ error: String?) -> Void) {

        guard let dateBooked = order.getDatefromBookingDate() else {
            callback(false, nil, "FormatDate Invalid")
            return
        }

//        let timeBooked = DateUtil.convertDateTimeFromStringWithFormatInputOutput(with: order.timePickup, input: "hh:mm a", output: "HH:mm")

        let timeBooked = DateUtil.getcurrentTimeStamp(with: order.timePickup, input: "HH:mm")

        let user = UserDefaultUtils.getUser()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: dateBooked)

        var sum:Double = 0
        for item in order.productList {
            sum += item.price
        }

        self.provider.request(.createOrder(customerId: user!.userId, storeId: order.storeId, amount: sum, bookedDate: dateString, status: "New", note: order.note, customerName: user!.name, customerPhone: user!.phone, timer: timeBooked!, productList: order.productList, staff: order.staff != nil ? order.staff!:StaffModel(staffId: -1, name: "", avatar: ""), payment: paymentMethod)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try response.mapJSON() as? [String:Any]
                    guard let order = json!["order"] as? [String:Any] else {
                        let error = "Cannot map data"
                        callback(false, nil, error)
                        return
                    }

                    let id = order["id"] as? Int

                    callback(true, id!, nil)
                } catch {
                    let error = "Cannot map data"
                    callback(false, nil, error)
                }
            case .failure(let error):
                let errorString = error.errorDescription
                callback(false, nil, errorString)
            }
        }
    }

    /// Get order detail
    func getOrderDetail(orderId: Int, callback: @escaping (_ order: [String:Any]?, _ error: String?) -> Void) {

        self.provider.request(.getOrderDetail(orderId: orderId)) { (result) in
            switch result {
            case .failure(let error):
                let errorString = error.errorDescription
                callback(nil, errorString)
            case .success(let response):
                do {
                    let json = try response.mapJSON() as? [String:Any]
                    callback(json, nil)

                } catch {
                    let error = "Cannot map data"
                    callback(nil, error)
                }
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
        let timeList = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00"]

        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        dateFormat.timeZone = TimeZone(identifier: "GMT")
        if let current = dateFormat.date(from: date.format(with: DateFormatter.Style.full)) {
            if DateUtil.calicuateDaysBetweenTwoDates(start: current, end: currentDate) < 0 {
                callback(timeList, nil)
                return
            }
        }

        var timeAvailable = [String]()
        for i in 0..<timeList.count {
            let time = timeList[i]
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            if let bookingTime = format.date(from: time) {
                if bookingTime.hour > currentDate.hour {
                    timeAvailable.append(time)
                }

                if bookingTime.hour == currentDate.hour && bookingTime.minute > currentDate.minute  {
                    timeAvailable.append(time)
                }
            }
            
        }

        callback(timeAvailable, nil)
    }

    /// Get FreeTime Of Staff list
    func getFreeTimeOfStaff(date: Date, time: String, storeId: Int, listSerVice: [SalonProductModel], callback: @escaping (_ staffList: [StaffModel], _ error: String?) -> Void) {
        // TODO: call API get free time data
        var listServiceId = [Int]()
        for service in listSerVice {
            listServiceId.append(service.productId)
        }
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: "GMT")
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let timeBooked = DateUtil.getcurrentTimeStamp(with: time, input: "HH:mm")
//        let timeBooked = DateUtil.convertDateTimeFromStringWithFormatInputOutput(with: time, input: "HH:mm", output: "HH:mm:ss")

        self.provider.request(.getStaffSchedule(date: dateFormat.string(from: date), time: timeBooked!, storeId: storeId, productListId: listServiceId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON() as? [String: Any]
                    guard let date = data!["date"] as? String,
                        let staffData = data!["staffs"] as? [[String:Any]] else {
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

    private func migrateDataStaff(data: [[String:Any]]) -> [StaffModel]? {
        var staffList: [StaffModel] = []
        for itemData in data {
            guard let staffID = itemData["staffId"] as? Int,
                let profileImage = itemData["profileImageUrl"] as? String,
                let name = itemData["name"] as? String,
                let rating = itemData["rating"] as? Float
            else {
                return nil
            }
            let staff = StaffModel(staffId: staffID, name: name, avatar: profileImage)
            staff.ratingStar = rating
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
            let customerId = jsonData["userId"] as? Int,
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
