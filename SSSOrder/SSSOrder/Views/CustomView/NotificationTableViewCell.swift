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
    var layerNew: UIView!

    var data: NotificationModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.15

        backgroundCardView = UIView(frame: CGRect(x: width*0.025 + 3, y: 3, width: width*0.975 - 6, height: height - 6))

        backgroundCardView.backgroundColor = .white
        backgroundCardView.layer.cornerRadius = 3
        backgroundCardView.layer.shadowColor = ColorConstant.ShadowColor.cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowRadius = 3
        backgroundCardView.layer.shadowOpacity = 1
        backgroundCardView.layer.shadowPath = UIBezierPath(roundedRect: backgroundCardView.bounds, cornerRadius: 3).cgPath

        layerNew = UIView(frame: CGRect(x: 0, y: 0, width: width*0.975 - 6, height: height - 6))
        layerNew.layer.masksToBounds = true
        layerNew.layer.cornerRadius = 3
        layerNew.backgroundColor = .white
        backgroundCardView.addSubview(layerNew)

        let cardView = UIView(frame: CGRect(x: width*0.025, y: 0, width: width*0.955 - 6, height: height - 6))
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 3
        cardView.backgroundColor = .white
        backgroundCardView.addSubview(cardView)

        icon = UIImageView(frame: CGRect(x: width*0.05, y: height*0.325, width: height*0.35, height: height*0.35))
        icon.backgroundColor = .gray

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.35, y: height*0.01, width: width, height: height*0.5))
        name.lineBreakMode = .byTruncatingTail
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textColor = ColorConstant.ButtonPrimary

        time = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.35, y: height*0.51, width: width, height: height*0.45))
        time.font = UIFont.systemFont(ofSize: 14)

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

}
