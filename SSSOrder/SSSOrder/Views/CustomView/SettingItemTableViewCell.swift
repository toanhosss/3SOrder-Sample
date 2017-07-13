//
//  SettingItemTableViewCell.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/29/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class SettingItemTableViewCell: UITableViewCell {

    var icon: UIImageView!
    var name: UILabel!
    var isLast = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.069

        icon = UIImageView(frame: CGRect(x: width*0.03, y: height*0.175, width: height*0.65, height: height*0.65))
        icon.backgroundColor = .clear

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.15, y: height*0.01, width: ScreenSize.ScreenWidth*0.66, height: height))
        name.font = UIFont.systemFont(ofSize: 16)

        let line = UIView(frame: CGRect(x: name.frame.origin.x, y: height - 0.5, width: ScreenSize.ScreenWidth - icon.frame.width, height: 1))
        line.backgroundColor = UIColor.hexStringToUIColor("#e0e0e0")

        contentView.addSubview(icon)
        contentView.addSubview(name)
        if !isLast {
            contentView.addSubview(line)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
