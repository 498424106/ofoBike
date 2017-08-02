//
//  InputController.swift
//  ofoBike
//
//  Created by 翟帅 on 2017/7/18.
//  Copyright © 2017年 翟帅. All rights reserved.
//手动输入车牌界面

import UIKit
import APNumberPad
import SwiftySound


class InputController: UIViewController, APNumberPadDelegate, UITextFieldDelegate {
    var isFlashOn = false
    var isVoiceOn = true
    let defaults = UserDefaults.standard

    
    
    
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var flashBtn: UIButton!
    
    @IBOutlet weak var voiceBtn: UIButton!
    
    @IBAction func goBtnTap(_ sender: UIButton) {
        checkPass()
    }
    
    @IBAction func flashBtnTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        if isFlashOn {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        }else{
            flashBtn.setImage(#imageLiteral(resourceName: "btn_torch_disable"), for: .normal)
        }
    }
    
    @IBAction func voiceBtnTap(_ sender: UIButton) {
        if isVoiceOn {
            voiceBtn.setImage(#imageLiteral(resourceName: "voice_close"), for: .normal)
            
            defaults.set(true, forKey: "isVoiceOn")
            
        }else{
            voiceBtn.setImage(#imageLiteral(resourceName: "voice_icon"), for: .normal)
            defaults.set(false, forKey: "isVoiceOn")

        }
        isVoiceOn = !isVoiceOn

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        inputTextField.layer.borderWidth = 2
//        inputTextField.layer.borderColor = UIColor.ofo.cgColor
        title = "车辆解锁"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫描用车", style: .plain, target: self, action: #selector(backToScan))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        //设置自定义键盘
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("确定", for: .normal) //设置数字键盘左下角的格子
        inputTextField.inputView = numberPad
        inputTextField.delegate = self
        
        goBtn.isEnabled = false

        //从defaults中获取上个界面对声音的设置，判断
//        if defaults.bool(forKey: "isVoiceOn"){
//            voiceBtn.setImage(#imageLiteral(resourceName: "voice_close"), for: .normal)
//            
//        }else{
//            voiceBtn.setImage(#imageLiteral(resourceName: "voice_icon"), for: .normal)
//            
//        }
        voiceBtnStatus(voiceBtn: voiceBtn, playSound: false)

        
        
        
        
    }
    //数字键盘左下角的点击事件
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        print("确定")
        
        checkPass()//网络请求
    }
    //对输入框输入内容长度进行限制
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newLength = text.characters.count + string.characters.count - range.length
        if newLength > 0 {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
            goBtn.backgroundColor = UIColor.ofo
            goBtn.isEnabled = true  //当输入框有输入时才能点击 button
        }
        else {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_unenable"), for: .normal)
            goBtn.backgroundColor = UIColor.groupTableViewBackground
            goBtn.isEnabled = false

        }
        return newLength <= 8
        
    }
    
    

    func backToScan() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var passArr : [String] = []
    
    func checkPass() {
        if !inputTextField.text!.isEmpty {
            let code = inputTextField.text!
            //网络请求
            networkHelper.getPass(code: code, completion: { (pass) in
                if let pass = pass {
                    self.passArr = pass.characters.map {
                        return $0.description // 格式转换，并返回
                    }
                    self.performSegue(withIdentifier: "showPassCode", sender: self)
                    //对请求出来的解锁码进行拆解，将“9999”转变为【“9”、“9”、“9”、“9”】
//                    destVC.passArr = pass.characters.map {
//                        return $0.description // 格式转换，并返回
//                    }
                }else{
                    print("查无此车")
                    self.performSegue(withIdentifier: "showErrorView", sender: self)
                }
            })
            
//            //输入不为空时才能跳转
//            performSegue(withIdentifier: "showErrorView", sender: self)
            
        }
    }

    
    // MARK: - Navigation

    //在这个里面尽量不要写关于逻辑的东西,只做值的传递
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPassCode" {//监视故事板中有拖线跳转的事件时，取identifier
            let destVC = segue.destination as! ShowPassCodeViewController
//            destVC.code = code
            destVC.passArr = self.passArr
        }
        
        
        
        
    }
    

}
