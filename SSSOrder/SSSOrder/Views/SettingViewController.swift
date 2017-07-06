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
    var inputAPIField: UITextField!

    override func setLayoutPage() {
        super.setLayoutPage()
        titlePage = NSLocalizedString("setting", comment: "")
        overlayColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)
        createConfigureAPIURL()
//        loadTableListSetting()
    }

    func createConfigureAPIURL() {
        let height = ScreenSize.ScreenHeight*0.1
        let apiURLConfigureView = UIView(frame: CGRect(x: 0, y: height, width: ScreenSize.ScreenWidth, height: height))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth*0.2, height: height))
        label.text = "API URL"
        label.textAlignment = .center

        inputAPIField = UITextField(frame: CGRect(x: ScreenSize.ScreenWidth*0.22, y: 0, width: ScreenSize.ScreenWidth*0.75, height: height))
        inputAPIField.keyboardType = .URL
        inputAPIField.layer.borderWidth = 1
        inputAPIField.delegate = self
        apiURLConfigureView.addSubview(label)
        apiURLConfigureView.addSubview(inputAPIField)
        self.view.addSubview(apiURLConfigureView)

        let button = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.1, y: ScreenSize.ScreenHeight*0.22, width: ScreenSize.ScreenWidth*0.8, height: height))
        button.setTitle("Switch URL", for: .normal)
        button.layer.cornerRadius = height*0.05
        button.addTarget(self, action: #selector(switchAPIURL(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }

    func loadTableListSetting() {
        tableView = UITableView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.2, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.7))
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }

    /// MARK: Button handler touched
    @objc func switchAPIURL(sender: UIButton) {
        if self.inputAPIField.text != nil {
            URLConstant.baseURL = self.inputAPIField.text!
        }
        self.showInfoMessage("Switch successgully")
    }

    override func keyboardWillShow(_ notification: Notification) {
        let tapInputKeyboard2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapInputKeyboard2.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapInputKeyboard2)
    }

    override func keyboardWillHide(_ notification: Notification) {

    }

    override func dismissKeyboard() {
        self.view.endEditing(true)
        self.inputAPIField.endEditing(true)
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
