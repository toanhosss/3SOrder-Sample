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

    var listData: [NotificationModel] = [
        NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
        NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
        NotificationModel(name: "Use code HAPPY", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "Promotion", dateString: "09:03, 16 June, 2017", isRead: true),
        NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true),
        NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true),
        NotificationModel(name: "System Notification", icon: ImageConstant.IconMail!, content: "Hurry up and use HAPPY code today to get 20% discount for your booking at Beauty Spa", type: "System", dateString: "09:03, 16 June, 2017", isRead: true)
    ]

    var notificationItemSelected: NotificationModel?

    var segmentHeader: HMSegmentedControl!
    var pageScrollCollection: UIScrollView!

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("notification", comment: "")

        createLabelHeaderTitle()
        createListCollectionProduct()
    }

    func createLabelHeaderTitle() {
        segmentHeader = HMSegmentedControl(sectionTitles: ["Promotion", "System Notification"])
        segmentHeader!.frame = CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.075)
        segmentHeader!.autoresizingMask = [.flexibleWidth]
        segmentHeader!.backgroundColor = UIColor.gray
        segmentHeader!.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        segmentHeader!.selectionStyle = .fullWidthStripe
        segmentHeader!.selectionIndicatorLocation = .down
        segmentHeader!.isVerticalDividerEnabled = true
        segmentHeader!.verticalDividerColor = .black
        segmentHeader!.selectionIndicatorColor = .black
        segmentHeader!.addTarget(self, action: #selector(segmentHeaderValueChanged(sender:)), for: .valueChanged)
        self.view.addSubview(segmentHeader!)
    }

    func createListCollectionProduct() {
        pageScrollCollection = UIScrollView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.19, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.73))
        pageScrollCollection.isPagingEnabled = true
        pageScrollCollection.delegate = self
        pageScrollCollection.contentSize = CGSize(width: ScreenSize.ScreenWidth*2, height: ScreenSize.ScreenHeight*0.73)

        for i in 0..<2 {
            let tableViewList = UITableView(frame: CGRect(x: CGFloat(i)*ScreenSize.ScreenWidth, y: 0, width: ScreenSize.ScreenWidth, height: pageScrollCollection.frame.height))
            tableViewList.backgroundColor = .clear
            tableViewList.tag = i
            tableViewList.dataSource = self
            tableViewList.delegate = self
            tableViewList.separatorStyle = .none
            tableViewList.rowHeight = pageScrollCollection.frame.size.height/3
            self.pageScrollCollection.addSubview(tableViewList)
        }

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

extension NotificationViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex: Int = (Int)(self.pageScrollCollection.contentOffset.x / self.pageScrollCollection.frame.size.width + 0.5)
        self.segmentHeader.setSelectedSegmentIndex(UInt(currentIndex), animated: true)
    }
}

extension NotificationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let index = tableView.tag
        if index == 0 {
            return listData.filter({ $0.type == "Promotion"}).count
        } else {
            return listData.filter({ $0.type == "System"}).count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data: [NotificationModel]
        if tableView.tag == 0 {
            data = listData.filter({ $0.type == "Promotion"})
        } else {
            data = listData.filter({ $0.type == "System"})
        }

        let item = data[indexPath.section]
        let cell = NotificationTableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.contentView.frame = CGRect(x: ScreenSize.ScreenWidth*0.025, y: 0, width: ScreenSize.ScreenWidth*0.95, height: ScreenSize.ScreenHeight*0.15)
        cell.backgroundColor = .clear
        cell.data = item
        cell.layerNew.backgroundColor = item.isReadable ? UIColor.white:UIColor.green
        cell.icon.image = item.icon.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = .black
        cell.name.text = item.name
        cell.time.text = item.dateString
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.ScreenHeight*0.15
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenSize.ScreenHeight*0.02
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data: [NotificationModel]
        if tableView.tag == 0 {
            data = listData.filter({ $0.type == "Promotion"})
        } else {
            data = listData.filter({ $0.type == "System"})
        }
        self.notificationItemSelected = data[indexPath.section]
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
