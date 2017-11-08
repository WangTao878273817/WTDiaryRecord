//
//  NotepadModel.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/8.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadModel: NSObject {

    ///日记本唯一ID
    public var objectId : String?
    ///名称
    public var notepadName : String?
    ///是否为私有
    public var isPrivate : String?
    ///创建日期
    public var createdDate : String?
    ///封面图片地址
    public var imageUrl : String?
    ///过期时间
    public var endDate : String?
    
    override init() {
        super.init()
    }
    
    init(dic : Dictionary<String,String>?) {
        super.init()
        if (dic == nil || dic!.count < 1 )  {
            return
        }
        self.objectId=dic!["objectId"]
        self.notepadName=dic!["notepadName"]
        self.isPrivate=dic!["isPrivate"]
        self.createdDate=dic!["createdDate"]
        self.imageUrl=dic!["imageUrl"]
        self.endDate=dic!["endDate"]
    }
    
    init(bmobObject : BmobObject) {
        super.init()
        self.objectId=bmobObject.object(forKey: "objectId") as? String
        self.notepadName=bmobObject.object(forKey: "notepadName") as? String
        self.isPrivate=bmobObject.object(forKey: "isPrivate") as? String
        self.createdDate=bmobObject.object(forKey: "createdAt") as? String
        self.imageUrl=bmobObject.object(forKey: "imageUrl") as? String
        self.endDate=Utils.dateToString(date: (bmobObject.object(forKey: "endDate") as! Date))
    }
    
}
