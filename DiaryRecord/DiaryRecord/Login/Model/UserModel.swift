//
//  UserModel.swift
//  DiaryRecord
//
//  Created by shoule on 2017/10/26.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    ///用户唯一ID
    public var objectId : String?
    ///用户名（昵称）
    public var name : String?
    ///用户的邮箱
    public var email : String?
    ///用户创建账户日期
    public var createDate :String?
    ///用户座右铭
    public var motto : String?
    ///用户头像地址
    public var imageUrl : String?
    
    override init() {
        super.init()
    }
    
    init(dic : Dictionary<String,String>?) {
        super.init()
        if (dic == nil || dic!.count < 1 )  {
            return
        }
        self.objectId=dic!["objectId"]
        self.name=dic!["name"]
        self.email=dic!["email"]
        self.createDate=dic!["createDate"]
        self.motto=dic!["motto"]
        self.imageUrl=dic!["imageUrl"]
    }
    
    init(bmobObject : BmobObject) {
        super.init()
        self.objectId=bmobObject.object(forKey: "objectId") as? String
        self.name=bmobObject.object(forKey: "name") as? String
        self.email=bmobObject.object(forKey: "email") as? String
        self.createDate=bmobObject.object(forKey: "createdAt") as? String
        self.motto=bmobObject.object(forKey: "motto") as? String
        self.imageUrl=bmobObject.object(forKey: "imageUrl") as? String
    }
    
    func getModelDictionary() -> Dictionary<String,String>!{
        var resultDic : Dictionary<String,String> = Dictionary.init()
        
        resultDic["objectId"]=self.objectId
        resultDic["name"]=self.name
        resultDic["email"]=self.email
        resultDic["createDate"]=self.createDate
        resultDic["motto"]=self.motto
        resultDic["imageUrl"]=self.imageUrl
        
        return resultDic
    }
}
