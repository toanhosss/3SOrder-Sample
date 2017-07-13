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
    var rating: FloatRatingView!
    var morningTimeView: UIView!
    var afternoonTimeView: UIView!
    var amTime: [String] = [] {
        didSet {
            loadFreeTimeView(containView: morningTimeView, title: "Morning", listTime: amTime)
        }
    }
    var pmTime: [String] = [] {
        didSet {
            loadFreeTimeView(containView: afternoonTimeView, title: "Afternoon", listTime: pmTime)
        }
    }

    var backgroundCardView: UIView!
    var staff: StaffModel!
    var delegate: StaffItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.45

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

        // create header card view
        createHeaderItem(containview: cardView)

        let line = UIView(frame: CGRect(x: 0, y: height*0.35, width: width, height: 1))
        line.backgroundColor = ColorConstant.BackgroundColor
        cardView.addSubview(line)

        // create body card view
        createBodyItem(containView: cardView)

        contentView.addSubview(backgroundCardView)
    }

    func createHeaderItem(containview: UIView) {
        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.45
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height*0.3))

        avatar = UIImageView(frame: CGRect(x: width*0.025, y: height*0.03, width: height*0.24, height: height*0.24))
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        avatar.backgroundColor = .gray

        name = UILabel(frame: CGRect(x: width*0.3, y: height*0.03, width: width*0.5, height: height*0.12))
        name.font = UIFont.boldSystemFont(ofSize: 16)

        rating = FloatRatingView(frame: CGRect(x: width*0.3, y: height*0.15, width: width*0.25, height: height*0.1))
        rating.emptyImage = ImageConstant.IconStarEmpty?.withRenderingMode(.alwaysTemplate)
        rating.emptyImageTintColor = .lightGray
        rating.fullImage = ImageConstant.IconStarFull?.withRenderingMode(.alwaysTemplate)
        rating.fullImageTintColor = ColorConstant.BackgroundColor
        rating.maxRating = 5
        rating.minRating = 1
        rating.editable = false
        rating.floatRatings = true

        headerView.addSubview(avatar)
        headerView.addSubview(name)
        headerView.addSubview(rating)

        containview.addSubview(headerView)
    }

    func createBodyItem(containView: UIView) {
        let width = ScreenSize.ScreenWidth*0.98
        let height = ScreenSize.ScreenHeight*0.45
        let bodyView = UIView(frame: CGRect(x: 0, y: height*0.375, width: width, height: height*0.55))
        morningTimeView = UIView(frame: CGRect(x: width*0.025, y: 0, width: width, height: height*0.275))
        afternoonTimeView = UIView(frame: CGRect(x: width*0.025, y: height*0.2875, width: width, height: height*0.275))
        bodyView.addSubview(morningTimeView)
        bodyView.addSubview(afternoonTimeView)
        containView.addSubview(bodyView)
    }

    private func loadFreeTimeView(containView: UIView, title: String, listTime: [String]) {
        let width = containView.frame.width
        let height = containView.frame.height
        let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height*0.2))
        labelView.text = title
        labelView.font = UIFont.systemFont(ofSize: 12)
        containView.addSubview(labelView)

        let itemWidth = width*0.2
        let itemHeight = height*0.3
        let space: CGFloat = height*0.066
        let spaceW: CGFloat = width*0.033
        let top: CGFloat = height*0.2 + space
        var index = 0

        var count = listTime.count/4
        if listTime.count % 4 != 0 {
            count += 1
        }

        for i in 0..<count {
//            if i == 0 {
//                top = height*0.2 + space
//            } else {
//                top = 0
//            }

            for j in 0..<4 {

                if index >= listTime.count {
                    break
                }
                let buttonView = UIButton(frame: CGRect(x: CGFloat(j)*(itemWidth + spaceW), y: CGFloat(i)*(itemHeight + space) + top, width: itemWidth, height: itemHeight))
                buttonView.setTitle(listTime[index], for: .normal)
                buttonView.titleLabel?.textColor = .white
                buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                buttonView.layer.cornerRadius = buttonView.frame.height*0.1
                buttonView.backgroundColor = ColorConstant.ButtonPrimary
                buttonView.addTarget(self, action: #selector(timeButtonTouched(sender:)), for: .touchUpInside)
                containView.addSubview(buttonView)

                index += 1
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Handler Button touched
    @objc func timeButtonTouched(sender: UIButton) {
        self.delegate?.selectedTime(time: sender.titleLabel!.text!, staff: self.staff)
    }

}

protocol StaffItemDelegate: class {
    func selectedTime(time: String, staff: StaffModel)
}
