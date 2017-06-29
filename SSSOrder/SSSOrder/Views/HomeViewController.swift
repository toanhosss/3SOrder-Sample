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
    var dataMarker:[GMSMarker] = []

    let homeController = StoreController.SharedInstance

//    var dataSource: [SalonStoreModel] = [
//        SalonStoreModel(name: "The Upkeep Shoppe",
//                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
//                        distance: 1,
//                        image: "https://www.mallcribbs.com/images/storeprofile/store-image/store-image-regis-salon",
//                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
//        SalonStoreModel(name: "The Upkeep Shoppe",
//                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
//                        distance: 1.1,
//                        image: "http://www.cpp-luxury.com/wp-content/uploads/2016/07/Harry-Winston-salon-store-Houston-at-River-Oaks-3.jpg",
//                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
//        SalonStoreModel(name: "The Upkeep Shoppe",
//                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
//                        distance: 1.3,
//                        image: "https://s-media-cache-ak0.pinimg.com/originals/64/fb/ee/64fbee1b276fcfcc1025144d9bd4e18b.jpg",
//                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
//        SalonStoreModel(name: "The Upkeep Shoppe",
//                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
//                        distance: 1.5,
//                        image: "https://s-media-cache-ak0.pinimg.com/originals/0d/b1/6d/0db16df7e8fdb33f28cd21e7ca461e4f.jpg",
//                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
//        SalonStoreModel(name: "The Upkeep Shoppe",
//                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
//                        distance: 2.1,
//                        image: "https://www.intelligentnutrients.com/media/extendware/ewimageopt/media/template/4d/7/where-to-buy-horst-and-friends-img.jpg",
//                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed.")
//    ]

    override func setLayoutPage() {
        super.setLayoutPage()

        titlePage = NSLocalizedString("home", comment: "")
        setTabbarIcon(icons: [ImageConstant.IconHome!, ImageConstant.IconOrderList!, ImageConstant.IconBooking!, ImageConstant.IconMenu!])
        overlayColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)

        getData()

        // Draw map view
        initMapView()

    }

    func getData() {
        let location = appDelegate?.currentLocation
//        let location = (lat: "1234", long: "12341234")
        if location != nil {
            self.showOverlayLoading()
            DispatchQueue.main.async {
                self.homeController.getStore(lat: location!.lat, long: location!.long, callback: { (salon, error) in
                    self.removeOverlayLoading()
                    if salon != nil {
                        print("Got data")
                        self.dataSource = salon!
                        self.createListDataSource()
                        self.insertMarkerToMap()
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

    /// create map view
    func initMapView() {

        // TODOs: get current location and load map
        //        let currentLocation = (UIApplication.shared.delegate as! AppDelegate).currentMyLocation
        let currentLocation = CLLocationCoordinate2D(latitude: 32.878626, longitude: -90.41112)

        let locationCamera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: 12)
        mapView = GMSMapView.map(withFrame: CGRect(x: ScreenSize.ScreenWidth*0.025,
                                                   y: ScreenSize.ScreenHeight*0.1,
                                                   width: ScreenSize.ScreenWidth*0.95, height: ScreenSize.ScreenHeight*0.5), camera: locationCamera)

        mapView.layer.cornerRadius = 10

        self.view.addSubview(mapView)
    }

    private func insertMarkerToMap() {

        // clear mapView data
        mapView.clear()

        var bounds = GMSCoordinateBounds()

//        let rect = CGRect(x: 0, y: 0, width: mapView.frame.width*0.15, height: mapView.frame.width*0.15)

        for itemData in self.dataSource {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(itemData.latitude), longitude: CLLocationDegrees(itemData.longitude))
            let itemMarker = GMSMarker(position: location)
            itemMarker.title = itemData.name

            // create marker view
//            let markerView = CustomMarkerMap(frame: rect)
//            itemMarker.iconView = markerView
            itemMarker.tracksViewChanges = true
            bounds = bounds.includingCoordinate(location)
            itemMarker.map = self.mapView
            dataMarker.append(itemMarker)
        }

        mapView.animate(with: GMSCameraUpdate.fit(bounds))
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
            let container = UIView(frame: CGRect(x: CGFloat(i)*itemWidth, y: 0, width: itemWidth, height: itemHeight))
            container.tag = i
            container.backgroundColor = .clear
            let tapStoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadStoreProduct(sender:)))
            container.isUserInteractionEnabled = true
            container.addGestureRecognizer(tapStoreRecognizer)

            loadDataSource(item: dataSource[i], container: container)
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

    // create data Source
    func loadDataSource(item: SalonStoreModel, container: UIView) {

        let shadowView = UIView(frame: CGRect(x: 3, y: 3, width: container.frame.width - 6, height: container.frame.height - 6))

        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 3
        shadowView.layer.shadowColor = ColorConstant.ShadowColor.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 3).cgPath

        let cardView = UIView(frame: CGRect(x: 0, y: 0, width: container.frame.width - 6, height: container.frame.height - 6))
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 3
        shadowView.addSubview(cardView)

        let imageStore = UIImageView(frame: CGRect(x: 0, y: 0, width: container.frame.width*0.45, height: container.frame.height*0.768))
        imageStore.kf.setImage(with: URL(string: item.image))

        let infodata = UITextView(frame: CGRect(x: container.frame.width*0.48, y: 0,
                                                width: container.frame.width*0.5, height: container.frame.height))
        infodata.isEditable = false
        infodata.isScrollEnabled = false
        infodata.text = item.address + "\n\n" + item.descriptionText
        infodata.font = UIFont.systemFont(ofSize: 14)
        infodata.backgroundColor = .clear

        let distanceIcon = UIImageView(frame: CGRect(x: container.frame.width*0.05, y: container.frame.height*0.8,
                                                width: container.frame.height*0.1, height: container.frame.height*0.1))
        distanceIcon.image = ImageConstant.IconNear?.withRenderingMode(.alwaysTemplate)
        distanceIcon.tintColor = ColorConstant.ButtonPrimary
        distanceIcon.contentMode = .scaleAspectFit

        let distanceData = UILabel(frame: CGRect(x: container.frame.width*0.12, y: container.frame.height*0.8, width: container.frame.width*0.32, height: container.frame.height*0.1))
        distanceData.text = "\(item.distance!) km"
        distanceData.adjustsFontSizeToFitWidth = true
        distanceData.textColor = ColorConstant.ButtonPrimary

        cardView.addSubview(imageStore)
        cardView.addSubview(infodata)
        cardView.addSubview(distanceData)
        cardView.addSubview(distanceIcon)
        container.addSubview(shadowView)
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
        self.dataMarker[currentIndex].icon = GMSMarker.markerImage(with: .green)
        self.dataMarker[currentIndex].map = self.mapView
        startX = scrollView.contentOffset.x
        startY = scrollView.contentOffset.y
        justScrollX = false
        justScrollY = false

    }
}
