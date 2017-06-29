//
//  CartViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class CartViewController: BaseController {

    var storeBooked: SalonStoreModel!
    var listDataBooking: [SalonProductModel]!
    var staffList: [StaffModel]!
    var tableView: UITableView!
    var continueButton: UIButton!

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = NSLocalizedString("service", comment: "")
        self.backTitle = NSLocalizedString("back", comment: "")

        createProductTableView()
        createButtonContinue()
    }

    func createProductTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.7))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = ScreenSize.ScreenHeight*0.225
        self.view.addSubview(tableView)
    }

    func createButtonContinue() {
        continueButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.82, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.084707))
        continueButton.setTitle(NSLocalizedString("continue", comment: ""), for: .normal)
        continueButton.titleLabel?.textColor = .white
        continueButton.backgroundColor = ColorConstant.ButtonPrimary
        continueButton.layer.cornerRadius = continueButton.frame.height*0.5
        if listDataBooking.count <= 0 {
            self.continueButton.isEnabled = false
        }
        continueButton.addTarget(self, action: #selector(continueButtonTouched(sender:)), for: .touchUpInside)

        self.view.addSubview(continueButton)
    }

    func getStaffListAvailableForThisOrder() -> [StaffModel] {
        var result: [StaffModel] = []
        for item in self.listDataBooking {
            if result.count <= 0 {result.append(item.staffAvailable[0])}
            for i in 0..<item.staffAvailable.count {
                let isExisted = result.contains(where: {$0.staffId == item.staffAvailable[i].staffId})
                if !isExisted {
                    result.append(item.staffAvailable[i])
                }
            }
        }
        return result
    }

    // MARK: Event Handler button touched
    @objc func continueButtonTouched(sender: UIButton) {
        print("Continue Page")
        self.performSegue(withIdentifier: SegueNameConstant.CartToStaff, sender: nil)
    }

    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? StaffViewController
        if destVC != nil {
            destVC!.productList = self.listDataBooking
            destVC!.storeBooked = self.storeBooked
            destVC!.staffList += self.staffList
//            destVC!.staffList += getStaffListAvailableForThisOrder()
        }
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return listDataBooking.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listDataBooking[indexPath.section]
        let cell = CartTableViewCell(style: .default, reuseIdentifier: "CartCell")
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth*0.95, height: ScreenSize.ScreenHeight*0.2)
        cell.itemData = item
        cell.nameProduct.text = item.name
        cell.priceLabel.text = "$\(item.price)"
        cell.durationLabel.text = "Duration: \(item.duration!)"

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.ScreenHeight*0.2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenSize.ScreenHeight*0.02
    }
}

extension CartViewController: UITableViewDelegate {

}

extension CartViewController: CartItemDelegate {
    func removeItem(data: SalonProductModel) {
        if let index = listDataBooking.index(of: data) {
            listDataBooking.remove(at: index)
            self.tableView.reloadData()
        }

        if listDataBooking.count <= 0 {
            self.continueButton.isEnabled = false
        }

        NotificationCenter.default.post(name: ObserveNameConstant.CartNotificationUpdate, object: nil, userInfo: ["cart": listDataBooking])
    }
}
