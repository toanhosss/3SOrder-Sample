//
//  NotificationViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import HMSegmentedControl

class NotificationViewController: BaseController {

    var listData: [NotificationModel] = []

    var notificationItemSelected: NotificationModel?

    var segmentHeader: HMSegmentedControl!
    var pageScrollCollection: UIScrollView!
    var tableViewList: UITableView!

    let notificationController = NotificationController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("notification", comment: "")

        getData()
    }

    /// Get Data
    func getData() {
        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.notificationController.getListNotification { (listNotification, error) in
                self.removeOverlayLoading()

                if error != nil {
                    self.showErrorMessage(error!)
                } else {
                    self.listData = listNotification
                    //                self.createLabelHeaderTitle()
                    self.createListCollectionProduct()
                }
            }
        }
    }

    func createLabelHeaderTitle() {
        segmentHeader = HMSegmentedControl(sectionTitles: notificationController.notificationType)
        segmentHeader!.frame = CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.075)
        segmentHeader!.autoresizingMask = [.flexibleWidth]
        segmentHeader!.backgroundColor = .white
        segmentHeader!.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        segmentHeader!.selectionStyle = .textWidthStripe
        segmentHeader!.selectionIndicatorLocation = .down
        segmentHeader!.selectionIndicatorColor = ColorConstant.BackgroundColor
        segmentHeader!.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        segmentHeader!.addTarget(self, action: #selector(segmentHeaderValueChanged(sender:)), for: .valueChanged)
        self.view.addSubview(segmentHeader!)
    }

    func createListCollectionProduct() {
        pageScrollCollection = UIScrollView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.73))
        pageScrollCollection.isPagingEnabled = true
        pageScrollCollection.delegate = self
        pageScrollCollection.contentSize = CGSize(width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.73)

//        for i in 0..<notificationController.notificationType.count {
            tableViewList = UITableView(frame: CGRect(x: CGFloat(0)*ScreenSize.ScreenWidth, y: 0, width: ScreenSize.ScreenWidth, height: pageScrollCollection.frame.height))
            tableViewList.backgroundColor = .clear
//            tableViewList.tag = i
            tableViewList.dataSource = self
            tableViewList.delegate = self
            tableViewList.separatorStyle = .none
            tableViewList.rowHeight = pageScrollCollection.frame.size.height/3
            self.pageScrollCollection.addSubview(tableViewList)
//        }

        self.view.addSubview(pageScrollCollection)
    }

    override func setEventAndDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUpdateNumber(notification:)), name: ObserveNameConstant.NewNotificationUpdate, object: nil)
    }

    // MARK: Handler Notification
    @objc func notificationUpdateNumber(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let notificationItem = userInfo["notification"] as? NotificationModel else {
                return
        }

        self.listData.insert(notificationItem, at: 0)
        let count = self.listData.filter({ $0.isReadable == false }).count

        if count > 0 {
            self.tabBarController?.tabBar.items?[1].badgeValue = "\(count)"
        } else {
            self.tabBarController?.tabBar.items?[1].badgeValue = nil
        }

        if self.pageScrollCollection != nil {
            for view in pageScrollCollection.subviews {
                let page = view as? UITableView
                if page != nil {
                    page!.reloadData()
                }
            }
        }

    }

    // MARK: Handler Segment value changed
    @objc func segmentHeaderValueChanged(sender: HMSegmentedControl) {
        print("Segment value \(sender.selectedSegmentIndex)")
        self.pageScrollCollection.contentOffset = CGPoint(x: CGFloat(sender.selectedSegmentIndex)*ScreenSize.ScreenWidth, y: self.pageScrollCollection.contentOffset.y)
    }

    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? NotificationItemViewController
        if destVC != nil {
            destVC!.data = self.notificationItemSelected
        }
    }

}

//extension NotificationViewController: UIScrollViewDelegate {
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let currentIndex: Int = (Int)(self.pageScrollCollection.contentOffset.x / self.pageScrollCollection.frame.size.width + 0.5)
//        self.segmentHeader.setSelectedSegmentIndex(UInt(currentIndex), animated: true)
//    }
//}

extension NotificationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //        let index = tableView.tag
        //        if index == 0 {
        //            return listData.filter({ $0.type == "Promotion"}).count
        //        } else {
        //            return listData.filter({ $0.type == "System"}).count
        //        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return 1
//        let index = tableView.tag
//        if index == 0 {
//            return listData.filter({ $0.type == "Promotion"}).count
//        } else {
//            return listData.filter({ $0.type == "System"}).count
//        }
        return listData.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var data: [NotificationModel]
//        if tableView.tag == 0 {
//            data = listData.filter({ $0.type == "Promotion"})
//        } else {
//            data = listData.filter({ $0.type == "System"})
//        }
//        data = listData

        let item = listData[indexPath.row]

        let cell = NotificationTableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.data = item
        if item.type == "2" && item.isConfirmOder && !item.isReadable {
            cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.15)
            cell.isOrderConfirm = true
        } else {
            cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.1)
            cell.isOrderConfirm = false
        }
        //        cell.backgroundColor = .clear
//        cell.backgroundColor = listData[indexPath.row].isReadable ? UIColor.white:UIColor.hexStringToUIColor("#C5EFF7")
//        cell.cardView.backgroundColor = listData[indexPath.row].isReadable ? UIColor.white:UIColor.green
        cell.status = item.isReadable
        cell.icon.image = listData[indexPath.row].icon.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = ColorConstant.ButtonPrimary
        cell.name.text = listData[indexPath.row].name
        cell.time.text = listData[indexPath.row].dateString
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = self.listData[indexPath.row]

        if item.type == "2" && item.isConfirmOder && !item.isReadable {
            return ScreenSize.ScreenHeight*0.15
        }

        return ScreenSize.ScreenHeight*0.1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenSize.ScreenHeight*0
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.notificationItemSelected = self.listData[indexPath.row]
        let index = self.listData.index(of: self.notificationItemSelected!)
        self.listData[index!].isReadable = true
        tableView.reloadData()

        let count = self.listData.filter({ $0.isReadable == false }).count

        if count > 0 {
            self.tabBarController?.tabBar.items?[1].badgeValue = "\(count)"
        } else {
            self.tabBarController?.tabBar.items?[1].badgeValue = nil
        }

        self.performSegue(withIdentifier: SegueNameConstant.NotificationToNotificationItem, sender: nil)

    }
}

extension NotificationViewController: NotificationItemDelegate {
    func submitOrCancelOrder(item: NotificationModel, isCancel: Bool) {
        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.notificationController.confirmOrderAPI(orderId: item.orderId!, callback: { (_, error) in
                self.removeOverlayLoading()
                if error != nil {
                    self.showErrorMessage(error!)
                } else {
                    self.showInfoMessage("You have been \(isCancel ? "cancelled":"confirmed") this order.")
                    item.isConfirmOder = false
                    item.isReadable = true
                    let index = self.listData.index(of: item)
                    if index != nil {
                        let indexPath = IndexPath(row: index!, section: 0)
                        self.tableViewList.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            })
        }
    }
}
