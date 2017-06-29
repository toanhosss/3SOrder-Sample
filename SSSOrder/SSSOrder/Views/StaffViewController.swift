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

    var staffSelected: StaffModel?

    var tableView: UITableView!

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("staff", comment: "")
        self.backTitle = NSLocalizedString("back", comment: "")

        createStaffTableView()
    }

    override func setEventAndDelegate() {

    }

    func createStaffTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.82))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = ScreenSize.ScreenHeight*0.225
        self.view.addSubview(tableView)
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
}

extension StaffViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
        return staffList.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
//        return staffList.count
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = staffList[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "StaffCell")
        cell.textLabel!.text = item.name

//        let cell = StaffTableViewCell(style: .default, reuseIdentifier: "CartCell")
//        cell.selectionStyle = .none
//        cell.contentView.frame = CGRect(x: ScreenSize.ScreenWidth*0.025, y: 0, width: ScreenSize.ScreenWidth*0.95, height: ScreenSize.ScreenHeight*0.15)
//        cell.contentView.layer.cornerRadius = 10
//        cell.layer.cornerRadius = 10
//        cell.avatar.kf.setImage(with: URL(string: item.avatar))
//        cell.name.text = item.name

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.ScreenHeight*0.1
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return ScreenSize.ScreenHeight*0.02
//    }
}

extension StaffViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        staffSelected = staffList[indexPath.row]
        print("Item selected \(indexPath.row)")
        self.performSegue(withIdentifier: SegueNameConstant.StaffToSubmit, sender: nil)
    }
}
