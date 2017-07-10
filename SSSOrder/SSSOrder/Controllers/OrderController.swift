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

        let dateBooked = order.getDatefromBookingDate()
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

    /// Get FreeTime Of Staff list
    func getFreeTimeOfStaff(date: Date) -> [String] {
        // TODO: call API get free time data
        return ["9:00 AM","9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
        "12:00 PM","12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM"]
    }
}
