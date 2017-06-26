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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.15

        avatar = UIImageView(frame: CGRect(x: width*0.025, y: height*0.01, width: height*0.98, height: height*0.98))
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        avatar.backgroundColor = .gray

        name = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.4, y: height*0.01, width: ScreenSize.ScreenWidth*0.5, height: height*0.5))
        name.font = UIFont.boldSystemFont(ofSize: 16)

        contentView.addSubview(avatar)
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
