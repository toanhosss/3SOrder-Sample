//
//  NotificationItemViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/26/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class NotificationItemViewController: BaseController {

    var data: NotificationModel!

    let rowHeight = ScreenSize.ScreenHeight*0.05
    let left = ScreenSize.ScreenWidth*0.1

    override func setLayoutPage() {
        super.setLayoutPage()

        if let title = data.orderId {
            self.titlePage = "Order #\(title)"
        }

        self.backTitle = NSLocalizedString("back", comment: "")

        getDataDetail()
    }

    func getDataDetail() {
        DispatchQueue.main.async {
            OrderController.SharedInstance.getOrderDetail(orderId: self.data.orderId!, callback: { (orderData, error) in
                if error != nil {
                    self.showErrorMessage(error!)
                    _ = self.navigationController?.popViewController(animated: true)
                    return
                }

                if let data = orderData {

                    guard let totalPrice = data["total"] as? Double,
                        let time = data["pickupTime"] as? String,
                        let staff = data["staffName"] as? String,
                        let orderDetail = data["orderDetails"] as? [[String: Any]],
                        let bookingDate = data["bookingDate"] as? String else {
                            self.showErrorMessage("Can't map data")
                            _ = self.navigationController?.popViewController(animated: true)
                            return
                    }

                    self.createOrderDetailView(price: totalPrice, date: bookingDate, time: time, staffName: staff, order: orderDetail)
                }
            })
        }
    }

    func createOrderDetailView(price: Double, date: String, time: String, staffName: String, order: [[String: Any]]) {
        // create Price title
        let priceLabel = UILabel(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.1))
        priceLabel.text = "$\(price)"
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.boldSystemFont(ofSize: 45)
        priceLabel.textColor = ColorConstant.TextColorHighlight

        // Create Basic Info
        addBookingLabel(dateBooking: date, time: time)
        addStaffLabel(staffName: staffName)

        // Create Service
        addListService(orderDetail: order)

        self.view.addSubview(priceLabel)
    }

    func addBookingLabel(dateBooking: String, time: String) {

        let generalInfo = UIView(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.22, width: ScreenSize.ScreenWidth*0.8, height: rowHeight))
        let dateBookIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: rowHeight, height: rowHeight))
        dateBookIcon.image = ImageConstant.IconBooking?.withRenderingMode(.alwaysTemplate)
        dateBookIcon.tintColor = .black

        let dateBookedLabel = UILabel(frame: CGRect(x: left*1.1 + rowHeight*0.5, y: 0, width: generalInfo.frame.size.width - dateBookIcon.frame.maxX, height: generalInfo.frame.size.height))

        if let date = DateUtil.convertDateTimeFromStringWithFormatInputOutput(with: dateBooking, input: "yyyy-MM-dd'T'HH:mm:ss", output: "EEEE, MMMM dd yyyy") {
            dateBookedLabel.text = date + ", \(time)"
        } else {
            dateBookedLabel.text = dateBooking + ", \(time)"
        }
        dateBookedLabel.font = UIFont.boldSystemFont(ofSize: 16)

        generalInfo.addSubview(dateBookedLabel)
        generalInfo.addSubview(dateBookIcon)

        self.view.addSubview(generalInfo)
    }

    func addStaffLabel(staffName: String) {

        let generalInfo = UIView(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.32, width: ScreenSize.ScreenWidth*0.8, height: rowHeight))
        let dateStaffIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: rowHeight, height: rowHeight))
        dateStaffIcon.image = ImageConstant.IconUser?.withRenderingMode(.alwaysTemplate)
        dateStaffIcon.tintColor = .black

        let staffLabel = UILabel(frame: CGRect(x: left*1.1 + rowHeight*0.5, y: 0, width: generalInfo.frame.size.width - dateStaffIcon.frame.maxX, height: generalInfo.frame.size.height))
        staffLabel.text = staffName
        staffLabel.font = UIFont.boldSystemFont(ofSize: 16)

        generalInfo.addSubview(staffLabel)
        generalInfo.addSubview(dateStaffIcon)

        self.view.addSubview(generalInfo)
    }

    func addListService(orderDetail: [[String: Any]]) {

        let listProductView = UIScrollView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.42, width: ScreenSize.ScreenWidth*0.8, height: rowHeight*4))
        listProductView.contentSize = CGSize(width: ScreenSize.ScreenWidth*0.8, height: rowHeight*0.15*CGFloat(orderDetail.count))
        for i in 0..<orderDetail.count {
            listProductView.addSubview(loadItemService(productItem: orderDetail[i], index: CGFloat(i)))
        }
        self.view.addSubview(listProductView)
    }

    func loadItemService(productItem: [String: Any], index: CGFloat) -> UIView {
        guard let productName = productItem["productName"] as? String,
            let productPrice = productItem["price"] as? Double else {
                return UIView()
        }

        let itemHeight = rowHeight*0.8
        let itemWidth = ScreenSize.ScreenWidth*0.8
        let itemLeft = left*0.5

        let itemView = UIView(frame: CGRect(x: itemLeft, y: index*itemHeight, width: itemWidth*0.9, height: itemHeight))

        let serviceName = UILabel(frame: CGRect(x: itemLeft, y: 0, width: itemWidth*0.5, height: itemHeight))
        serviceName.text = productName
        serviceName.font = UIFont.boldSystemFont(ofSize: 16)

        let price = UILabel(frame: CGRect(x: itemWidth*0.55, y: 0, width: itemWidth*0.3, height: itemHeight))
        price.text = "$\(productPrice)"
        price.textAlignment = .center
        price.font = UIFont.systemFont(ofSize: 16)

        itemView.addSubview(serviceName)
        itemView.addSubview(price)
        return itemView
    }
}
