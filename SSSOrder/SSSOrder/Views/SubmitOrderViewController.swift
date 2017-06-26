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

    var nameInputField: CustomInputField!
    var mobileInputField: CustomInputField!
    var noteInputField: CustomInputField!

    var paymentMethod = ["Cash", "Method A", "Method B", "Method C"]
    var paymentSelected = ""

    var calendar: FSCalendar!
    var dateSelected: Date?

    var scrollContentTimer: UIScrollView!
    var listTimer: [String] = ["9:10", "10:10", "11:10", "15:10", "17:30"]

    var submitButton: UIButton!

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
        let placeHolderTextAttribute = [NSForegroundColorAttributeName: UIColor.white]
        nameInputField = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.0224,
                                                   width: ScreenSize.ScreenWidth*0.872,
                                                   height: ScreenSize.ScreenHeight*0.084707),
                                     icon: ImageConstant.IconUser!)

        nameInputField.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name", comment: ""),
                                                                            attributes: placeHolderTextAttribute)
        nameInputField.inputTextField.textColor = .white
        nameInputField.inputTextField.tag = 1
        nameInputField.layer.cornerRadius = nameInputField.frame.height*0.5
        nameInputField.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        nameInputField.inputTextField.delegate = self

        mobileInputField = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                           y: ScreenSize.ScreenHeight*0.1198505,
                                                           width: ScreenSize.ScreenWidth*0.872,
                                                           height: ScreenSize.ScreenHeight*0.084707),
                                             icon: ImageConstant.IconPhoneNumber!)

        mobileInputField.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("phone", comment: "user label"),
                                                                                    attributes: placeHolderTextAttribute)
        mobileInputField.inputTextField.textColor = .white
        mobileInputField.inputTextField.tag = 2
        mobileInputField.inputTextField.keyboardType = .phonePad
        mobileInputField.layer.cornerRadius = mobileInputField.frame.height*0.5
        mobileInputField.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        mobileInputField.inputTextField.delegate = self

        noteInputField = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.217301, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707),
                                         icon: ImageConstant.IconNote!)

        noteInputField.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("pass", comment: "user label"),
                                                                                attributes: placeHolderTextAttribute)
        noteInputField.inputTextField.textColor = .white
        noteInputField.inputTextField.tag = 3
        noteInputField.layer.cornerRadius = noteInputField.frame.height*0.5
        noteInputField.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        noteInputField.inputTextField.delegate = self

        let pickerView = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.3147515, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width*0.35, height: pickerView.frame.height))
        label.text = NSLocalizedString("payment", comment: "")
        label.textColor = .white
        let pickPayment = UIPickerView(frame: CGRect(x: pickerView.frame.width*0.45, y: 0, width: pickerView.frame.width*0.4, height: pickerView.frame.height))
        pickPayment.dataSource = self
        pickPayment.delegate = self
        pickPayment.tintColor = .white
        pickPayment.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)

        pickerView.addSubview(label)
        pickerView.addSubview(pickPayment)

        self.scrollViewPage.addSubview(pickerView)
        self.scrollViewPage.addSubview(nameInputField)
        self.scrollViewPage.addSubview(mobileInputField)
        self.scrollViewPage.addSubview(noteInputField)
    }

    func createCalendar() {
        calendar = FSCalendar(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.41, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.3))
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.selectionColor = ColorConstant.ButtonPrimary
        calendar.appearance.todaySelectionColor = ColorConstant.ButtonPrimary
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

    // MARK: Handler button touched
    func timerButtonSelected(sender: UIButton) {
        let index = sender.tag
        for view in scrollContentTimer.subviews {
            let button = view as? UIButton
            if button != nil {
                if button!.tag == index {
                    button!.backgroundColor = ColorConstant.ButtonPrimary
                } else {
                    button!.backgroundColor = .gray
                }
            }
        }
    }

    func submitOrderTouched(sender: UIButton) {
        self.showOverlayLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.removeOverlayLoading()
            NotificationCenter.default.post(name: ObserveNameConstant.NewNotificationUpdate, object: nil, userInfo: ["notification": NotificationModel(name: "New Booking", icon: ImageConstant.IconBooking!, content: "You have booking success with id xxxxxx1234", type: "System", dateString: DateFormatter().string(from: Date()), isRead: false)])
            _ = self.navigationController?.popToRootViewController(animated: true)
            self.showInfoMessage("Submited")
        }

    }

}

extension SubmitOrderViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.paymentMethod.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.paymentMethod[row]
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.paymentMethod[row], attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
}

extension SubmitOrderViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.paymentSelected = self.paymentMethod[row]
    }
}

extension SubmitOrderViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dateSelected = date
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }

}

extension SubmitOrderViewController: FSCalendarDelegate {
}
