//
//  SettingViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class SettingViewController: BaseController {

    let settingItemList = [
        SettingItem(name: "Sign out", icon: ImageConstant.IconSignout?.withRenderingMode(.alwaysTemplate))
    ]

    var tableView: UITableView!

    override func setLayoutPage() {
        super.setLayoutPage()
        titlePage = NSLocalizedString("setting", comment: "")
        overlayColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)

        loadTableListSetting()
    }

    func loadTableListSetting() {
        tableView = UITableView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.8))
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingItemList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingItem = self.settingItemList[indexPath.row]
        let cell = SettingItemTableViewCell(style: .default, reuseIdentifier: "settingCell")
        cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.1)

        cell.icon.image = settingItem.icon
        cell.icon.tintColor = ColorConstant.ButtonPrimary
        cell.name.text = settingItem.name

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.ScreenHeight*0.1
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingItem = self.settingItemList[indexPath.row]
        if settingItem.name == "Sign out" {
            UserDefaultUtils.removeUser()
            self.performSegue(withIdentifier: SegueNameConstant.SettingToLogin, sender: nil)
        }
    }
}

class SettingItem: NSObject {
    var name: String
    var icon: UIImage?

    init(name: String, icon: UIImage?) {
        self.name = name
        self.icon = icon
    }

}
