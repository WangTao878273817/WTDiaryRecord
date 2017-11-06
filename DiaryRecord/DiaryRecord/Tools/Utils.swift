//
//  Utils.swift
//  DiaryRecord
//
//  Created by shoule on 2017/10/27.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class Utils: NSObject {

    ///保存用户信息（字典）
    static func savaUserInfo(dic : Dictionary<String,String>){
        
        USERDEFAUTS.set(dic, forKey: USERDEFAUTS_KEY_USERMODEL)
        USERDEFAUTS.synchronize()
        
    }
    
    ///保存用户信息（模型）
    static func savaUserInfo(userModel : UserModel){
        
        let dataDic : Dictionary<String,String>! = userModel.getModelDictionary()
        self.savaUserInfo(dic: dataDic)
        
    }
    
    ///获取保存的用户信息
    static func getUserInfo() -> UserModel! {
        
        let resultDic : Dictionary<String,String>? = USERDEFAUTS.object(forKey: USERDEFAUTS_KEY_USERMODEL) as? Dictionary<String, String>
        return UserModel.init(dic: resultDic)
        
    }
    

    
    
}
