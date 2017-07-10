//
//  StaffViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class StaffViewController: BaseController {

    var productList: [SalonProductModel]!
    var storeBooked: SalonStoreModel!
    var staffList: [StaffModel] = [StaffModel(staffId: -1, name: "Any Staff", avatar: "")]
//    var staffList: [StaffModel] = [
//        StaffModel(name: "Any Staff", avatar: ""),
//        StaffModel(name: "Staff A", avatar: ""),
//        StaffModel(name: "Staff B", avatar: ""),
//        StaffModel(name: "Staff C", avatar: ""),
//        StaffModel(name: "Staff D", avatar: ""),
//        StaffModel(name: "Staff E", avatar: ""),
//        StaffModel(name: "Staff F", avatar: ""),
//        StaffModel(name: "Staff G", avatar: "")
//    ]

    var schedulerData: [MyCalendarObject] = []
    var dateSelectedIndex: Int = 3 // current date always at index 3
    var timeSelected: String = ""

    var staffSelected: StaffModel?

    var tableView: UITableView!
    var scheduleCollectionView: UICollectionView!
    var selectedFullDate: UILabel!
    var noteTextView: UITextView?

    var confirmPopup: UIView?

    let orderController = OrderController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("staff", comment: "")
        self.backTitle = NSLocalizedString("back", comment: "")

        createCalendarRow()
        createStaffTableView()
    }

    func createCalendarRow() {
        schedulerData = orderController.getSchedulerData() // Get schedule from current date
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ScreenSize.ScreenWidth/7, height: ScreenSize.ScreenHeight*0.1)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        scheduleCollectionView = UICollectionView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.1), collectionViewLayout: flowLayout)
        scheduleCollectionView.dataSource = self
        scheduleCollectionView.delegate = self
        scheduleCollectionView.backgroundColor = .clear
        scheduleCollectionView.showsHorizontalScrollIndicator = false
        scheduleCollectionView.allowsMultipleSelection = false
        scheduleCollectionView.allowsSelection = true
        scheduleCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        selectedFullDate = UILabel(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.2, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.05))
        selectedFullDate.textAlignment = .center
        selectedFullDate.layer.borderColor = UIColor.black.cgColor
        selectedFullDate.layer.borderWidth = 0.5
        selectedFullDate.text = schedulerData[self.dateSelectedIndex].dateFull

        let time = orderController.getFreeTimeOfStaff(date: self.schedulerData[self.dateSelectedIndex].dateData)

        for staff in self.staffList {
            staff.getFreeTime(time: time)
        }

        self.view.addSubview(scheduleCollectionView)
        self.view.addSubview(selectedFullDate)
    }

    func createStaffTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.3, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.62))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.rowHeight = ScreenSize.ScreenHeight*0.05
        self.view.addSubview(tableView)
    }

    // MARK: handler Button touched
    @objc func closePopupTouched(sender: UIButton) {
        confirmPopup!.removeFromSuperview()
    }

    @objc func bookingButtonTouched(sender: UIButton) {
        confirmPopup!.removeFromSuperview()
        print("Book order")
        self.showOverlayLoading()
        DispatchQueue.main.async {
            let user = UserDefaultUtils.getUser()
            let order = OrderModel(orderId: -1, storeId: self.storeBooked.salonId, customerId: user!.userId, status: "New", note: self.noteTextView!.text!, bookingDate: self.schedulerData[self.dateSelectedIndex].dateFull, isCheckedIn: false, isCheckedOut: false, timePickup: self.timeSelected, productList: self.productList)
            order.staff = self.staffSelected
            self.orderController.createOrder(order: order, paymentMethod: PaymentModel(type: PaymentType.cash), callback: { (status, error) in
                self.removeOverlayLoading()
                if status {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm, dd MMM yyyy"
                    NotificationCenter.default.post(name: ObserveNameConstant.NewNotificationUpdate, object: nil, userInfo: ["notification": NotificationModel(name: "New Booking", icon: ImageConstant.IconBooking!, content: "You have booking success with id xxxxxx1234", type: "System", dateString: formatter.string(from: Date()), isRead: false)])
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    self.showInfoMessage("Your Order has been submitted successfully.")
                } else {
                    self.showErrorMessage(error!)
                }
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

// Collection View DataSource
extension StaffViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.schedulerData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.schedulerData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CalendarCollectionViewCell
        cell!.isCanSelect = item.canSelected
        cell!.day.text = "\(item.getDayNumber())"
        cell!.dayName.text = item.getEraString()
        cell!.updateBackground()
        cell!.itemSelected = self.dateSelectedIndex == indexPath.row

        return cell!
    }
}

// Collection View Delegate
extension StaffViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.schedulerData[indexPath.row]
        if !item.canSelected {
            self.showInfoMessage(NSLocalizedString("select date error", comment: ""))
            return
        }
        self.dateSelectedIndex = indexPath.row
        selectedFullDate.text = schedulerData[self.dateSelectedIndex].dateFull
        // Todo: Call API to update staff data
        let time = orderController.getFreeTimeOfStaff(date: item.dateData)
        for staff in self.staffList {
            staff.getFreeTime(time: time)
        }
        collectionView.reloadData()
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
        let item = staffList[indexPath.row]
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "StaffCell")
//        cell.textLabel!.text = item.name

        let cell = StaffTableViewCell(style: .default, reuseIdentifier: "CartCell")
        cell.selectionStyle = .none
        cell.contentView.frame = CGRect(x: ScreenSize.ScreenWidth*0.025, y: 0, width: ScreenSize.ScreenWidth*0.95, height: ScreenSize.ScreenHeight*0.45)
        cell.staff = item
        cell.contentView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 10
        cell.avatar.kf.setImage(with: URL(string: item.avatar))
        cell.name.text = item.name
        cell.rating.rating = item.ratingStar
        cell.delegate = self
        cell.amTime = item.amTime
        cell.pmTime = item.pmTime
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.ScreenHeight*0.45
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenSize.ScreenHeight*0.03
    }
}

extension StaffViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        staffSelected = staffList[indexPath.row]
//        print("Item selected \(indexPath.row)")
//        self.performSegue(withIdentifier: SegueNameConstant.StaffToSubmit, sender: nil)
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
        confirmPopup!.backgroundColor = UIColor.hexStringToUIColor("#000000", alpha: 0.8)

        let height = ScreenSize.ScreenHeight*0.1
        let width = ScreenSize.ScreenWidth

        let popupHeight = height*5

        let popupView = UIView(frame: CGRect(x: 0.1*width, y: ScreenSize.ScreenHeight*0.25, width: 0.8*width, height: popupHeight))
        popupView.backgroundColor = UIColor.white
        popupView.layer.cornerRadius = height*0.1
        popupView.clipsToBounds = true

        // init title popup
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 0.8*width, height: height))

        let popupLabel = UILabel(frame: CGRect(x: 0.05*titleView.frame.size.width, y: 0, width: 0.8*titleView.frame.size.width, height: height))
        popupLabel.textColor = UIColor.white
        popupLabel.textAlignment = .center
        titleView.addSubview(popupLabel)

        let closeIcon = UIImageView(frame: CGRect(x: width*0.65, y: height*0.25, width: titleView.frame.size.width*0.1, height: height*0.5))
        closeIcon.image = ImageConstant.IconClose?.withRenderingMode(.alwaysTemplate)
        closeIcon.tintColor = UIColor.white
        closeIcon.contentMode = .scaleAspectFit
        titleView.backgroundColor = ColorConstant.BackgroundColor
        titleView.addSubview(closeIcon)

        let closeButton = UIButton(frame: CGRect(x: width*0.6, y: 0, width: titleView.frame.size.width*0.15, height: height))
        closeButton.addTarget(self, action: #selector(closePopupTouched(sender:)), for: .touchUpInside)
        titleView.addSubview(closeButton)

        popupView.addSubview(titleView)

        // init content
        let noteLabel = UILabel(frame: CGRect(x: width*0.05, y: height*1.1, width: width*0.7, height: height*0.5))
        noteLabel.text = NSLocalizedString("note", comment: "")
        noteTextView = UITextView(frame: CGRect(x: width*0.05, y: height*1.65, width: width*0.7, height: height*2.3))
        noteTextView!.layer.borderWidth = 1
        noteTextView!.layer.borderColor = UIColor.black.cgColor
        popupView.addSubview(noteLabel)
        popupView.addSubview(noteTextView!)

        let bookingButton = UIButton(frame: CGRect(x: width*0.05, y: height*4.1, width: width*0.7, height: height*0.8))
        bookingButton.setTitle("Booking", for: .normal)
        bookingButton.titleLabel?.textColor = .white
        bookingButton.backgroundColor = ColorConstant.ButtonPrimary
        bookingButton.layer.cornerRadius = height*0.08
        bookingButton.addTarget(self, action: #selector(bookingButtonTouched(sender:)), for: .touchUpInside)
        popupView.addSubview(bookingButton)

        confirmPopup!.addSubview(popupView)
        self.view.addSubview(confirmPopup!)
    }
}
