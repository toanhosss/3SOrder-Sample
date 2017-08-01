//
//  NotificationItemViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/26/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class NotificationItemViewController: BaseController {

    var data: NotificationModel!

    override func setLayoutPage() {
        super.setLayoutPage()
        self.titlePage = data.notificationName
        self.backTitle = NSLocalizedString("back", comment: "")

        let content = UITextView(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.12, width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.5))
        content.isEditable = false
        content.text = data.content
        content.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(content)
    }
}
