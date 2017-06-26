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

    var backgroundCardView: UIView!

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

        nameProduct = UILabel(frame: CGRect(x: width*0.025, y: 0, width: width*0.725, height: height*0.5))
        nameProduct.font = UIFont.boldSystemFont(ofSize: 15)

        priceLabel = UILabel(frame: CGRect(x: width*0.75, y: 0, width: width*0.25, height: height*0.5))
        priceLabel.textColor = ColorConstant.ButtonPrimary

        durationLabel = UILabel(frame: CGRect(x: width*0.025, y: height*0.5, width: width*0.725, height: height*0.5))

        removeButton = UIButton(frame: CGRect(x: width*0.8, y: height*0.55, width: height*0.35, height: height*0.35))
        removeButton.setImage(ImageConstant.IconDelete?.withRenderingMode(.alwaysTemplate), for: .normal)
        removeButton.tintColor = ColorConstant.ButtonPrimary
        removeButton.addTarget(self, action: #selector(removeItemTouched(sender:)), for: .touchUpInside)

        cardView.addSubview(nameProduct)
        cardView.addSubview(priceLabel)
        cardView.addSubview(durationLabel)
        cardView.addSubview(removeButton)
        contentView.addSubview(backgroundCardView)

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
