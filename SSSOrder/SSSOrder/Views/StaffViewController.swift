//
//  StaffViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import FSCalendar

class StaffViewController: BaseController {

    var productList: [SalonProductModel]!
    var storeBooked: SalonStoreModel!
    var staffList: [StaffModel] = [StaffModel(staffId: -1, name: "Any Staff", avatar: "")]

    var timeSelected: String = ""

    var staffSelected: StaffModel?

    var tableView: UITableView!
    var scheduleCollectionView: UICollectionView!
    var calendar: FSCalendar!
    var dateSelected: String?
    var titleCalendar: UILabel!
    var dropDownButton: UIImageView!

    var timeScroll: UIScrollView! // time slider group
    var listTimeFree: [TimerButton]! //

    var confirmPopup: UIView?

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

    var selectedFullDate: UILabel!
    var noteTextView: UITextView?

    var orderDetail: OrderConfirmDetailViewController!
    let orderController = OrderController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("staff", comment: "")
        self.backTitle = NSLocalizedString("back", comment: "")

        createFSCalendarRow()
        createStaffTableView()
    }

    func createFSCalendarRow() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.5))
        calendar.allowsMultipleSelection = false
        self.view.addGestureRecognizer(self.scopeGesture)
        calendar.scope = .week
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)
        calendar.backgroundColor = .white
        calendar.appearance.titleDefaultColor = UIColor.hexStringToUIColor("#808080")
        calendar.appearance.weekdayTextColor = UIColor.hexStringToUIColor("#808080")
        calendar.appearance.headerTitleColor = UIColor.hexStringToUIColor("#808080")
        calendar.appearance.selectionColor = ColorConstant.ButtonPrimary
        calendar.appearance.headerDateFormat = "MMM yyyy"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = ColorConstant.BackgroundColor
        calendar.select(Date())
        calendar.dataSource = self
        calendar.delegate = self

        let formater = DateFormatter()
        formater.dateFormat = "EEE"
        let weekdayName = formater.string(from: Date())

        switch weekdayName {
        case "Mon":
            calendar.calendarWeekdayView.weekdayLabels[0].textColor = ColorConstant.BackgroundColor
        case "Tue":
            calendar.calendarWeekdayView.weekdayLabels[1].textColor = ColorConstant.BackgroundColor
        case "Wed":
            calendar.calendarWeekdayView.weekdayLabels[2].textColor = ColorConstant.BackgroundColor
        case "Thu":
            calendar.calendarWeekdayView.weekdayLabels[3].textColor = ColorConstant.BackgroundColor
        case "Fri":
            calendar.calendarWeekdayView.weekdayLabels[4].textColor = ColorConstant.BackgroundColor
        case "Sat":
            calendar.calendarWeekdayView.weekdayLabels[4].textColor = ColorConstant.BackgroundColor
        default:
            calendar.calendarWeekdayView.weekdayLabels[0].textColor = ColorConstant.BackgroundColor
        }

        self.dateSelected = self.dateFormatter.string(from: calendar.selectedDate!)
//        updateStaffList(date: calendar.selectedDate!)
        timeScroll = UIScrollView(frame: CGRect(x: 0, y: self.calendar.frame.height + ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.1))
        loadFreeTimeForSelect(date: calendar.selectedDate!)
        self.view.addSubview(calendar)

        // Add toogle button to header calendar
        addHeaderCalendar()
    }

    func addHeaderCalendar() {
        let headerView = UIView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.0625))
        headerView.backgroundColor = .white
        titleLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.4, y: 0, width: ScreenSize.ScreenWidth*0.2, height: ScreenSize.ScreenHeight*0.0625))
        titleLabel!.textColor = UIColor.hexStringToUIColor("#808080")
        titleLabel!.font = calendar.appearance.headerTitleFont
        titleLabel!.text = getTitleDateFormat(date: calendar.currentPage)

        dropDownButton = UIImageView(frame: CGRect(x: ScreenSize.ScreenWidth*0.6, y: ScreenSize.ScreenHeight*0.0234375, width: ScreenSize.ScreenHeight*0.02604375, height: ScreenSize.ScreenHeight*0.015625))
        dropDownButton.image = ImageConstant.IconDown?.withRenderingMode(.alwaysTemplate)
        dropDownButton.tintColor = ColorConstant.BackgroundColor
        dropDownButton.contentMode = .scaleAspectFit
        let button = UIButton(frame: CGRect(x: dropDownButton.frame.origin.x, y: 0, width: ScreenSize.ScreenHeight*0.0625, height: ScreenSize.ScreenHeight*0.0625))
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(switchScopeCalendar(sender:)), for: .touchUpInside)

        headerView.addSubview(titleLabel!)
        headerView.addSubview(dropDownButton)
        headerView.addSubview(button)

        self.view.addSubview(headerView)
    }

    /// Generate free time slider
    func loadFreeTimeForSelect(date: Date) {

        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.orderController.getFreeTimeOfStoreOnDate(storeId: self.storeBooked.salonId, on: date, callback: { (listTime, error) in
                self.removeOverlayLoading()
                if error != nil {
                    self.showErrorMessage(error!)
                } else {
                    self.addTimerButtonToSlider(listTime: listTime)
                }
            })
        }
    }

    func addTimerButtonToSlider(listTime: [String]) {

        self.listTimeFree = []
        let width = ScreenSize.ScreenWidth*0.25
        let height = ScreenSize.ScreenHeight*0.1

        if self.timeScroll != nil {
            self.timeScroll.removeFromSuperview()
            self.timeScroll = nil
        }

        self.timeScroll = UIScrollView(frame: CGRect(x: 0, y: self.calendar.frame.size.height + ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: height))
        self.timeScroll.contentSize = CGSize(width: (width*1.16)*CGFloat(listTime.count) + ScreenSize.ScreenWidth*0.04, height: ScreenSize.ScreenHeight*0.1)

        for i in 0..<listTime.count {
            let spaceLeft = ScreenSize.ScreenWidth*0.04*CGFloat(i+1)
            let newButton = TimerButton(frame: CGRect(x: spaceLeft + width*CGFloat(i), y: height*0.1, width: width, height: height*0.8))
            newButton.name = listTime[i]
            newButton.backgroundColor = ColorConstant.ButtonPrimary
            newButton.isStatus = false
            newButton.layer.cornerRadius = height*0.08
            newButton.addTarget(self, action: #selector(selectTimerButton(sender:)), for: .touchUpInside)
            self.listTimeFree.append(newButton)
            self.timeScroll.addSubview(newButton)
        }

        self.listTimeFree[0].isStatus = true
        updateStaffList(time: self.listTimeFree[0].name)
        self.timeSelected = self.listTimeFree[0].name

        self.view.addSubview(timeScroll)
    }

    func createStaffTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: self.calendar.frame.size.height + ScreenSize.ScreenHeight*0.22, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.5))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.view.addSubview(tableView)
    }

    func updateStaffList(time: String) {
//        self.showOrderDetailPopup(orderId: 274)
//        return
        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.orderController.getFreeTimeOfStaff(date: self.calendar.selectedDate!, time: time, storeId: self.storeBooked.salonId, listSerVice: self.productList, callback: { (staffList, error) in
                self.removeOverlayLoading()
                if error != nil {
                    self.showErrorMessage(error!)
                } else {
                    self.staffList = staffList
                    if self.tableView != nil {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }

    func getTitleDateFormat(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM yyyy"
        return dateFormat.string(from: date)
    }

    // MARK: handler Button touched
    @objc func selectTimerButton(sender: TimerButton) {
        self.timeSelected = sender.name

        for button in self.listTimeFree {
            if button.name == sender.name {
                button.isStatus = true
            } else {
                button.isStatus = false
            }
        }

        updateStaffList(time: self.timeSelected)
    }

    @objc func switchScopeCalendar(sender: UIButton) {

        if self.calendar.scope == .month {
            AnimationUtil.animationRotateView(view: dropDownButton, to: 0)
            self.calendar.setScope(.week, animated: true)
        } else {
            AnimationUtil.animationRotateView(view: dropDownButton, to: CGFloat.pi)
            self.calendar.setScope(.month, animated: true)
        }
    }

    @objc func closePopupTouched(sender: UIButton) {
        confirmPopup!.removeFromSuperview()
    }

    @objc func bookingButtonTouched(sender: UIButton) {
        confirmPopup!.removeFromSuperview()
        print("Book order")
        self.showOverlayLoading()
        DispatchQueue.main.async {
            let user = UserDefaultUtils.getUser()
            let dateBooked = self.dateSelected!
            let order = OrderModel(orderId: -1, storeId: self.storeBooked.salonId, customerId: user!.userId,
                                   status: "New", note: self.noteTextView!.text!,
                                   bookingDate: dateBooked, timePickup: self.timeSelected, productList: self.productList)
            order.staff = self.staffSelected
            self.orderController.createOrder(order: order, paymentMethod: PaymentModel(type: PaymentType.cash), callback: { (status, orderId, error) in
                self.removeOverlayLoading()
                if status {
//                    _ = self.navigationController?.popToRootViewController(animated: true)
                    NotificationCenter.default.post(name: ObserveNameConstant.NewNotificationUpdate, object: nil,
                                                    userInfo: nil)
//                    self.showInfoMessage("Your Order has been submitted successfully.")
                    self.showOrderDetailPopup(orderId: orderId!)
                } else {
                    self.showErrorMessage(error!)
                }
            })
        }
    }

    func showOrderDetailPopup(orderId: Int) {
        DispatchQueue.main.async {
            self.orderController.getOrderDetail(orderId: orderId, callback: { (json, error) in
                if error != nil {
                    self.showErrorMessage(error!)
                    return
                }

                guard let popupController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardConstant.OrderDetailVCID) as? OrderConfirmDetailViewController else {
                    self.showErrorMessage("Can't show order detail")
                    return
                }
                self.orderDetail = popupController
                popupController.titleName = "Order #228"
                popupController.delegate = self
                popupController.showInView(self.view, withData: json!, animated: true)

            })
        }
    }

    // MARK: handler segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? SubmitOrderViewController
        if destVC != nil {
            destVC!.storeBooked = self.storeBooked
            destVC!.productList = self.productList
            destVC!.staffSelected = staffSelected
        }
    }

    override func keyboardWillShow(_ notification: Notification) {
        let tapInputKeyboard2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapInputKeyboard2.cancelsTouchesInView = false
        self.confirmPopup!.addGestureRecognizer(tapInputKeyboard2)
    }

    override func keyboardWillHide(_ notification: Notification) {
        self.confirmPopup!.endEditing(true)
    }
}

extension StaffViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.timeScroll.frame.origin.y = self.calendar.frame.size.height + ScreenSize.ScreenHeight*0.1
        self.tableView.frame.origin.y = self.calendar.frame.size.height + ScreenSize.ScreenHeight*0.22
        self.view.layoutIfNeeded()
    }
}

extension StaffViewController: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let itemSelected = self.dateFormatter.string(from: date)
        let currentDate = self.dateFormatter.string(from: Date())
        if DateUtil.calicuateDaysBetweenTwoDates(start: self.dateFormatter.date(from: currentDate)!, end: self.dateFormatter.date(from: itemSelected)!) < 0 {
            self.showErrorMessage(NSLocalizedString("select date error", comment: ""))
            return false
        }

        return true
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }

        guard let itemSelected = calendar.selectedDate else {
            return
        }

        self.dateSelected = self.dateFormatter.string(from: itemSelected)
        loadFreeTimeForSelect(date: itemSelected)
        self.tableView.reloadData()

    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
         print("\(self.dateFormatter.string(from: calendar.currentPage))")
        titleLabel!.text = getTitleDateFormat(date: calendar.currentPage)
    }
}

extension StaffViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                AnimationUtil.animationRotateView(view: dropDownButton, to: 0) // Animation to week
                return velocity.y < 0
            case .week:
                AnimationUtil.animationRotateView(view: dropDownButton, to: CGFloat.pi) // Animation to month
                return velocity.y > 0
            }
        }
        return shouldBegin
    }

}

extension StaffViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//        return staffList.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return staffList.count
//        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = staffList[indexPath.section]
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "StaffCell")
//        cell.textLabel!.text = item.name

        let cell = StaffTableViewCell(style: .default, reuseIdentifier: "CartCell")
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.15)
        cell.staff = item
        cell.contentView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 10
        cell.avatar.setKingfisherImage(with: URL(string: item.avatar), placeholder: ImageConstant.IconNoImage)
        cell.name.text = item.name
//        cell.rating.rating = item.ratingStar
        cell.delegate = self
//        cell.amTime = item.amTime
//        cell.pmTime = item.pmTime
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.ScreenHeight*0.15
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenSize.ScreenHeight*0.00
    }
}

extension StaffViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        staffSelected = staffList[indexPath.section]
        createPopupView()
//        print("Item selected \(indexPath.row)")
//        self.performSegue(withIdentifier: SegueNameConstant.StaffToSubmit, sender: nil)
    }
}

extension StaffViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a note..."
            textView.textColor = UIColor.lightGray
        }
    }
}

extension StaffViewController: StaffItemDelegate {
    func selectedTime(time: String, staff: StaffModel) {
        print("Time Selected: \(time)")
        self.timeSelected = time
        self.staffSelected = staff
        createPopupView()
    }

    func createPopupView() {
        confirmPopup = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight))
        confirmPopup!.backgroundColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)

        let height = ScreenSize.ScreenHeight*0.1
        let width = ScreenSize.ScreenWidth

        let popupHeight = height*5

        let popupView = UIView(frame: CGRect(x: 0.1*width, y: ScreenSize.ScreenHeight*0.25, width: 0.8*width, height: popupHeight))
        popupView.backgroundColor = UIColor.white
        popupView.layer.cornerRadius = height*0.12
        popupView.clipsToBounds = true

        // init title popup
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 0.8*width, height: height))

        let popupLabel = UILabel(frame: CGRect(x: 0.05*titleView.frame.size.width, y: 0, width: 0.9*titleView.frame.size.width, height: height))
        popupLabel.textColor = .black
        popupLabel.text = "Confirm Booking"
        popupLabel.font = UIFont.boldSystemFont(ofSize: 18)
        popupLabel.textAlignment = .center
        titleView.addSubview(popupLabel)

        popupView.addSubview(titleView)

        // init content
        let dateBooking = UILabel(frame: CGRect(x: width*0.05, y: height*0.8, width: width*0.7, height: height*0.5))
        dateBooking.text = self.staffSelected!.name
        dateBooking.textAlignment = .center
        dateBooking.font = UIFont.systemFont(ofSize: 15)
        let dateValue = UILabel(frame: CGRect(x: width*0.05, y: height*1.2, width: width*0.7, height: height*0.5))
        dateValue.text = "on \(DateUtil.convertDateToFullLongDate(with: self.dateSelected!, formatInput: self.dateFormatter.dateFormat)!) \(self.timeSelected)"
        dateValue.font = UIFont.systemFont(ofSize: 14)
        dateValue.textAlignment = .center
        popupView.addSubview(dateBooking)
        popupView.addSubview(dateValue)

        noteTextView = UITextView(frame: CGRect(x: width*0.05, y: height*1.7, width: width*0.7, height: height*2))
        noteTextView!.layer.borderWidth = 1
        noteTextView!.layer.borderColor = UIColor.black.cgColor
        noteTextView!.font = UIFont.systemFont(ofSize: 12)
        noteTextView!.text = "Add a note..."
        noteTextView!.textColor = UIColor.lightGray
        noteTextView!.delegate = self
        popupView.addSubview(noteTextView!)

        let footerButtonView = UIView(frame: CGRect(x: 0, y: height*4, width: popupView.frame.width, height: height))
        footerButtonView.backgroundColor = UIColor.lightGray
        popupView.addSubview(footerButtonView)

        let cancelButton = UIButton(frame: CGRect(x: 0, y: 1, width: width*0.4 - 0.5, height: height - 1))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(ColorConstant.ButtonPrimary, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(closePopupTouched(sender:)), for: .touchUpInside)
        footerButtonView.addSubview(cancelButton)

        let bookingButton = UIButton(frame: CGRect(x: width*0.4 + 1, y: 1, width: width*0.4 - 0.5, height: height - 1))
        bookingButton.setTitle("Booking", for: .normal)
        bookingButton.backgroundColor = ColorConstant.ButtonPrimary
        bookingButton.addTarget(self, action: #selector(bookingButtonTouched(sender:)), for: .touchUpInside)
        footerButtonView.addSubview(bookingButton)

        confirmPopup!.addSubview(popupView)
        self.view.addSubview(confirmPopup!)
    }
}

extension StaffViewController: OrderConfirmDetailDelegate {
    func closePopup(popup: UIView) {
        AnimationUtil.removePopupAnimate(self.orderDetail.view)
        self.orderDetail = nil
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}

class TimerButton: UIButton {

    private var _status: Bool = false

    var isStatus: Bool {
        get {
            return _status
        }

        set {
            _status = newValue
            if _status {
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = ColorConstant.ButtonPrimary
            } else {
                self.setTitleColor(ColorConstant.ButtonPrimary, for: .normal)
                self.backgroundColor = .white
                self.layer.borderColor = ColorConstant.ButtonPrimary.cgColor
                self.layer.borderWidth = 1
            }
        }
    }

    var name: String = "" {
        didSet {
            self.setTitle(self.name, for: .normal)
        }
    }
}
