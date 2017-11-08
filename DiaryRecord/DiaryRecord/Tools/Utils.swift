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
    
    ///String 转 Date
    static func stringToDate(dateStr : String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        return date!
        
    }
    
    ///Date 转 String
    static func dateToString(date : Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: date)
        return str
        
    }

    
    ///判断当前时间是否在两个时间中间
    static func judgeCurrutDateInTwoDate(startDateStr : String , endDateStr : String) -> Bool{
        
        let startDate = Utils.stringToDate(dateStr: startDateStr)
        let endDate = Utils.stringToDate(dateStr: endDateStr)
        let currutDate = Date.init()
        
        if(currutDate.compare(startDate) == ComparisonResult.orderedDescending && currutDate.compare(endDate) == ComparisonResult.orderedAscending){
            return true
        }
        return false
        
    }
    
    ///String类型时间取 年月日(yyyy-MM-dd)
    static func newStringDate(dateStr : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultStr = dateFormatter.string(from: date!)
        return resultStr
    }
    

    
    
}
