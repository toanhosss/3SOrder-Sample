//
//  SubmitOrderViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import FSCalendar

class SubmitOrderViewController: BaseController {

    var scrollViewPage: UIScrollView!

    var staffSelected: StaffModel!
    var storeBooked: SalonStoreModel!
    var productList: [SalonProductModel]!

    var nameInputField: CustomInputField!
    var mobileInputField: CustomInputField!
    var noteInputField: CustomInputField!

    var popover: Popover?

    var pickPaymentButton: UIButton!
    var paymentMethod = ["Cash", "Credit Card", "Paypal", "Visa Card"]
    var paymentSelected = "Cash"

    var calendar: FSCalendar!
    var dateSelected = Date()
    var timerSelected: String?

    var scrollContentTimer: UIScrollView!
    var listTimer: [String] = ["9:10", "10:10", "11:10", "15:10", "17:30"]

    var submitButton: UIButton!

    let orderController = OrderController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("submit", comment: "")
        self.backTitle = NSLocalizedString("back", comment: "")

        scrollViewPage = UIScrollView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.82))
        scrollViewPage.contentSize = CGSize(width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight)

        self.view.addSubview(scrollViewPage)

        createPersonalInput()
        createCalendar()
        createListButtonTimer()

        submitButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.822, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707))
        submitButton.setTitle(NSLocalizedString("booking", comment: ""), for: .normal)
        submitButton.backgroundColor = ColorConstant.ButtonPrimary
        submitButton.titleLabel?.textColor = .white
        submitButton.addTarget(self, action: #selector(submitOrderTouched(sender:)), for: .touchUpInside)
        submitButton.layer.cornerRadius = submitButton.frame.height*0.5
        scrollViewPage.addSubview(submitButton)

    }

    func createPersonalInput() {
        let placeHolderTextAttribute = [NSForegroundColorAttributeName: UIColor.black]
        nameInputField = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.0224, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707), icon: ImageConstant.IconUser!.withRenderingMode(.alwaysTemplate))
        nameInputField.icon.tintColor = .black
        nameInputField.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name", comment: ""), attributes: placeHolderTextAttribute)
        nameInputField.inputTextField.textColor = .black
        nameInputField.inputTextField.tag = 1
        nameInputField.layer.cornerRadius = nameInputField.frame.height*0.5
        nameInputField.backgroundColor = UIColor.hexStringToUIColor("#000000", alpha: 0.1)
        nameInputField.inputTextField.delegate = self

        mobileInputField = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.1198505, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707), icon: ImageConstant.IconPhoneNumber!.withRenderingMode(.alwaysTemplate))
        mobileInputField.icon.tintColor = .black
        mobileInputField.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("phone", comment: "user label"), attributes: placeHolderTextAttribute)
        mobileInputField.inputTextField.textColor = .black
        mobileInputField.inputTextField.tag = 2
        mobileInputField.inputTextField.keyboardType = .phonePad
        mobileInputField.layer.cornerRadius = mobileInputField.frame.height*0.5
        mobileInputField.backgroundColor = UIColor.hexStringToUIColor("#000000", alpha: 0.1)
        mobileInputField.inputTextField.delegate = self

        let userInfor = self.getUserLoggedInfo()
        if userInfor != nil {
            nameInputField.inputTextField.text = userInfor!.name
            mobileInputField.inputTextField.text = userInfor!.phone
        }

        noteInputField = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.217301, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707),
                                         icon: ImageConstant.IconNote!.withRenderingMode(.alwaysTemplate))
        noteInputField.icon.tintColor = .black
        noteInputField.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("note", comment: "user label"), attributes: placeHolderTextAttribute)
        noteInputField.inputTextField.textColor = .black
        noteInputField.inputTextField.tag = 3
        noteInputField.layer.cornerRadius = noteInputField.frame.height*0.5
        noteInputField.backgroundColor = UIColor.hexStringToUIColor("#000000", alpha: 0.1)
        noteInputField.inputTextField.delegate = self

        let pickerView = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.3147515, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width*0.35, height: pickerView.frame.height))
        label.text = NSLocalizedString("payment", comment: "")
        label.textColor = .black
        pickPaymentButton = UIButton(frame: CGRect(x: pickerView.frame.width*0.45, y: 0, width: pickerView.frame.width*0.4, height: pickerView.frame.height))
        pickPaymentButton.setImage(ImageConstant.IconExpand?.withRenderingMode(.alwaysTemplate), for: .normal)
        pickPaymentButton.tintColor = .white
        pickPaymentButton.backgroundColor = .gray
        pickPaymentButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: pickPaymentButton.frame.width*0.75, bottom: 6, right: 4)
        pickPaymentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: pickPaymentButton.frame.width*0.25)
        pickPaymentButton.layer.cornerRadius = 5
        pickPaymentButton.setTitle(paymentSelected, for: .normal)
        pickPaymentButton.addTarget(self, action: #selector(showPopupPayment(sender:)), for: .touchUpInside)

        pickerView.addSubview(label)
        pickerView.addSubview(pickPaymentButton)

        self.scrollViewPage.addSubview(pickerView)
        self.scrollViewPage.addSubview(nameInputField)
        self.scrollViewPage.addSubview(mobileInputField)
        self.scrollViewPage.addSubview(noteInputField)
    }

    func createCalendar() {
        calendar = FSCalendar(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.41, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.3))
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = ColorConstant.ButtonPrimary
        calendar.appearance.todaySelectionColor = ColorConstant.ButtonPrimary
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.weekdayTextColor = UIColor.hexStringToUIColor("#6563A4")
        calendar.appearance.headerTitleColor = UIColor.hexStringToUIColor("#6563A4")
        calendar.dataSource = self
        calendar.delegate = self
        self.scrollViewPage.addSubview(calendar)
    }

    func createListButtonTimer() {
        scrollContentTimer = UIScrollView(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.72, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707))

        scrollContentTimer.contentSize = CGSize(width: ScreenSize.ScreenWidth*0.218*CGFloat(self.listTimer.count), height: ScreenSize.ScreenHeight*0.084707)

        for i in 0..<self.listTimer.count {
            let timer = UIButton(frame: CGRect(x: CGFloat(i)*ScreenSize.ScreenWidth*0.218, y: 0, width: ScreenSize.ScreenWidth*0.215, height: ScreenSize.ScreenHeight*0.084707))
            timer.tag = i
            timer.setTitle(self.listTimer[i], for: .normal)
            timer.titleLabel!.textColor = .white
            timer.backgroundColor = .gray
            timer.addTarget(self, action: #selector(timerButtonSelected(sender:)), for: .touchUpInside)
            scrollContentTimer.addSubview(timer)
        }

        self.scrollViewPage.addSubview(scrollContentTimer)
    }

    private func loadActionTableView() -> UIView {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth*0.5, height: ScreenSize.ScreenHeight*0.3))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }

    // MARK: Handler button touched
    func showPopupPayment(sender: UIButton) {

        let options = [
            PopoverOption.type(PopoverType.down),
            PopoverOption.cornerRadius(0),
            PopoverOption.animationIn(0.3),
            PopoverOption.arrowSize(CGSize(width: 10, height: 10)),
            PopoverOption.color(UIColor.white)
            ] as [PopoverOption]
        popover = Popover(options: options)
        let aView = loadActionTableView()
        popover!.show(aView, fromView: sender)
    }

    func timerButtonSelected(sender: UIButton) {
        let index = sender.tag
        for view in scrollContentTimer.subviews {
            let button = view as? UIButton
            if button != nil {
                if button!.tag == index {
                    button!.backgroundColor = ColorConstant.ButtonPrimary
                    self.timerSelected = button!.titleLabel!.text
                } else {
                    button!.backgroundColor = .gray
                }
            }
        }
    }

    func submitOrderTouched(sender: UIButton) {
        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.orderController.createOrder(nameCustomer: self.nameInputField.inputTextField.text, note: self.nameInputField.inputTextField.text, phoneNumber: self.mobileInputField.inputTextField.text, bookingDate: self.dateSelected, timePickup: self.timerSelected, storeId: self.storeBooked.salonId, productList: self.productList, staffSelected: self.staffSelected, paymentMethod: PaymentModel(type: self.getPaymentMethod(method: self.paymentSelected)), callback: { (status, error) in
                 self.removeOverlayLoading()
                if status {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm, dd MMM yyyy"
                    NotificationCenter.default.post(name: ObserveNameConstant.NewNotificationUpdate, object: nil, userInfo: ["notification": NotificationModel(name: "New Booking", icon: ImageConstant.IconBooking!, content: "You have booking success with id xxxxxx1234", type: "System", dateString: formatter.string(from: Date()), isRead: false)])
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    self.showInfoMessage("Submited")
                } else {
                    self.showErrorMessage(error!)
                }
            })
        }
    }

    private func getPaymentMethod(method: String) -> PaymentType {
        switch method {
        case "Credit Card":
            return PaymentType.creditCard
        case "Paypal":
            return PaymentType.paypal
        case "Visa Card":
            return PaymentType.visaCard
        default:
            return PaymentType.cash
        }
    }

}

extension SubmitOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethod.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.paymentMethod[indexPath.row]
        return cell
    }
}

extension SubmitOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popover!.dismiss()
        self.paymentSelected = self.paymentMethod[indexPath.row]
        self.pickPaymentButton.setTitle(paymentSelected, for: .normal)
    }
}

extension SubmitOrderViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dateSelected = date
        self.calendar.appearance.todaySelectionColor = .clear
        if monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }

}

extension SubmitOrderViewController: FSCalendarDelegate {
}
