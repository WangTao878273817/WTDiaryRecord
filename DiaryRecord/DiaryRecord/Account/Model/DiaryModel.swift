//
//  DiaryModel.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/13.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class DiaryModel: NSObject {
    ///日记唯一ID
    public var objectId : String?
    ///所属用户的ID
    public var userObjectId : String?
    ///所属用户的名称
    public var userName : String?
    ///所属用户的头像地址
    public var userImageUrl : String?
    ///所属日记本ID
    public var notepadObjectId : String?
    ///所属日记本名称
    public var notepadName : String?
    ///是否为私有
    public var isPrivate : String?
    ///评论列表个数
    public var commentNum : String?
    ///日记内容
    public var detail : String?
    ///图片地址
    public var imageUrl : String?
    ///图片地址的宽
    public var imageWidth : String?
    ///图片地址的高
    public var imageHeight : String?
    ///创建日期
    public var createdAt : String?
    
    
    override init() {
        super.init()
    }
    
    init(dic : Dictionary<String,String>?) {
        super.init()
        if (dic == nil || dic!.count < 1 )  {
            return
        }
        self.objectId = dic!["objectId"]
        self.userObjectId = dic!["userObjectId"]
        self.userName = dic!["userName"]
        self.userImageUrl = dic!["userImageUrl"]
        self.notepadObjectId = dic!["notepadObjectId"]
        self.notepadName = dic!["notepadName"]
        self.isPrivate = dic!["isPrivate"]
        self.commentNum = dic!["commentNum"]
        self.detail = dic!["detail"]
        self.imageUrl = dic!["imageUrl"]
        self.imageWidth = dic!["imageWidth"]
        self.imageHeight = dic!["imageHeight"]
        self.createdAt = dic!["createdAt"]
    }
    
    init(bmobObject : BmobObject) {
        super.init()
        self.objectId = bmobObject.object(forKey: "objectId") as? String
        self.userObjectId = bmobObject.object(forKey: "userObjectId") as? String
        self.userName = bmobObject.object(forKey: "userName") as? String
        self.userImageUrl = bmobObject.object(forKey: "userImageUrl") as? String
        self.notepadObjectId = bmobObject.object(forKey: "notepadObjectId") as? String
        self.notepadName = bmobObject.object(forKey: "notepadName") as? String
        self.isPrivate = bmobObject.object(forKey: "isPrivate") as? String
        self.commentNum = bmobObject.object(forKey: "commentNum") as? String
        self.detail = bmobObject.object(forKey: "detail") as? String
        self.imageUrl = bmobObject.object(forKey: "imageUrl") as? String
        self.imageWidth = bmobObject.object(forKey: "imageWidth") as? String
        self.imageHeight = bmobObject.object(forKey: "imageHeight") as? String
        self.createdAt = bmobObject.object(forKey: "createdAt") as? String
  
    }
    

}
