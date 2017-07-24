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
    var shareButton: UIButton!

    var backgroundCardView: UIView!

    var salonProduct: SalonProductModel!

    var isExisted = true {
        didSet {
            updateIcon()
        }
    }

    weak var delegate: ProductItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let heightTopView = ScreenSize.ScreenHeight*0.25
        let height = ScreenSize.ScreenHeight*0.26

        backgroundCardView = UIView(frame: CGRect(x: width*0.025 + 3, y: 3, width: width*0.975 - 6, height: height - 6))

        backgroundCardView.backgroundColor = .white
        backgroundCardView.layer.borderColor = UIColor.hexStringToUIColor("#DBDFE3", alpha: 0.3).cgColor
        backgroundCardView.layer.borderWidth = 1

        backgroundCardView.layer.cornerRadius = 3
        backgroundCardView.layer.shadowColor = ColorConstant.ShadowColor.cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backgroundCardView.layer.shadowRadius = 5
        backgroundCardView.layer.shadowOpacity = 12
        backgroundCardView.layer.shadowPath = UIBezierPath(roundedRect: backgroundCardView.bounds, cornerRadius: 5).cgPath

        let cardView = UIView(frame: CGRect(x: 0, y: 0, width: width*0.975 - 6, height: height - 6))
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 3
        backgroundCardView.addSubview(cardView)

        imageProduct = UIImageView(frame: CGRect(x: 0, y: 0, width: width*0.45, height: heightTopView))
        imageProduct.backgroundColor = UIColor.hexStringToUIColor("#8f8f8f")
        imageProduct.contentMode = .scaleAspectFill
        imageProduct.clipsToBounds = true

        nameLabel = UILabel(frame: CGRect(x: width*0.48, y: 0, width: width*0.475, height: heightTopView*0.35))
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)

        descriptionView = UITextView(frame: CGRect(x: nameLabel.frame.origin.x, y: heightTopView*0.37, width: nameLabel.frame.width, height: heightTopView*0.3))
        descriptionView.backgroundColor = .clear
        descriptionView.isEditable = false

        priceLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: heightTopView*0.62, width: nameLabel.frame.width*0.75, height: heightTopView*0.2))
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textAlignment = .left
        priceLabel.textColor = ColorConstant.ButtonPrimary

        durationLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: heightTopView*0.82, width: nameLabel.frame.width*0.75, height: heightTopView*0.2))
        durationLabel.font = UIFont.systemFont(ofSize: 12)

        addButton = UIButton(frame: CGRect(x: width*0.85, y: priceLabel.frame.origin.y + heightTopView*0.05, width: width*0.06, height: width*0.16))
        addButton.setImage(ImageConstant.IconAdd?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.contentMode = .scaleAspectFit
        addButton.tintColor = ColorConstant.ButtonPrimary
        addButton.addTarget(self, action: #selector(addButtonTouched(sender:)), for: .touchUpInside)
        addButton.imageView!.contentMode = .scaleAspectFit

//        let lineView = UIView(frame: CGRect(x: 0, y: heightTopView*1.1, width: width, height: 1))
//        lineView.backgroundColor = ColorConstant.BackgroundColor
//
//        shareButton = UIButton(frame: CGRect(x: width*0.03, y: height*0.85, width: width*0.08, height: width*0.05))
//        shareButton.setImage(ImageConstant.IconShare?.withRenderingMode(.alwaysTemplate), for: .normal)
//        shareButton.tintColor = ColorConstant.ButtonPrimary
//        shareButton.imageView!.contentMode = .scaleAspectFit
//        shareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: shareButton.frame.width*0.3)
//        shareButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: shareButton.frame.width*0.31, bottom: 0, right: shareButton.frame.width*0.6)
//        shareButton.setTitle("Share", for: .normal)

//        cardView.addSubview(lineView)
//        cardView.addSubview(shareButton)
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

    /// Update Icon when isExisted changed
    func updateIcon() {
        if self.isExisted {
            addButton.setImage(ImageConstant.IconRemove?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.contentMode = .scaleAspectFit
            addButton.tintColor = .red
            addButton.removeTarget(self, action: #selector(addButtonTouched(sender:)), for: .touchUpInside)
            addButton.addTarget(self, action: #selector(removeButtonTouched(sender:)), for: .touchUpInside)
        } else {
            addButton.setImage(ImageConstant.IconAdd?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.contentMode = .scaleAspectFit
            addButton.tintColor = ColorConstant.ButtonPrimary
            addButton.removeTarget(self, action: #selector(removeButtonTouched(sender:)), for: .touchUpInside)
            addButton.addTarget(self, action: #selector(addButtonTouched(sender:)), for: .touchUpInside)
        }
    }

    @objc func addButtonTouched(sender: UIButton) {
        self.delegate?.addProductData(data: salonProduct)
//        self.addButton.isHidden = true
        isExisted = true
    }

    @objc func removeButtonTouched(sender: UIButton) {
        self.delegate?.removeProductData(data: salonProduct)
        //        self.addButton.isHidden = true
        isExisted = false
    }

}

protocol ProductItemDelegate: class {
    func addProductData(data: SalonProductModel)
    func removeProductData(data: SalonProductModel)
}
