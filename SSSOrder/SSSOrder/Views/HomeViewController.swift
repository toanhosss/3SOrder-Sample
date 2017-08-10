//
//  HomeViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import GoogleMaps
import Kingfisher

class HomeViewController: BaseController {

    var mapView: GMSMapView!
    var listItemView: UIScrollView!
    var pageControl: UIPageControl!

    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0
    var justScrollX = false
    var justScrollY = false

    var itemSelected = 0
    var dataSource: [SalonStoreModel] = []
    var dataMarker: [GMSMarker] = []

    let homeController = StoreController.SharedInstance

    override func setLayoutPage() {
        super.setLayoutPage()

        titlePage = NSLocalizedString("home", comment: "")
        setTabbarIcon(icons: [ImageConstant.IconHome!, ImageConstant.IconOrderList!, ImageConstant.IconBooking!, ImageConstant.IconMenu!], name: ["Home", "Notification", "History", "Menu"])
        overlayColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)

        getData()

        // Draw map view
        initMapView()

    }

    func getData() {
        var location = appDelegate?.currentLocation
        //49.687447, -95.322750
        location = (lat: "53.456765", long: "-113.481539") // Hard location in Canada to see all salon
        if location != nil {
            self.showOverlayLoading()
            DispatchQueue.main.async {
                self.homeController.getStore(lat: location!.lat, long: location!.long, callback: { (salon, error) in
                    self.removeOverlayLoading()
                    if salon != nil {
                        print("Got data")
                        self.dataSource = salon!
                        if self.dataSource.count > 0 {
                            self.createListDataSource()
                            self.insertMarkerToMap()
                        } else {
                            self.showErrorEmptySalon(error: "Don't have any salon near you.")
                        }
                    } else {
                        print("Got Error")
                        self.showErrorMessage(error!)
                    }
                })
            }
        } else {
            self.showErrorMessage("Can't get current location")
        }
    }

    private func showErrorEmptySalon(error: String) {
        let popup = UIAlertController(title: title, message: error, preferredStyle: .alert)

        let confirm: UIAlertAction = UIAlertAction(title: "Try again", style: .default) { (_) in
            self.getData()
        }
        popup.addAction(confirm)

        present(popup, animated: true, completion: nil)
    }

    /// create map view
    func initMapView() {

        // TODOs: get current location and load map
                var currentLocation = appDelegate?.currentLocation
        currentLocation = (lat: "53.456765", long: "-113.481539") // Hard location in Canada to see all salon

        let locationCamera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Double(currentLocation!.lat)!), longitude: CLLocationDegrees(Double(currentLocation!.long)!), zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0,
                                                   y: ScreenSize.ScreenHeight*0.1,
                                                   width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight*0.51), camera: locationCamera)
        mapView.isMyLocationEnabled = false
        mapView.layer.cornerRadius = 10

        self.view.addSubview(mapView)
    }

    private func insertMarkerToMap() {

        // clear mapView data
        mapView.clear()

        var bounds = GMSCoordinateBounds()

        let rect = CGRect(x: 0, y: 0, width: mapView.frame.width*0.15, height: mapView.frame.width*0.15)

        for itemData in self.dataSource {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(itemData.latitude), longitude: CLLocationDegrees(itemData.longitude))
            let itemMarker = GMSMarker(position: location)
            itemMarker.title = itemData.name

//             create marker view
            let markerView = MyMarkerMap(frame: rect)
            itemMarker.iconView = markerView
            itemMarker.tracksViewChanges = true
            bounds = bounds.includingCoordinate(location)
            itemMarker.map = self.mapView
            dataMarker.append(itemMarker)
        }

        (self.dataMarker[0].iconView as? MyMarkerMap)!.updateMarkerHighlight(status: true)
        self.dataMarker[0].map = self.mapView
//        let currentLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(appDelegate!.currentLocation!.lat)!), longitude: CLLocationDegrees(Double(appDelegate!.currentLocation!.long)!))
        let currentLocation = CLLocationCoordinate2D(latitude: 53.456765, longitude: -113.481539)
        let itemMarker = GMSMarker(position: currentLocation)
        let icon = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        icon.layer.cornerRadius = 8
        icon.backgroundColor = UIColor.hexStringToUIColor("#19B5FE")
        itemMarker.iconView = icon
        itemMarker.map = self.mapView
        bounds = bounds.includingCoordinate(currentLocation)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        let locationCamera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: mapView.camera.zoom)
        mapView.animate(to: locationCamera)
    }

    /// create PageView List
    func createListDataSource() {

        if listItemView != nil {
            listItemView.removeFromSuperview()
            listItemView = nil
        }

        let itemWidth = ScreenSize.ScreenWidth*0.95
        let itemHeight = ScreenSize.ScreenHeight*0.25

        listItemView = UIScrollView(frame: CGRect(x: ScreenSize.ScreenWidth*0.025, y: ScreenSize.ScreenHeight*0.62, width: itemWidth, height: itemHeight))
        listItemView.showsHorizontalScrollIndicator = false
        listItemView.isScrollEnabled = true
        listItemView.isPagingEnabled = true
        listItemView.delegate = self

        listItemView.contentSize = CGSize(width: itemWidth*CGFloat(dataSource.count), height: itemHeight)

        for i in 0..<dataSource.count {
            let container = StoreView(frame: CGRect(x: CGFloat(i)*itemWidth, y: 0, width: itemWidth, height: itemHeight), storeModel: dataSource[i])
            container.tag = i
            container.backgroundColor = .clear
            let tapStoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadStoreProduct(sender:)))
            container.isUserInteractionEnabled = true
            container.addGestureRecognizer(tapStoreRecognizer)

            listItemView.addSubview(container)
        }

        // Draw page control
        pageControl = UIPageControl(frame: CGRect(x: ScreenSize.ScreenWidth*0.25, y: ScreenSize.ScreenHeight*0.869, width: ScreenSize.ScreenWidth*0.5, height: ScreenSize.ScreenHeight*0.06))
        pageControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        pageControl.currentPageIndicatorTintColor = ColorConstant.ButtonPrimary
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.numberOfPages = dataSource.count
        pageControl.currentPage = 0

        self.view.addSubview(listItemView)
        self.view.addSubview(pageControl)
    }

    // MARK: Event handler touched
    func loadStoreProduct(sender: UITapGestureRecognizer) {
        let index = sender.view!.tag
        print("Load Store index \(index)")
        self.itemSelected = index
        self.showOverlayLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.removeOverlayLoading()
            self.performSegue(withIdentifier: SegueNameConstant.HomeToStore, sender: nil)
        }
    }

    // MARK: Handler perpare for seuge
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = self.dataSource[itemSelected]
        let destVC = segue.destination as? StoreWithProductViewController
        if destVC != nil {
            destVC!.dataItem = item
        }

    }

    override func setEventAndDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUpdateNumber(notification:)), name: ObserveNameConstant.NewNotificationUpdate, object: nil)
    }

    // MARK: Handler Notification
    @objc func notificationUpdateNumber(notification: Notification) {
        DispatchQueue.main.async {
            NotificationController.SharedInstance.getListNotification { (_, error) in

                if error != nil {
                    self.showErrorMessage(error!)
                } else {
                    var number = 0
                    if self.tabBarController?.tabBar.items?[1].badgeValue != nil {
                        number = Int((self.tabBarController?.tabBar.items?[1].badgeValue)!)!
                    }
                    number += 1
                    self.tabBarController?.tabBar.items?[1].badgeValue = "\(number)"

                }
            }
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startX = scrollView.contentOffset.x
        startY = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let deltaX = abs(scrollView.contentOffset.x - startX)
        let deltaY = abs(scrollView.contentOffset.y - startY)

        if justScrollX {
            scrollView.contentOffset.y = startY
            startX = scrollView.contentOffset.x
        } else if justScrollY {
            scrollView.contentOffset.x = startX
            startY = scrollView.contentOffset.y
        } else {
            if deltaX > deltaY {
                scrollView.contentOffset.y = startY
                startX = scrollView.contentOffset.x
                justScrollX = true
            } else {
                scrollView.contentOffset.x = startX
                startY = scrollView.contentOffset.y
                justScrollY = true
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        justScrollY = false
        justScrollX = false
        let currentIndex: Int = (Int)(self.listItemView.contentOffset.x / self.listItemView.frame.size.width + 0.5)
        startY = 0
        switch currentIndex {
        case 0:
            startX = 0
        case 1:
            startX = listItemView.frame.width
        case 2:
            startX = listItemView.frame.width*2
        case 3:
            startX = listItemView.frame.width*3
        case 4:
            startX = listItemView.frame.width*4
        default:
            break
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex: Int = (Int)(self.listItemView.contentOffset.x / self.listItemView.frame.size.width + 0.5)
        self.pageControl.currentPage = currentIndex
        for i in 0..<self.dataMarker.count {
            if i == currentIndex {
                (self.dataMarker[i].iconView as? MyMarkerMap)!.updateMarkerHighlight(status: true)
                self.dataMarker[i].map = self.mapView
            } else {
                (self.dataMarker[i].iconView as? MyMarkerMap)!.updateMarkerHighlight(status: false)
                self.dataMarker[i].map = self.mapView
            }
        }

        startX = scrollView.contentOffset.x
        startY = scrollView.contentOffset.y
        justScrollX = false
        justScrollY = false

    }
}
