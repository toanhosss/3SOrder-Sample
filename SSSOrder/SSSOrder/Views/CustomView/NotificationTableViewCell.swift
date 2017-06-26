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

    var data: NotificationModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.15

        icon = UIImageView(frame: CGRect(x: width*0.025, y: height*0.25, width: height*0.5, height: height*0.5))
        icon.backgroundColor = .gray

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.35, y: height*0.01, width: width, height: height*0.5))
        name.lineBreakMode = .byTruncatingTail
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textColor = ColorConstant.ButtonPrimary

        time = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.35, y: height*0.51, width: width, height: height*0.45))
        time.textColor = .white
        time.font = UIFont.systemFont(ofSize: 14)

        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(time)

        contentView.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
