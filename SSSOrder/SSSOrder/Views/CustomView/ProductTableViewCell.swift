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

    var salonProduct: SalonProductModel!

    weak var delegate: ProductItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.24

        imageProduct = UIImageView(frame: CGRect(x: width*0.025, y: height*0.01, width: width*0.45, height: height*0.98))
        imageProduct.backgroundColor = .green

        nameLabel = UILabel(frame: CGRect(x: width*0.5, y: height*0.01, width: width*0.4, height: height*0.2))
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)

        descriptionView = UITextView(frame: CGRect(x: nameLabel.frame.origin.x, y: height*0.22, width: nameLabel.frame.width, height: height*0.4))
        descriptionView.textColor = .white
        descriptionView.backgroundColor = .clear
        descriptionView.layer.borderColor = UIColor.white.cgColor
        descriptionView.layer.borderWidth = 1
        descriptionView.isEditable = false

        priceLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: height*0.62, width: nameLabel.frame.width*0.75, height: height*0.2))
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textColor = ColorConstant.ButtonPrimary

        durationLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: height*0.82, width: nameLabel.frame.width*0.75, height: height*0.2))
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.textColor = .white

        addButton = UIButton(frame: CGRect(x: width*0.9, y: priceLabel.frame.origin.y + height*0.1, width: width*0.1, height: width*0.1))
        addButton.setImage(ImageConstant.IconBooking, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTouched(sender:)), for: .touchUpInside)
        addButton.imageView!.contentMode = .scaleAspectFit

        contentView.addSubview(imageProduct)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(addButton)
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

    @objc func addButtonTouched(sender: UIButton) {
        self.delegate?.addProductData(data: salonProduct)
        self.addButton.isHidden = true
    }

}

protocol ProductItemDelegate: class {
    func addProductData(data: SalonProductModel)
}
