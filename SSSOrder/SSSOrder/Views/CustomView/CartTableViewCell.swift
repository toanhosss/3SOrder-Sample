//
//  CartTableViewCell.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    var nameProduct: UILabel!
    var priceLabel: UILabel!
    var durationLabel: UILabel!
    var removeButton: UIButton!

    var itemData: SalonProductModel!

    weak var delegate: CartItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.2

        nameProduct = UILabel(frame: CGRect(x: width*0.025, y: height*0.01, width: width*0.75, height: height*0.5))
        nameProduct.textColor = .white
        priceLabel = UILabel(frame: CGRect(x: width*0.75, y: height*0.01, width: width*0.25, height: height*0.5))
        priceLabel.textColor = .white
        durationLabel = UILabel(frame: CGRect(x: width*0.025, y: height*0.5, width: width*0.75, height: height*0.5))
        durationLabel.textColor = .white

        removeButton = UIButton(frame: CGRect(x: width*0.85, y: height*0.55, width: height*0.35, height: height*0.35))
        removeButton.setImage(ImageConstant.IconDelete, for: .normal)
        removeButton.addTarget(self, action: #selector(removeItemTouched(sender:)), for: .touchUpInside)

        contentView.addSubview(nameProduct)
        contentView.addSubview(priceLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(removeButton)

        contentView.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
    }

    @objc func removeItemTouched(sender: UIButton) {
        self.delegate?.removeItem(data: itemData)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol CartItemDelegate: class {
    func removeItem(data: SalonProductModel)
}
