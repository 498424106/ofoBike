
//
//  NetWorkHelper.swift
//  ofoBike
//
//  Created by 翟帅 on 2017/7/22.
//  Copyright © 2017年 翟帅. All rights reserved.
//  leanClound云服务器
import AVOSCloud

struct networkHelper {
    
}

extension networkHelper{
    static func getPass(code: String, completion: @escaping (String?) -> Void) {
        let query = AVQuery(className: "code");
        query.whereKey("code", equalTo: code)
        query.getFirstObjectInBackground { (code, e) in
            if let e = e {
                print("出错", e.localizedDescription)
                completion(nil)
            }
            if let code = code, let pass = code["pass"] as? String {
                completion(pass)
            }
            
        }
    }
}


