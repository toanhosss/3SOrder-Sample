//
//  SplashScreenViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseController {

    var overlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     * Show Overlay loading view
     */
    func showOverlayLoading(_ indicatorViewStyle: UIActivityIndicatorViewStyle = .whiteLarge) {
        if overlayView != nil {
            return
        }
        overlayView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
        overlayView.backgroundColor = .white
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: overlayView.bounds.width*0.1, height: overlayView.bounds.width*0.1)
        activityIndicator.activityIndicatorViewStyle = indicatorViewStyle
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(activityIndicator)
        self.view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    
    /*
     * Remove Overlay loading view
     */
    func removeOverlayLoading() {
        if overlayView == nil {
            return
        }
        
        self.overlayView.removeFromSuperview()
        self.overlayView = nil
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
