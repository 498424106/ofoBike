//
//  UIViewHeather.swift
//  ofoBike
//
//  Created by 翟帅 on 2017/7/19.
//  Copyright © 2017年 翟帅. All rights reserved.
//  拓展 UIView 的功能   拓展之后所有的属性都能在故事版中设置
import SwiftySound

extension UIView{//边框
    @IBInspectable var boarwith : CGFloat{
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor{//边框颜色
        get{
            return UIColor(cgColor: self.layer.backgroundColor!)
        }
        set{
            self.layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable var cornerRadius : CGFloat{//圆角
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
}
//让故事版可视化，即对上面设置的属性在故事版改变值时，可以跟其他系统属性一样，立即显示出来
@IBDesignable class MyPreviewTextField: UITextField{
    
}
@IBDesignable class MyPreviewButton: UIButton{
    
}

import AVFoundation
func turnTorch() {
    guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }//用打开摄像头权限的方式打开闪光灯
    if device.hasTorch && device.isTorchAvailable {
        try? device.lockForConfiguration()
        
        if device.torchMode == .off {
            device.torchMode = .on
        }else{
            device.torchMode = .off
        }
        
        device.unlockForConfiguration()
    }
}

//将声音按钮和播放声音关联，同时作用前后界面
func voiceBtnStatus (voiceBtn : UIButton, playSound : Bool){
    let defaults = UserDefaults.standard
    
    //从defaults中获取上个界面对声音的设置，判断
    if defaults.bool(forKey: "isVoiceOn"){
        voiceBtn.setImage(#imageLiteral(resourceName: "voice_close"), for: .normal)
        
    }else{
        if playSound {
            Sound.play(file: "上车前_LH.m4a")
        }
        voiceBtn.setImage(#imageLiteral(resourceName: "voice_icon"), for: .normal)

    }
}





