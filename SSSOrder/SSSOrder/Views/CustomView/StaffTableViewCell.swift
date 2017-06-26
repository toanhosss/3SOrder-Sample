//
//  StaffTableViewCell.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class StaffTableViewCell: UITableViewCell {

    var avatar: UIImageView!
    var name: UILabel!

    var backgroundCardView: UIView!

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

        let cardView = UIView(frame: CGRect(x: 0, y: 0, width: width*0.975 - 6, height: height - 6))
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 3
        backgroundCardView.addSubview(cardView)

        avatar = UIImageView(frame: CGRect(x: width*0.025, y: height*0.2, width: height*0.6, height: height*0.6))
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        avatar.backgroundColor = .gray

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.3, y: height*0.01, width: ScreenSize.ScreenWidth*0.5, height: height))
        name.font = UIFont.boldSystemFont(ofSize: 16)

        cardView.addSubview(avatar)
        cardView.addSubview(name)

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
