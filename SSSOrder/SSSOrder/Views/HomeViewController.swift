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

    var dataSource: [SalonStoreModel] = [
        SalonStoreModel(name: "The Upkeep Shoppe",
                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
                        image: "https://www.mallcribbs.com/images/storeprofile/store-image/store-image-regis-salon",
                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
        SalonStoreModel(name: "The Upkeep Shoppe",
                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
                        image: "http://www.cpp-luxury.com/wp-content/uploads/2016/07/Harry-Winston-salon-store-Houston-at-River-Oaks-3.jpg",
                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
        SalonStoreModel(name: "The Upkeep Shoppe",
                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
                        image: "https://s-media-cache-ak0.pinimg.com/originals/64/fb/ee/64fbee1b276fcfcc1025144d9bd4e18b.jpg",
                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
        SalonStoreModel(name: "The Upkeep Shoppe",
                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
                        image: "https://s-media-cache-ak0.pinimg.com/originals/0d/b1/6d/0db16df7e8fdb33f28cd21e7ca461e4f.jpg",
                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed."),
        SalonStoreModel(name: "The Upkeep Shoppe",
                        address: "358 Preston Street Ottawa, ON K1S 4M6 (613) 695-9100",
                        image: "https://www.intelligentnutrients.com/media/extendware/ewimageopt/media/template/4d/7/where-to-buy-horst-and-friends-img.jpg",
                        description: "Open Hour: Mon-Fri 10am-8pm, Sat 1pm-8pm, Sun Closed.")
    ]

    override func setLayoutPage() {
        super.setLayoutPage()

        titlePage = NSLocalizedString("home", comment: "")
        setTabbarIcon(icons: [ImageConstant.IconHome!, ImageConstant.IconOrderList!, ImageConstant.IconBooking!, ImageConstant.IconMenu!])
        // Draw map view
        initMapView()

        // Dwaw list
        createListDataSource()
    }

    /// create map view
    func initMapView() {

        // TODOs: get current location and load map
        //        let currentLocation = (UIApplication.shared.delegate as! AppDelegate).currentMyLocation
        let currentLocation = CLLocationCoordinate2D(latitude: 32.878626, longitude: -90.41112)

        let locationCamera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: 6)
        mapView = GMSMapView.map(withFrame: CGRect(x: ScreenSize.ScreenWidth*0.025,
                                                   y: self.navigationController!.navigationBar.frame.height + 30,
                                                   width: ScreenSize.ScreenWidth*0.95, height: ScreenSize.ScreenHeight*0.45), camera: locationCamera)

        mapView.layer.cornerRadius = 10

        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }

        self.view.addSubview(mapView)
    }

    /// create PageView List
    func createListDataSource() {

        listItemView = UIScrollView(frame: CGRect(x: ScreenSize.ScreenWidth*0.025, y: ScreenSize.ScreenHeight*0.58, width: ScreenSize.ScreenWidth*0.95, height: ScreenSize.ScreenHeight*0.3))
        listItemView.isScrollEnabled = true
        listItemView.isPagingEnabled = true
        listItemView.delegate = self

        listItemView.contentSize = CGSize(width: ScreenSize.ScreenWidth*0.95*CGFloat(dataSource.count), height: ScreenSize.ScreenHeight*0.3)
        let itemWidth = ScreenSize.ScreenWidth*0.95
        let itemHeight = ScreenSize.ScreenHeight*0.3
        for i in 0..<dataSource.count {
            let container = UIView(frame: CGRect(x: CGFloat(i)*itemWidth, y: 0, width: itemWidth, height: itemHeight))
            container.tag = i
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.white.cgColor
            let tapStoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadStoreProduct(sender:)))
            container.isUserInteractionEnabled = true
            container.addGestureRecognizer(tapStoreRecognizer)

            loadDataSource(item: dataSource[i], container: container)
            listItemView.addSubview(container)
        }

        // Draw page control
        pageControl = UIPageControl(frame: CGRect(x: ScreenSize.ScreenWidth*0.25, y: ScreenSize.ScreenHeight*0.869, width: ScreenSize.ScreenWidth*0.5, height: ScreenSize.ScreenHeight*0.06))
        pageControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        pageControl.numberOfPages = dataSource.count
        pageControl.currentPage = 0

        self.view.addSubview(listItemView)
        self.view.addSubview(pageControl)
    }

    // create data Source
    func loadDataSource(item: SalonStoreModel, container: UIView) {

        let imageStore = UIImageView(frame: CGRect(x: container.frame.width*0.02,
                                                   y: container.frame.height*0.02,
                                                   width: container.frame.width*0.5, height: container.frame.height*0.8))
        imageStore.kf.setImage(with: URL(string: item.image))

        let infodata = UITextView(frame: CGRect(x: container.frame.width*0.55, y: imageStore.frame.origin.y,
                                                width: container.frame.width*0.42, height: container.frame.height*0.42))
        infodata.isEditable = false
        infodata.text = item.address
        infodata.textColor = .white
        infodata.backgroundColor = .clear
        infodata.layer.borderWidth = 1
        infodata.layer.borderColor = UIColor.white.cgColor

        let descriptionData = UITextView(frame: CGRect(x: container.frame.width*0.55, y: container.frame.height*0.5,
                                                width: container.frame.width*0.42, height: container.frame.height*0.38))
        descriptionData.isEditable = false
        descriptionData.text = item.descriptionText
        descriptionData.textColor = .white
        descriptionData.backgroundColor = .clear
        descriptionData.layer.borderWidth = 1
        descriptionData.layer.borderColor = UIColor.white.cgColor

        container.addSubview(imageStore)
        container.addSubview(infodata)
        container.addSubview(descriptionData)
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
        startX = scrollView.contentOffset.x
        startY = scrollView.contentOffset.y
        justScrollX = false
        justScrollY = false

    }
}
