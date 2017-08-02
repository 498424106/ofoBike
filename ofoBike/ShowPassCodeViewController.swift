//
//  ShowPassCodeViewController.swift
//  ofoBike
//
//  Created by 翟帅 on 2017/7/19.
//  Copyright © 2017年 翟帅. All rights reserved.
//

import UIKit
import SwiftyTimer
import SwiftySound

class ShowPassCodeViewController: UIViewController {
    @IBOutlet weak var label1st: MyPreviewTextField!
    
    @IBOutlet weak var label2nd: MyPreviewTextField!
    
    @IBOutlet weak var label3rd: MyPreviewTextField!
    
    @IBOutlet weak var label4th: MyPreviewTextField!
    
    var code = ""
    var passArr : [String] = []
//    {       //加括号就是属性监视器，监视属性的变化
//        willSet{
//            //即将发生变更之前，要做好的事情
//        }
//        didSet {//属性监视器，当发现有值发生变化，就刷新改变
//            self.label1st.text = passArr[0]
//            self.label2nd.text = passArr[1]
//            self.label3rd.text = passArr[2]
//            self.label4th.text = passArr[3]

//        }
    
//    }        //加{}号是观察
    let defaults = UserDefaults.standard

    
    
    
    @IBOutlet weak var torchBtn: UIButton!
    var isTorchOn = false
    
    @IBOutlet weak var VoiceBtn: UIButton!
    var isVoiceOn = true

    @IBAction func voiceBtnTap(_ sender: UIButton) {
        if isVoiceOn {
            VoiceBtn.setImage(#imageLiteral(resourceName: "voice_close"), for: .normal)
            defaults.set(true, forKey: "isVoiceOn")

        } else {
            VoiceBtn.setImage(#imageLiteral(resourceName: "voice_icon"), for: .normal)
            defaults.set(false, forKey: "isVoiceOn")
        }
        isVoiceOn = !isVoiceOn
        
    }
    
    @IBAction func torchBtnTap(_ sender: UIButton) {
        turnTorch()
        
        if isTorchOn {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_torch_disable"), for: .normal)
        } else {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        }
        isTorchOn = !isTorchOn
    }
    
    @IBOutlet weak var countDownLabel: UILabel!
    var remindSeconds = 121;
    
    
    @IBAction func reportBtnTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "解锁密码"

        //设置倒计时
        Timer.every(1) { (timer: Timer) in
            self.remindSeconds -= 1
//            print(self.remindSeconds)
            self.countDownLabel.text = self.remindSeconds.description
            if self.remindSeconds == 0{
                timer.invalidate()
            }
        }
        //从defaults中获取上个界面对声音的设置，判断
//        if defaults.bool(forKey: "isVoiceOn"){
//            VoiceBtn.setImage(#imageLiteral(resourceName: "voice_close"), for: .normal)
//
//        }else{
//            VoiceBtn.setImage(#imageLiteral(resourceName: "voice_icon"), for: .normal)
//            Sound.play(file: "上车前_LH.m4a")
//
//        }
        //UIViewHeather中写成方法
        voiceBtnStatus(voiceBtn: VoiceBtn, playSound: true)
        
        self.label1st.text = passArr[0]
        self.label2nd.text = passArr[1]
        self.label3rd.text = passArr[2]
        self.label4th.text = passArr[3]
        
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
