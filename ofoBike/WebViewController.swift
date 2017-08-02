//
//  WebViewController.swift
//  ofoBike
//
//  Created by 翟帅 on 2017/7/10.
//  Copyright © 2017年 翟帅. All rights reserved.
//右上角网页

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
        self.title = "热门活动"
        let url = URL(string: "http://m.ofo.so/active.html")!
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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
