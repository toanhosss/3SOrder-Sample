//
//  ProductTableViewCell.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    var imageProduct: UIImageView!
    var nameLabel: UILabel!
    var descriptionView: UITextView!
    var priceLabel: UILabel!
    var durationLabel: UILabel!
    var addButton: UIButton!

    var backgroundCardView: UIView!

    var salonProduct: SalonProductModel!

    weak var delegate: ProductItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.25

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

        imageProduct = UIImageView(frame: CGRect(x: 0, y: 0, width: width*0.45, height: height))
        imageProduct.backgroundColor = .green
        imageProduct.contentMode = .scaleAspectFill
        imageProduct.clipsToBounds = true

        nameLabel = UILabel(frame: CGRect(x: width*0.48, y: 0, width: width*0.475, height: height*0.2))
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)

        descriptionView = UITextView(frame: CGRect(x: nameLabel.frame.origin.x, y: height*0.22, width: nameLabel.frame.width, height: height*0.4))
        descriptionView.backgroundColor = .clear
        descriptionView.isEditable = false

        priceLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: height*0.62, width: nameLabel.frame.width*0.75, height: height*0.2))
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textColor = ColorConstant.ButtonPrimary

        durationLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: height*0.82, width: nameLabel.frame.width*0.75, height: height*0.2))
        durationLabel.font = UIFont.systemFont(ofSize: 12)

        addButton = UIButton(frame: CGRect(x: width*0.85, y: priceLabel.frame.origin.y + height*0.1, width: width*0.1, height: width*0.1))
        addButton.setImage(ImageConstant.IconAdd?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.tintColor = ColorConstant.ButtonPrimary
        addButton.addTarget(self, action: #selector(addButtonTouched(sender:)), for: .touchUpInside)
        addButton.imageView!.contentMode = .scaleAspectFit

        cardView.addSubview(imageProduct)
        cardView.addSubview(nameLabel)
        cardView.addSubview(descriptionView)
        cardView.addSubview(priceLabel)
        cardView.addSubview(durationLabel)
        cardView.addSubview(addButton)
        contentView.addSubview(backgroundCardView)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func addButtonTouched(sender: UIButton) {
        self.delegate?.addProductData(data: salonProduct)
        self.addButton.isHidden = true
    }

}

protocol ProductItemDelegate: class {
    func addProductData(data: SalonProductModel)
}
