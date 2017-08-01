//
//  OrderConfirmDetailViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 7/30/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

protocol OrderConfirmDetailDelegate: class {
    func closePopup(popup: UIView)
}

class OrderConfirmDetailViewController: BaseController {

    var popupView: UIView!

    var isPopup: Bool = true
    var titleName: String = ""
    var serviceList = [SalonProductModel]()
    var staffName = ""
    var dateBook: Date = Date()
    var timeBook = ""
    let width = ScreenSize.ScreenWidth*0.6
    let height = ScreenSize.ScreenHeight*0.5

    weak var delegate: OrderConfirmDetailDelegate?

    override func setLayoutPage() {
        // set background
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

    }

    func showInView(_ aView: UIView!, withData data: [String:Any], animated: Bool) {

        self.popupView = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.2, y: ScreenSize.ScreenHeight*0.25, width: width, height: height))
        popupView.layer.cornerRadius = height*0.03
        popupView.clipsToBounds = true
        self.popupView.backgroundColor = .white
        self.view.addSubview(self.popupView)

        guard let orderId = data["id"] as? Int,
        let total = data["total"] as? Double,
        let orderDetail = data["orderDetails"] as? [[String:Any]],
        let bookingDate = data["bookingDate"] as? String
        else {
            self.showErrorMessage("Can't map data")
            delegate?.closePopup(popup: self.popupView)
            return
        }

        if orderDetail.count > 0 {
            staffName = (orderDetail[0]["staffName"] as? String)!
        }

        let dateBooking = DateUtil.convertDateTimeFromStringWithFormatInputOutput(with: bookingDate, input: "yyyy-MM-dd'T'HH:mm:ss", output: "EEEE, MMMM dd, yyyy")

        createTitle(orderId: orderId)
        createMainInfo(price: total, staffName: staffName, dateBooking: dateBooking!)
        createServicesList(orderDetail: orderDetail)

        self.view.frame = aView.frame
        self.view.setNeedsDisplay()
        aView.addSubview(self.view)

        let closeButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.4, y: ScreenSize.ScreenHeight*0.75 - height*0.05, width: ScreenSize.ScreenWidth*0.2, height: height*0.1))
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = UIColor.hexStringToUIColor("#DB0A5B")
        closeButton.addTarget(self, action: #selector(closePopupButton(sender:)), for: .touchUpInside)
        self.view.addSubview(closeButton)

        if animated {
            AnimationUtil.showPopupAnimate(self.view)
        }
    }

    func createTitle(orderId: Int) {
        let height = ScreenSize.ScreenHeight*0.05
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleView.backgroundColor = ColorConstant.BackgroundColor
        let titleLabel = UILabel(frame: CGRect(x: 0, y: height*0.1, width: width, height: height*0.7))
        titleLabel.text = "Order #\(orderId)"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.addSubview(titleLabel)

        self.popupView.addSubview(titleView)
    }

    func createMainInfo(price: Double, staffName: String, dateBooking: String) {

        let height = ScreenSize.ScreenHeight*0.25
        let generalInfo = UIView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.05, width: width, height: height*0.75))
        generalInfo.backgroundColor = ColorConstant.BackgroundColor
        let priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height*0.3))
        priceLabel.text = "$\(price)"
        priceLabel.textColor = UIColor.hexStringToUIColor("#E57C27")
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.boldSystemFont(ofSize: 40)
        generalInfo.addSubview(priceLabel)

        let dateBookIcon = UIImageView(frame: CGRect(x: width*0.03, y: height*0.43, width: height*0.12, height: height*0.12))
        dateBookIcon.image = ImageConstant.IconBooking?.withRenderingMode(.alwaysTemplate)
        dateBookIcon.tintColor = .white
        generalInfo.addSubview(dateBookIcon)

        let staffIcon = UIImageView(frame: CGRect(x: width*0.03, y: height*0.58, width: height*0.12, height: height*0.12))
        staffIcon.image = ImageConstant.IconUser
        generalInfo.addSubview(staffIcon)

        let left = width*0.05 + height*0.15
        let dateBookedLabel = UILabel(frame: CGRect(x: left, y: height*0.4, width: width - left, height: height*0.15))
        dateBookedLabel.text = dateBooking
        dateBookedLabel.textColor = .white
        dateBookedLabel.font = UIFont.boldSystemFont(ofSize: 12)
        generalInfo.addSubview(dateBookedLabel)

        let staffLabel = UILabel(frame: CGRect(x: left, y: height*0.55, width: width - left, height: height*0.15))
        staffLabel.text = staffName
        staffLabel.textColor = .white
        staffLabel.font = UIFont.boldSystemFont(ofSize: 12)
        generalInfo.addSubview(staffLabel)

        self.popupView.addSubview(generalInfo)
    }

    func createServicesList(orderDetail: [[String:Any]]) {
        let listProductView = UIScrollView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.2375, width: width, height: height*0.5))
        listProductView.contentSize = CGSize(width: width, height: height*0.15*CGFloat(self.serviceList.count))
        for i in 0..<orderDetail.count {
            listProductView.addSubview(loadItemService(productItem: orderDetail[i], index: CGFloat(i)))
        }
        self.popupView.addSubview(listProductView)
    }

    func loadItemService(productItem: [String: Any], index: CGFloat) -> UIView {
        let productName = productItem["productName"] as? String
        let productPrice = productItem["price"] as? Double
        let itemHeight = height*0.1

        let itemView = UIView(frame: CGRect(x: width*0.05, y: index*itemHeight, width: width*0.9, height: itemHeight))

        let serviceName = UILabel(frame: CGRect(x: width*0.05, y: 0, width: width*0.5, height: itemHeight))
        serviceName.text = productName != nil ? productName!:""
        serviceName.font = UIFont.boldSystemFont(ofSize: 14)

        let price = UILabel(frame: CGRect(x: width*0.55, y: 0, width: width*0.3, height: itemHeight))
        price.text = productPrice != nil ? "$\(productPrice!)" : "$0"
        price.textAlignment = .center
        price.font = UIFont.systemFont(ofSize: 14)

        itemView.addSubview(serviceName)
        itemView.addSubview(price)
        return itemView
    }

    @objc func closePopupButton(sender: UIButton) {
        self.delegate?.closePopup(popup: self.popupView)
    }
}
