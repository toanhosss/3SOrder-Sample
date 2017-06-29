//
//  StoreWithProductViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import Kingfisher
import HMSegmentedControl

class StoreWithProductViewController: BaseController {

    var dataItem: SalonStoreModel!
    var pageScrollCollection: UIScrollView!
    var segmentHeader: HMSegmentedControl!
    var cartButton: UIButton!

    var productSelected: [SalonProductModel] = []
    var categories: [(id: Int, name: String, product: [SalonProductModel])] = []

    let productController = ProductController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = dataItem.name
        self.backTitle = NSLocalizedString("back", comment: "")
        overlayColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)

        self.navigationController!.navigationBar.tintColor = .white

        addCartIconToNavigationBar()

        getData()

//        createListCollectionProduct()
    }

    func getData() {
        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.productController.getData(storeId: self.dataItem.salonId) { (data, error) in
                self.removeOverlayLoading()
                if error != nil {
                    self.showErrorMessage(error!)
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    var categoriesHeader: [String] = []
                    for i in 0..<data!.count {
                        categoriesHeader.append(data![i].name)
                    }
                    self.categories = data!
                    self.createLabelHeaderTitle(headers: categoriesHeader)
                    self.createListCollectionProduct(headers: categoriesHeader)
                }
            }
        }

    }

    func addCartIconToNavigationBar() {
        let width = ScreenSize.ScreenWidth*0.06
        cartButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.9, y: ScreenSize.ScreenHeight*0.045, width: width, height: width))
        cartButton.setImage(ImageConstant.IconCart, for: .normal)
        cartButton.addTarget(self, action: #selector(cartButtonNavigationTouched(sender:)), for: .touchUpInside)
        self.navigationBarView?.addSubview(cartButton)
    }

    func updateNumberItemInCart(number: String) {

        let max = CGSize(width: ScreenSize.ScreenWidth*0.1, height: ScreenSize.ScreenWidth*0.04)
        let min = CGSize(width: ScreenSize.ScreenWidth*0.04, height: ScreenSize.ScreenWidth*0.04)

        let widthLabel = number.getWidthFromText(maxSize: max, minSize: min, font: UIFont.systemFont(ofSize: 12))
        var notificationNumber: UILabel?
        if cartButton.viewWithTag(2) == nil {
            notificationNumber = UILabel(frame: CGRect(x: cartButton.frame.width - widthLabel*0.5, y: -cartButton.frame.height*0.2, width: widthLabel, height: ScreenSize.ScreenWidth*0.04))
        } else {
            notificationNumber = cartButton.viewWithTag(2) as? UILabel
        }
        notificationNumber!.text = number
        notificationNumber!.tag = 2
        notificationNumber!.textAlignment = .center
        notificationNumber!.font = UIFont.systemFont(ofSize: 10)
        notificationNumber!.textColor = UIColor.white
        notificationNumber!.backgroundColor = .black
        notificationNumber!.clipsToBounds = true
        notificationNumber!.layer.cornerRadius = ScreenSize.ScreenWidth*0.02

        cartButton.addSubview(notificationNumber!)
    }

    func createLabelHeaderTitle(headers: [String]) {
        segmentHeader = HMSegmentedControl(sectionTitles: headers)
        segmentHeader!.frame = CGRect(x: 0, y: ScreenSize.ScreenHeight*0.1, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.075)
        segmentHeader!.autoresizingMask = [.flexibleWidth]
        segmentHeader!.backgroundColor = .gray
        segmentHeader!.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        segmentHeader!.selectionStyle = .fullWidthStripe
        segmentHeader!.selectionIndicatorLocation = .down
        segmentHeader!.isVerticalDividerEnabled = true
        segmentHeader!.verticalDividerColor = .black
        segmentHeader!.selectionIndicatorColor = .black
        segmentHeader!.addTarget(self, action: #selector(segmentHeaderValueChanged(sender:)), for: .valueChanged)
        self.view.addSubview(segmentHeader!)
    }

    func createListCollectionProduct(headers: [String]) {
        pageScrollCollection = UIScrollView(frame: CGRect(x: 0, y: ScreenSize.ScreenHeight*0.19, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.73))
        pageScrollCollection.isPagingEnabled = true
        pageScrollCollection.delegate = self
        pageScrollCollection.contentSize = CGSize(width: ScreenSize.ScreenWidth*CGFloat(headers.count), height: ScreenSize.ScreenHeight*0.73)

        for i in 0..<headers.count {
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
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUpdateCart(notification:)), name: ObserveNameConstant.CartNotificationUpdate, object: nil)
    }

    // MARK: Handler Notification
    @objc func notificationUpdateCart(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let cartProduct = userInfo["cart"] as? [SalonProductModel] else {
                return
        }

        self.productSelected = cartProduct
        for page in pageScrollCollection.subviews {
            let listPage = page as? UITableView
            if listPage != nil {
                listPage?.reloadData()
            }

        }

        self.updateNumberItemInCart(number: "\(self.productSelected.count)")
    }

    // MARK: Handler Button Touched
    @objc func cartButtonNavigationTouched(sender: UIButton) {
        self.performSegue(withIdentifier: SegueNameConstant.StoreToCart, sender: nil)
    }

    // MARK: Handler Segment value changed
    @objc func segmentHeaderValueChanged(sender: HMSegmentedControl) {
        print("Segment value \(sender.selectedSegmentIndex)")
        self.pageScrollCollection.contentOffset = CGPoint(x: CGFloat(sender.selectedSegmentIndex)*ScreenSize.ScreenWidth, y: self.pageScrollCollection.contentOffset.y)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? CartViewController
        if destVC != nil {
            destVC!.listDataBooking = self.productSelected
        }

    }
}

extension StoreWithProductViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex: Int = (Int)(self.pageScrollCollection.contentOffset.x / self.pageScrollCollection.frame.size.width + 0.5)
        self.segmentHeader.setSelectedSegmentIndex(UInt(currentIndex), animated: true)
    }
}

extension StoreWithProductViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let index = tableView.tag
        return categories[index].product.count
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
        let item = categories[tableView.tag].product[indexPath.section]
        let cell = ProductTableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.contentView.frame = CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.25)

        if item.image != "" {
            cell.imageProduct.kf.setImage(with: URL(string: item.image))
        }
        cell.salonProduct = item
        cell.backgroundColor = .clear
        cell.delegate = self
        cell.nameLabel.text = item.name
        cell.descriptionView.text = item.descriptionText
        cell.priceLabel.text = "Prices: $\(item.price)"
        cell.durationLabel.text = "Duration: \(item.duration!)"
        cell.addButton.isHidden = checkProductIsSelected(data: item)
        return cell
    }

    private func checkProductIsSelected(data: SalonProductModel) -> Bool {
        for item in self.productSelected where item.name == data.name { return true }
        return false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.ScreenHeight*0.25
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ScreenSize.ScreenHeight*0.02
    }
}

extension StoreWithProductViewController: UITableViewDelegate {

}

extension StoreWithProductViewController: ProductItemDelegate {
    func addProductData(data: SalonProductModel) {
        self.productSelected.append(data)
        self.updateNumberItemInCart(number: "\(self.productSelected.count)")
    }
}
