//
//  NotificationTableViewCell.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/26/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

protocol NotificationItemDelegate: class {
    func submitOrCancelOrder(item: NotificationModel, isAgree: Bool)
}

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

    weak var delegate: NotificationItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.1

//        backgroundCardView = UIView(frame: CGRect(x: 3, y: 3, width: width*0.975 - 6, height: height - 6))

//        backgroundCardView.backgroundColor = .white
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
//        backgroundCardView.addSubview(cardView)

        icon = UIImageView(frame: CGRect(x: ScreenSize.ScreenWidth*0.05, y: height*0.25, width: height*0.5, height: height*0.5))
        icon.contentMode = .scaleAspectFit

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.175, y: height*0.01, width: width*0.5, height: height*0.5))
        name.lineBreakMode = .byTruncatingTail
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textColor = ColorConstant.ButtonPrimary

        time = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.665, y: height*0.01, width: width*0.3, height: height*0.5))
        time.font = UIFont.systemFont(ofSize: 12)
        time.textAlignment = .right
        time.textColor = UIColor.lightGray

        lineView = UIView(frame: CGRect(x: 0, y: contentView.frame.height - 0.5, width: width, height: 0.5))
        lineView.backgroundColor = UIColor.lightGray
        contentView.addSubview(lineView)

        cardView.addSubview(icon)
        cardView.addSubview(name)
        cardView.addSubview(time)
        contentView.addSubview(cardView)
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
            self.contentView.backgroundColor = .white
//            self.backgroundColor = .white
        } else {
            cardView.backgroundColor = ColorConstant.NotificationNewColor
            self.contentView.backgroundColor = ColorConstant.NotificationNewColor
//            self.backgroundColor = ColorConstant.NotificationNewColor
        }
    }

    func updateContainNotification() {

        if actionView != nil {
            actionView!.removeFromSuperview()
            actionView = nil
        }

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.1

        if !isOrderConfirm {

//            backgroundCardView.frame.size = CGSize(width: width, height: height)
            cardView.frame.size = CGSize(width: width, height: height)
            lineView.frame = CGRect(x: 0, y: cardView.frame.height - 1, width: width, height: 1)

            createContent()

        } else {

//            backgroundCardView.frame.size = CGSize(width: width, height: height*1.5)
            cardView.frame.size = CGSize(width: width, height: height*1.5)
            lineView.frame = CGRect(x: 0, y: contentView.frame.height - 1, width: width, height: 1)

            createContent()

            actionView = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.175, y: height*0.95, width: ScreenSize.ScreenWidth*0.7, height: height*0.5))
            let confirmButton = UIButton(frame: CGRect(x: 0, y: height*0.05, width: actionView!.frame.width*0.3, height: height*0.4))
            confirmButton.setTitle("Agree", for: .normal)
            confirmButton.setTitleColor(.white, for: .normal)
            confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            confirmButton.backgroundColor = ColorConstant.ButtonPrimary
            confirmButton.layer.cornerRadius = height*0.2
            confirmButton.addTarget(self, action: #selector(confirmButtonClicked(sender:)), for: .touchUpInside)

            let cancelButton = UIButton(frame: CGRect(x: actionView!.frame.width*0.33, y: height*0.05, width: actionView!.frame.width*0.3, height: height*0.4))
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(ColorConstant.ButtonPrimary, for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            cancelButton.layer.borderColor = ColorConstant.ButtonPrimary.cgColor
            cancelButton.layer.borderWidth = 1
            cancelButton.layer.cornerRadius = height*0.2
            cancelButton.addTarget(self, action: #selector(cancelButtonClicked(sender:)), for: .touchUpInside)

            actionView!.addSubview(confirmButton)
            actionView!.addSubview(cancelButton)

            cardView.addSubview(actionView!)
        }
    }

    func createContent() {
        let width = ScreenSize.ScreenWidth*0.805
        let height = ScreenSize.ScreenHeight*0.045
        let content = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.175, y: ScreenSize.ScreenHeight*0.048, width: width, height: height))

        let priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width*0.2, height: height))
        priceLabel.text = "$\(self.data.price)"
        priceLabel.textColor = UIColor.hexStringToUIColor("#E57C27")
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)

        let stringContent = UILabel(frame: CGRect(x: width*0.2, y: 0, width: width*0.8, height: height))
        stringContent.text = self.data.getContentForNotification()
        stringContent.numberOfLines = 2
        stringContent.font = UIFont.systemFont(ofSize: 12)

        content.addSubview(priceLabel)
        content.addSubview(stringContent)

        self.cardView.addSubview(content)
    }

    // Mark: Handel Item button clicked
    @objc func confirmButtonClicked(sender: UIButton) {
        delegate?.submitOrCancelOrder(item: self.data, isAgree: true)
    }

    @objc func cancelButtonClicked(sender: UIButton) {
        delegate?.submitOrCancelOrder(item: self.data, isAgree: false)
    }
}
