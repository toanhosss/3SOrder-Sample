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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.1

        icon = UIImageView(frame: CGRect(x: width*0.01, y: height*0.2, width: height*0.6, height: height*0.6))
        icon.backgroundColor = .clear

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.2, y: height*0.01, width: ScreenSize.ScreenWidth*0.66, height: height))
        name.font = UIFont.boldSystemFont(ofSize: 16)

        contentView.addSubview(icon)
        contentView.addSubview(name)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
