//
//  NotificationTableViewCell.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/26/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    var icon: UIImageView!
    var name: UILabel!
    var time: UILabel!

    var backgroundCardView: UIView!
    var cardView: UIView!
    var lineView: UIView!

    var status: Bool = false {
        didSet {
            updatebackgroundColor()
        }
    }

    var isOrderConfirm: Bool = true {
        didSet {
            updateContainNotification()
        }
    }
    var actionView: UIView?

    var data: NotificationModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.1

        backgroundCardView = UIView(frame: CGRect(x: 3, y: 3, width: width*0.975 - 6, height: height - 6))

        backgroundCardView.backgroundColor = .white
//        backgroundCardView.layer.cornerRadius = 3
//        backgroundCardView.layer.shadowColor = ColorConstant.ShadowColor.cgColor
//        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        backgroundCardView.layer.shadowRadius = 3
//        backgroundCardView.layer.shadowOpacity = 1
//        backgroundCardView.layer.shadowPath = UIBezierPath(roundedRect: backgroundCardView.bounds, cornerRadius: 3).cgPath

//        layerNew = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        layerNew.layer.masksToBounds = true
//        layerNew.layer.cornerRadius = 3
//        layerNew.backgroundColor = .white
//        backgroundCardView.addSubview(layerNew)

        cardView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 3
        cardView.backgroundColor = .white
        backgroundCardView.addSubview(cardView)

        icon = UIImageView(frame: CGRect(x: ScreenSize.ScreenWidth*0.05, y: height*0.325, width: height*0.35, height: height*0.35))
        icon.backgroundColor = .gray

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.25, y: height*0.01, width: width, height: height*0.5))
        name.lineBreakMode = .byTruncatingTail
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textColor = ColorConstant.ButtonPrimary

        time = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.25, y: height*0.51, width: width, height: height*0.45))
        time.font = UIFont.systemFont(ofSize: 14)

        lineView = UIView(frame: CGRect(x: 0, y: cardView.frame.height - 0.5, width: width, height: 0.5))
        lineView.backgroundColor = UIColor.lightGray
        cardView.addSubview(lineView)

        cardView.addSubview(icon)
        cardView.addSubview(name)
        cardView.addSubview(time)
        contentView.addSubview(backgroundCardView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updatebackgroundColor() {
        if status {
            cardView.backgroundColor = .white
        } else {
            cardView.backgroundColor = ColorConstant.NotificationNewColor
        }
    }

    func updateContainNotification() {

        if actionView != nil {
            actionView!.removeFromSuperview()
            actionView = nil
        }

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.1

        if isOrderConfirm {

            backgroundCardView.frame.size = CGSize(width: width, height: height)
            cardView.frame.size = CGSize(width: width, height: height)
            lineView.frame = CGRect(x: 0, y: cardView.frame.height - 0.5, width: width, height: 0.5)

        } else {

            backgroundCardView.frame.size = CGSize(width: width, height: height*1.5)
            cardView.frame.size = CGSize(width: width, height: height*1.5)
            lineView.frame = CGRect(x: 0, y: cardView.frame.height - 0.5, width: width, height: 0.5)

            actionView = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.25, y: height, width: ScreenSize.ScreenWidth*0.73, height: height*0.5))
            let confirmButton = UIButton(frame: CGRect(x: 0, y: 0, width: actionView!.frame.width*0.5, height: height*0.5))
            confirmButton.setImage(ImageConstant.IconChecked!.withRenderingMode(.alwaysTemplate), for: .normal)
            confirmButton.setTitle("Confirm Order", for: .normal)
            confirmButton.imageEdgeInsets = UIEdgeInsets(top: height*0.0625, left: 0, bottom: height*0.0625, right: height*0.25)
            confirmButton.imageView?.contentMode = .scaleAspectFit
            confirmButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            confirmButton.setTitleColor(.black, for: .normal)
            confirmButton.titleLabel?.textAlignment = .left
            confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            confirmButton.tintColor = ColorConstant.ButtonPrimary

            let cancelButton = UIButton(frame: CGRect(x: actionView!.frame.width*0.5, y: 0, width: actionView!.frame.width*0.5, height: height*0.5))
            cancelButton.setImage(ImageConstant.IconClose!.withRenderingMode(.alwaysTemplate), for: .normal)
            cancelButton.imageView?.contentMode = .scaleAspectFit
            cancelButton.tintColor = ColorConstant.ButtonPrimary
            cancelButton.setTitle("Cancel Order", for: .normal)
            cancelButton.setTitleColor(.black, for: .normal)
            cancelButton.titleLabel?.textAlignment = .left
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            cancelButton.imageEdgeInsets = UIEdgeInsets(top: height*0.0625, left: 0, bottom: height*0.0625, right: height*0.25)
            cancelButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cancelButton.tintColor = ColorConstant.ButtonPrimary

            actionView!.addSubview(confirmButton)
            actionView!.addSubview(cancelButton)

            cardView.addSubview(actionView!)
        }
    }
}
