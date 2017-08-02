//
//  ErrorViewController.swift
//  ofoBike
//
//  Created by 翟帅 on 2017/7/22.
//  Copyright © 2017年 翟帅. All rights reserved.
//

import UIKit
import MIBlurPopup

class ErrorViewController: UIViewController {

    @IBAction func closeGestureTap(_ sender: UITapGestureRecognizer) {
        close()
    }
    
    @IBOutlet weak var errorView: UIView!
    
    @IBAction func closeBtnTap(_ sender: UIButton) {
        close()
    }

    func close() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//遵守协议
extension ErrorViewController : MIBlurPopupDelegate {
    var popupView : UIView {
        return errorView
    }
    var blurEffectStyle : UIBlurEffectStyle {
        return .dark
    }
    var initialScaleAmmount : CGFloat {
        return 0.2
    }
    var animationDuration : TimeInterval {
        return 0.2
    }
    
    
    
}









