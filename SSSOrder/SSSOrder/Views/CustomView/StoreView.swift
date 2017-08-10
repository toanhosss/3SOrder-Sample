//
//  StoreView.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 8/10/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class StoreView: UIView {

    var itemModel: SalonStoreModel!

    init(frame: CGRect, storeModel: SalonStoreModel) {
        super.init(frame: frame)
        itemModel = storeModel
        loadDataSource(item: storeModel, container: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadDataSource(item: SalonStoreModel, container: UIView) {

        let shadowView = UIView(frame: CGRect(x: 3, y: 3, width: container.frame.width - 6, height: container.frame.height - 6))

        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = shadowView.frame.height*0.1
        shadowView.layer.shadowColor = ColorConstant.ShadowColor.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 3).cgPath

        let cardView = UIView(frame: CGRect(x: 0, y: 0, width: container.frame.width - 6, height: container.frame.height - 6))
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = cardView.frame.height*0.1
        shadowView.addSubview(cardView)

        let imageStore = UIImageView(frame: CGRect(x: 0.03*container.frame.width, y: container.frame.height*0.1, width: container.frame.height*0.5, height: container.frame.height*0.5))
        imageStore.setKingfisherImage(with: URL(string: item.image), placeholder: ImageConstant.IconNoImage)
        imageStore.layer.cornerRadius = imageStore.frame.height*0.1
        imageStore.clipsToBounds = true

        let nameLabel = UILabel(frame: CGRect(x: container.frame.width*0.3, y: container.frame.height*0.1,
                                              width: container.frame.width*0.48, height: container.frame.height*0.168))
        nameLabel.text = item.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.backgroundColor = .clear

        let phoneCallButton = UIButton(frame: CGRect(x: container.frame.width*0.9 - container.frame.height*0.12, y: container.frame.height*0.1, width: container.frame.height*0.2, height: container.frame.height*0.2))
        phoneCallButton.setImage(ImageConstant.IconPhoneNumber?.withRenderingMode(.alwaysTemplate), for: .normal)
        phoneCallButton.tintColor = ColorConstant.ButtonPrimary
        phoneCallButton.imageEdgeInsets = UIEdgeInsets(top: container.frame.height*0.05, left: container.frame.height*0.05, bottom: container.frame.height*0.05, right: container.frame.height*0.05)
        phoneCallButton.addTarget(self, action: #selector(makeAPhoneCall(sender:)), for: .touchUpInside)

        let descriptionLabel = UITextView(frame: CGRect(x: container.frame.width*0.3, y: container.frame.height*0.268,
                                                        width: container.frame.width*0.5, height: container.frame.height*0.332))
        descriptionLabel.text = item.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.backgroundColor = .clear

        let locationImage = UIImageView(frame: CGRect(x: container.frame.width*0.03, y: container.frame.height*0.7,
                                                      width: imageStore.frame.origin.y, height: container.frame.height*0.15))
        locationImage.image = ImageConstant.IconLocation?.withRenderingMode(.alwaysTemplate)
        locationImage.tintColor = .black
        locationImage.contentMode = .scaleAspectFit

        let infodata = UILabel(frame: CGRect(x: container.frame.width*0.1, y: container.frame.height*0.67, width: container.frame.width*0.6, height: container.frame.height*0.2))
        infodata.numberOfLines = 2
        infodata.text = item.address
        infodata.font = UIFont.systemFont(ofSize: 12)
        infodata.backgroundColor = .clear

        let distanceData = UILabel(frame: CGRect(x: container.frame.width*0.78, y: container.frame.height*0.7, width: container.frame.width*0.16, height: container.frame.height*0.15))
        distanceData.text = "\(item.distance!) km"
        distanceData.adjustsFontSizeToFitWidth = true
        distanceData.layer.masksToBounds = true
        distanceData.backgroundColor = UIColor.hexStringToUIColor("#A8B4C4")
        distanceData.layer.cornerRadius = distanceData.frame.height*0.2
        distanceData.textColor = .white

        cardView.addSubview(imageStore)
        cardView.addSubview(nameLabel)
        cardView.addSubview(locationImage)
        cardView.addSubview(infodata)
        cardView.addSubview(distanceData)
        cardView.addSubview(phoneCallButton)
        container.addSubview(shadowView)
    }

    @objc func makeAPhoneCall(sender: UIButton) {
        if let phoneNumber = itemModel.phoneNumber {
            guard let url = URL(string: URLConstant.actionPhoneCall + phoneNumber) else {
                return
            }
            UIApplication.shared.openURL(url)
        }
    }
}
