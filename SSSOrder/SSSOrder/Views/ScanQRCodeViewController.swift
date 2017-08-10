//
//  ScanQRCodeViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 7/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeViewController: BaseController {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView?

    var listOrderPopup: UIView?

    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]

    var orderListSubmit = [OrderModel]() // OrderList user selected for submit
    var orderListQRCode = [OrderModel]() // orderList Full From QR code

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    override func setLayoutPage() {
        super.setLayoutPage()

        titlePage = NSLocalizedString("ScanQRCode", comment: "")
        backTitle = NSLocalizedString("back", comment: "")
        overlayColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)

        setupScanLayer()

        view.bringSubview(toFront: navigationBarView!)
        view.backgroundColor = .black

    }

    func setupScanLayer() {

        // Initialize the captureSession object.
        captureSession = AVCaptureSession()

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)

        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = supportedCodeTypes
        } else {
            failed()
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        createQRFrameLayerBorder()

    }

    func createQRFrameLayerBorder() {

        if view.viewWithTag(111) != nil {
            view.viewWithTag(111)!.removeFromSuperview()
        }

        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            qrCodeFrameView.tag = 111
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    func callSubmitOrderList() {
        self.showOverlayLoading()
        DispatchQueue.main.async {
            OrderController.SharedInstance.checkInCheckoutOrder(listOrder: self.orderListSubmit) { (listOrder, error) in
                self.removeOverlayLoading()
                if error == nil {
                    if self.listOrderPopup != nil { self.listOrderPopup!.removeFromSuperview() }
//                    self.showInfoMessage(self.createMessageOrderSubmitted(listOrder: listOrder))
                    let orders = self.adjustDataListOrder(listOrder: listOrder)
                    self.createPopupShowListOrder(listOrder: orders, isReadOnly: true)
//                    self.restartScan()
                } else {
                    self.showErrorMessage(error!)
                    self.restartScan()
                }
            }
        }
    }

    func adjustDataListOrder(listOrder: [OrderModel]) -> [OrderModel] {

        for order in self.orderListQRCode {
            if listOrder.contains(where: { (item) -> Bool in
                return item.orderId == order.orderId
            }) == false {
                order.status = "Checked out"
            } else {
                order.status = listOrder.first(where: { (item) -> Bool in
                    return item.orderId == order.orderId
                })!.status
            }
        }

        return self.orderListQRCode
    }

    func createMessageOrderSubmitted(listOrder: [OrderModel]) -> String {

        var orderCheckIn = [Int]()
        var orderCheckOut = [Int]()
        var checkInSuccess = "Booking "
        var checkOutSuccess = "Booking "

        for item in self.orderListSubmit {
            for order in listOrder {
                if order.orderId == item.orderId {
                    if order.status == "Proccessing" {
                        orderCheckOut.append(order.orderId)
                    } else {
                        orderCheckIn.append(order.orderId)
                    }
                }
            }
        }

        for i in 0..<orderCheckIn.count {
            checkInSuccess += "#\(orderCheckIn[i])"
            if i != (orderCheckIn.count - 1) { checkInSuccess += ", " } else { checkInSuccess += " was checked in." }
        }

        for i in 0..<orderCheckOut.count {
            checkOutSuccess += "#\(orderCheckOut[i])"
            if i != (orderCheckOut.count - 1) { checkOutSuccess += ", " } else { checkOutSuccess += " was checked out." }
        }

        return "\(orderCheckIn.count > 0 ? checkInSuccess:"")\n\(orderCheckOut.count > 0 ? checkOutSuccess:"" )"
    }

    func restartScan() {
        self.orderListSubmit = []
        createQRFrameLayerBorder()
        captureSession.startRunning()
    }

    // MARK: Handler button clicked
    @objc func submitAllOrder(sender: UIButton) {
        if self.orderListSubmit.count <= 0 {
            self.showErrorMessage("You must have at least 1 booking to submit")
            return
        }

        callSubmitOrderList()
    }

    @objc func closePopup(sender: UIButton) {
        listOrderPopup!.removeFromSuperview()
        restartScan()
    }

    @objc func closeAndBackPopup(sender: UIButton) {
        listOrderPopup!.removeFromSuperview()
        _ = self.navigationController?.popViewController(animated: true)
    }

    @objc func addOrderToListSubmit(sender: OrderItemAddButton) {

        if !self.orderListSubmit.contains(sender.itemData) {
            self.orderListSubmit.append(sender.itemData)
            sender.setImage(ImageConstant.IconRemove?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor.hexStringToUIColor("#E57C27")
            sender.removeTarget(self, action: #selector(addOrderToListSubmit(sender:)), for: .touchUpInside)
            sender.addTarget(self, action: #selector(removeOrderFromListSubmit(sender:)), for: .touchUpInside)
        }
    }

    @objc func removeOrderFromListSubmit(sender: OrderItemAddButton) {

        let index = self.orderListSubmit.index(of: sender.itemData)
        if index != nil {
            self.orderListSubmit.remove(at: index!)
            sender.setImage(ImageConstant.IconAdd?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = ColorConstant.ButtonPrimary
            sender.removeTarget(self, action: #selector(removeOrderFromListSubmit(sender:)), for: .touchUpInside)
            sender.addTarget(self, action: #selector(addOrderToListSubmit(sender:)), for: .touchUpInside)
        }
    }
}

extension ScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No QR code is detected"
            return
        }

        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject
            if readableObject == nil {
                self.showErrorPopupScan(error: NSLocalizedString("Error cast ReadableObject", comment: ""))
                return
            }

            let barCodeObject = previewLayer?.transformedMetadataObject(for: readableObject)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject!.stringValue)
        }

//        dismiss(animated: true)
    }

    private func showErrorPopupScan(error: String) {
       let popup = PopupUtil.showInformationPopupWithOnlyOKButton("Error", message: error, actionConfirm: {
            self.captureSession.startRunning()
            if self.listOrderPopup != nil {
                self.listOrderPopup!.removeFromSuperview()
            }
            self.createQRFrameLayerBorder()
        })

        present(popup, animated: true, completion: nil)
    }

    func found(code: String) {
//        self.showInfoMessage(code)
        captureSession.stopRunning()
        if !code.contains(URLConstant.baseURL) {
            showErrorPopupScan(error: "QR code invalid.")
            return
        }
        URLConstant.qrUrl = code
        DispatchQueue.main.async {
            self.showOverlayLoading()
            OrderController.SharedInstance.getListOrderToday { (orderList, error) in
                self.removeOverlayLoading()
                if error != nil {
                    self.showErrorPopupScan(error: error!)
                } else {
                    self.orderListQRCode = orderList
                    if orderList.count > 1 {
                        self.createPopupShowListOrder(listOrder: orderList)
                    } else if orderList.count == 1 {
                        self.orderListSubmit.append(orderList[0])
                        self.callSubmitOrderList()
                    } else {
                        self.showErrorPopupScan(error: "You don't have any confirmed booking today.")
                    }
                }
            }
        }
    }

    func createPopupShowListOrder(listOrder: [OrderModel], isReadOnly: Bool = false) {
        listOrderPopup = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight))
        listOrderPopup!.backgroundColor = UIColor.hexStringToUIColor("#000000", alpha: 0.5)

        let height = ScreenSize.ScreenHeight*0.1
        let width = ScreenSize.ScreenWidth

        let bodyHeight = listOrder.count <= 3 ? height*1.5*CGFloat(listOrder.count):height*4

        let popupView = UIView(frame: CGRect(x: 0.1*width, y: ScreenSize.ScreenHeight*0.2, width: 0.8*width, height: height*2 + bodyHeight))
        popupView.backgroundColor = UIColor.white
        popupView.layer.cornerRadius = height*0.12
        popupView.clipsToBounds = true

        // init title popup
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 0.8*width, height: height))

        let popupLabel = UILabel(frame: CGRect(x: 0.05*titleView.frame.size.width, y: 0, width: 0.9*titleView.frame.size.width, height: height))
        popupLabel.textColor = .black
        popupLabel.text = "Booking List"
        popupLabel.font = UIFont.boldSystemFont(ofSize: 18)
        popupLabel.textAlignment = .center
        titleView.addSubview(popupLabel)

        popupView.addSubview(titleView)

        // init content
        let content = UIScrollView(frame: CGRect(x: 0, y: height, width: 0.8*width, height: height*4))
        content.contentSize = CGSize(width: 0.8*width, height: CGFloat(listOrder.count)*height*1.5)

        // Load content item
        for i in 0..<listOrder.count {
            content.addSubview(createOrderItemList(index: i, order: listOrder[i], isReadOnly: isReadOnly))
        }

        popupView.addSubview(content)

        let footerButtonView = UIView(frame: CGRect(x: 0, y: bodyHeight+height, width: popupView.frame.width, height: height))
        footerButtonView.backgroundColor = UIColor.lightGray
        popupView.addSubview(footerButtonView)
        if isReadOnly {
            let okButton = UIButton(frame: CGRect(x: 0, y: 1, width: width*0.8, height: height - 1))
            okButton.setTitle("OK", for: .normal)
            okButton.setTitleColor(ColorConstant.ButtonPrimary, for: .normal)
            okButton.backgroundColor = .white
            okButton.addTarget(self, action: #selector(closeAndBackPopup(sender:)), for: .touchUpInside)
            footerButtonView.addSubview(okButton)
        } else {
            let cancelButton = UIButton(frame: CGRect(x: 0, y: 1, width: width*0.4 - 0.5, height: height - 1))
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(ColorConstant.ButtonPrimary, for: .normal)
            cancelButton.backgroundColor = .white
            cancelButton.addTarget(self, action: #selector(closePopup(sender:)), for: .touchUpInside)
            footerButtonView.addSubview(cancelButton)

            let bookingButton = UIButton(frame: CGRect(x: width*0.4 + 1, y: 1, width: width*0.4 - 0.5, height: height - 1))
            bookingButton.setTitle("Submit", for: .normal)
            bookingButton.setTitleColor(ColorConstant.ButtonPrimary, for: .normal)
            bookingButton.backgroundColor = .white
            bookingButton.addTarget(self, action: #selector(submitAllOrder(sender:)), for: .touchUpInside)
            footerButtonView.addSubview(bookingButton)
        }
        listOrderPopup!.addSubview(popupView)
        self.view.addSubview(listOrderPopup!)
        self.view.bringSubview(toFront: listOrderPopup!)
    }

    func createOrderItemList(index: Int, order: OrderModel, isReadOnly: Bool = false) -> UIView {
        let height = ScreenSize.ScreenHeight*0.15
        let orderItemView = UIView(frame: CGRect(x: 0, y: CGFloat(index)*height, width: 0.8*ScreenSize.ScreenWidth, height: height))

        let widthInfoView = isReadOnly ? orderItemView.frame.width*0.9:orderItemView.frame.width*0.8

        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: widthInfoView, height: height))

        let orderNumber = UILabel(frame: CGRect(x: infoView.frame.width*0.1, y: 0, width: infoView.frame.width*0.6, height: height*0.35))
        orderNumber.font = UIFont.boldSystemFont(ofSize: 14)
        orderNumber.text = "Booking Number: \(order.orderId!)"
        let orderPrice = UILabel(frame: CGRect(x: infoView.frame.width*0.6, y: 0, width: infoView.frame.width*0.4, height: height*0.35))
        orderPrice.text = "$\(order.totalPrice)"
        orderPrice.textAlignment = .right
        orderPrice.font = UIFont.systemFont(ofSize: 14)

        let orderBookingDate = UILabel(frame: CGRect(x: infoView.frame.width*0.1, y: height*0.35, width: infoView.frame.width*0.6, height: height*0.5))
        let bookingDate = DateUtil.convertDateToFullLongDate(date: order.getDatefromBookingDate()!)
        orderBookingDate.text = "Booked on " + bookingDate + " \(order.timePickup)"
        orderBookingDate.numberOfLines = 2
        orderBookingDate.lineBreakMode = .byWordWrapping
        orderBookingDate.font = UIFont.systemFont(ofSize: 12)

        let orderStatus = UILabel(frame: CGRect(x: infoView.frame.width*0.6, y: height*0.35, width: infoView.frame.width*0.4, height: height*0.5))

        orderStatus.text = order.status
        if order.status == "Confirmed" {
            orderStatus.textColor = ColorConstant.OrderConfirm
        } else if order.status == "Proccessing" {
            orderStatus.textColor = ColorConstant.OrderProccessing
        } else {
            orderStatus.textColor = ColorConstant.OrderFinished
        }

        orderStatus.textAlignment = .right
        orderStatus.font = UIFont.boldSystemFont(ofSize: 11)

        infoView.addSubview(orderNumber)
        infoView.addSubview(orderPrice)
        infoView.addSubview(orderBookingDate)
        infoView.addSubview(orderStatus)

        if !isReadOnly {
            let selectButton = OrderItemAddButton(frame: CGRect(x: orderItemView.frame.width*0.8 + height*0.125, y: height*0.25, width: height*0.25, height: height*0.25))
            selectButton.itemData = order
            selectButton.setImage(ImageConstant.IconAdd?.withRenderingMode(.alwaysTemplate), for: .normal)
            selectButton.addTarget(self, action: #selector(addOrderToListSubmit(sender:)), for: .touchUpInside)
            selectButton.tintColor = ColorConstant.ButtonPrimary
            selectButton.contentMode = .scaleAspectFit
            orderItemView.addSubview(selectButton)
        }
        if index < self.orderListQRCode.count - 1 {
            let line = UIView(frame: CGRect(x: 0, y: height - 1, width: 0.8*ScreenSize.ScreenWidth, height: 1))
            line.backgroundColor = UIColor.lightGray
            orderItemView.addSubview(line)
        }
        orderItemView.addSubview(infoView)

        return orderItemView
    }
}

class OrderItemAddButton: UIButton {
    private var _data: OrderModel!

    var itemData: OrderModel {
        get {
            return _data
        }

        set {
            _data = newValue
        }
    }
}
