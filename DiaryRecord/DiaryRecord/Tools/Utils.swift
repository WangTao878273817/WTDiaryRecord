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
    
    ///Date 转 String(yyyy年MM月dd日)
    static func dateToString2(date : Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd"
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
    
    ///String类型时间取 自定义获取类型(yyyy-MM-dd)
    static func newStringDate(dateStr : String , format : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = format
        let resultStr = dateFormatter.string(from: date!)
        return resultStr
    }
    
    //获取当前时间加 x年x月x日 后的时间
    static func getPlusDate(year : Int , month : Int , day : Int) -> Date{
        
        let calendar : Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        var com = DateComponents.init()
        com.year = year
        com.month = month
        com.day = day
        let resultDate = calendar.date(byAdding: com, to: Date.init())
        return resultDate!
        
    }
    
    ///无条件弹窗
    static func showAlertView(str : String , vc : UIViewController , clickHandler : @escaping (UIAlertAction) -> Void){
        
        let alertController : UIAlertController = UIAlertController.init(title: "提示", message: str, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: clickHandler))
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
    ///弹窗 (红色确定，执行操作)
    static func showAlertView2(str : String , vc : UIViewController , redClickHandler : @escaping (UIAlertAction) -> Void){
        
        let alertController : UIAlertController = UIAlertController.init(title: "提示", message: str, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive, handler: redClickHandler))
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
    ///计算文本高度 （宽度固定）
    static func calculateTextHeight (text :String? , width : CGFloat , font : UIFont) -> CGFloat {
        
        if(text == nil || text == ""){return 20.0}
        let newText : NSString = text! as NSString
        let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect =  newText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil);
        return (rect.height < 20.0 ? 20.0 : rect.height)
    }
    
    ///计算图片高度
    static func calculateImageSize(diaryModel : DiaryModel) -> CGSize {
        
        if(diaryModel.imageUrl == nil || diaryModel.imageUrl == "" ){
            return CGSize.init(width: 0, height: 0)
        }
        let width : CGFloat = SCREEN_WIDTH * 0.6
        let oldImageWith : CGFloat = CGFloat.init(Double(diaryModel.imageWidth!)!)
        let oldImageHeight : CGFloat = CGFloat.init(Double(diaryModel.imageHeight!)!)
        if(oldImageWith < width){
            return CGSize.init(width: oldImageWith, height: oldImageHeight)
        }
        let newImageHeight = oldImageHeight/oldImageWith*width
        return CGSize.init(width: width, height: newImageHeight)
        
    }

    
}
