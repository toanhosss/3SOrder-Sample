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

    var refreshControl: UIRefreshControl!

    let notificationController = NotificationController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("notification", comment: "")
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList(sender:)), for: .valueChanged)
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
        pageScrollCollection = UIScrollView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.82))
        pageScrollCollection.isPagingEnabled = true
        pageScrollCollection.delegate = self
        pageScrollCollection.contentSize = CGSize(width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.73)

        //        for i in 0..<notificationController.notificationType.count {
        tableViewList = UITableView(frame: CGRect(x: CGFloat(0)*ScreenSize.ScreenWidth, y: 0, width: ScreenSize.ScreenWidth, height: pageScrollCollection.frame.height))
        tableViewList.backgroundColor = .clear
        tableViewList.dataSource = self
        tableViewList.delegate = self
        tableViewList.separatorStyle = .none
        if #available(iOS 10.0, *) {
            tableViewList.refreshControl = self.refreshControl
        } else {
            // Fallback on earlier versions
            tableViewList.addSubview(self.refreshControl)
        }
        self.pageScrollCollection.addSubview(tableViewList)
        //        }

        self.view.addSubview(pageScrollCollection)
    }

    override func setEventAndDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUpdateNumber(notification:)), name: ObserveNameConstant.NewNotificationUpdate, object: nil)
    }

    // MARK: Handler Notification
    @objc func notificationUpdateNumber(notification: Notification) {
        DispatchQueue.main.async {
            self.notificationController.getListNotification { (listNotification, error) in

                if error != nil {
                    self.showErrorMessage(error!)
                    return
                }

                self.listData = listNotification
                var number = 0
                if self.tabBarController?.tabBar.items?[1].badgeValue != nil {
                    number = Int((self.tabBarController?.tabBar.items?[1].badgeValue)!)!
                }
                number += 1
                self.tabBarController?.tabBar.items?[1].badgeValue = "\(number)"

                self.tableViewList.reloadData()

            }
        }
    }

    // MARK: Handler Segment value changed
    @objc func segmentHeaderValueChanged(sender: HMSegmentedControl) {
        print("Segment value \(sender.selectedSegmentIndex)")
        self.pageScrollCollection.contentOffset = CGPoint(x: CGFloat(sender.selectedSegmentIndex)*ScreenSize.ScreenWidth, y: self.pageScrollCollection.contentOffset.y)
    }

    @objc func refreshList(sender: UIRefreshControl) {
        //        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.notificationController.getListNotification { (listNotification, error) in
                //                self.removeOverlayLoading()

                if error != nil {
                    self.showErrorMessage(error!)
                    return
                }

                self.listData = listNotification
                // tell refresh control it can stop showing up now
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
                self.tableViewList.reloadData()

            }
        }
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
        if listData.count <= 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewList.bounds.size.width, height: self.tableViewList.bounds.size.height))
            noDataLabel.text             = NSLocalizedString("There are no notification currently.", comment: "empty offer data")
            noDataLabel.textColor        = UIColor.black
            noDataLabel.font = UIFont.systemFont(ofSize: 15)
            noDataLabel.textAlignment    = .center
            self.tableViewList.backgroundView = noDataLabel
            self.tableViewList.separatorStyle = .none
            return 0
        }

        self.tableViewList.backgroundView = nil
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

        let item = listData[indexPath.row]

        let cell = NotificationTableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.data = item
        if item.type == 2 && item.isConfirmOder && !item.isReadable {
            cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.15)
            cell.isOrderConfirm = true
        } else {
            cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.1)
            cell.isOrderConfirm = false
        }

        cell.status = item.isReadable
        cell.icon.image = listData[indexPath.row].icon.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = ColorConstant.ButtonPrimary
        cell.name.text = listData[indexPath.row].notificationName
        cell.time.text = listData[indexPath.row].dateString
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = self.listData[indexPath.row]

        if item.type == 2 && item.isConfirmOder && !item.isReadable {
            return ScreenSize.ScreenHeight*0.15
        }

        return ScreenSize.ScreenHeight*0.1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //        self.notificationItemSelected = self.listData[indexPath.row]
        //        let index = self.listData.index(of: self.notificationItemSelected!)
        //        self.listData[index!].isReadable = true
        //        tableView.reloadData()
        //
        //        let count = self.listData.filter({ $0.isReadable == false }).count
        //
        //        if count > 0 {
        //            self.tabBarController?.tabBar.items?[1].badgeValue = "\(count)"
        //        } else {
        //            self.tabBarController?.tabBar.items?[1].badgeValue = nil
        //        }

        //        self.performSegue(withIdentifier: SegueNameConstant.NotificationToNotificationItem, sender: nil)

    }
}

extension NotificationViewController: NotificationItemDelegate {
    func submitOrCancelOrder(item: NotificationModel, isAgree: Bool) {
        if !isAgree {

            let warning = UIAlertController(title: "", message: "This order will be cancelled. \nAre you sure?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .default, handler: { (_) in
                warning.dismiss(animated: true, completion: nil)
            })
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.sendActionUpdateNotification(notification: item, isAgree: isAgree)
                warning.dismiss(animated: true, completion: nil)
            })
            warning.addAction(noAction)
            warning.addAction(yesAction)
            self.present(warning, animated: true, completion: nil)

            return
        }

        return self.sendActionUpdateNotification(notification: item, isAgree: isAgree)
    }

    func sendActionUpdateNotification(notification: NotificationModel, isAgree: Bool) {
        notification.isReadable = true
        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.notificationController.confirmOrderAPI(notificationItem: notification, action: isAgree ? 1:2, callback: { (listResult, error) in
                self.removeOverlayLoading()
                if error != nil {
                    self.showErrorMessage(error!)
                } else {
                    self.showInfoMessage("You have been \(isAgree ? "confirmed":"cancelled") this order.")
                    self.listData = listResult
                    self.tableViewList.reloadData()
                }
            })
        }
    }
}
