//
//  SplashScreenViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        checkUserLoggedIn()

        indicatorView.startAnimating()
    }

    /// Override set layout page
    override func setLayoutPage() {
        super.customizeBackground()

        // set logo app
        let logo = UIImageView(frame: CGRect(x: ScreenSize.ScreenWidth*0.25, y: ScreenSize.ScreenHeight*0.1304, width: ScreenSize.ScreenWidth*0.5, height: ScreenSize.ScreenHeight*0.287856))
        logo.image = ImageConstant.AppLogo
        self.view.addSubview(logo)
    }

    func checkUserLoggedIn() {
        let user = UserDefaultUtils.getUser()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            if user != nil {
                self.performSegue(withIdentifier: SegueNameConstant.SplashToHome, sender: nil)
            } else {
                self.performSegue(withIdentifier: SegueNameConstant.SplashToLogin, sender: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
