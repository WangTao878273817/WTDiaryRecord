//
//  CommentModel.swift
//  DiaryRecord
//
//  Created by shoule on 2017/12/4.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class CommentModel: NSObject {
    ///评论的唯一ID
    public var objectId : String?
    ///所属用户的ID
    public var userObjectId : String?
    ///所属用户的名称
    public var userName : String?
    ///所属用户的头像地址
    public var userImageUrl : String?
    ///所属日记ID
    public var diaryObjectId : String?
    ///所属日记本名称
    public var detail : String?
    ///创建日期
    public var createdAt : String?
    
    override init() {
        super.init()
    }
    
    init(bmobObject : BmobObject) {
        super.init()
        self.objectId = bmobObject.object(forKey: "objectId") as? String
        self.userObjectId = bmobObject.object(forKey: "userObjectId") as? String
        self.userName = bmobObject.object(forKey: "userName") as? String
        self.userImageUrl = bmobObject.object(forKey: "userImageUrl") as? String
        self.diaryObjectId = bmobObject.object(forKey: "diaryObjectId") as? String
        self.detail = bmobObject.object(forKey: "detail") as? String
        self.createdAt = bmobObject.object(forKey: "createdAt") as? String
    }
    
}
