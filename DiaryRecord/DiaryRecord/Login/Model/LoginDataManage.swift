//
//  LoginDataManage.swift
//  DiaryRecord
//
//  Created by shoule on 2017/10/26.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class LoginDataManage: NSObject {
    static let shared = LoginDataManage.init()
    
    private override init(){}
    
    ///注册
    func registInstall(name : String , email : String , pwd : String , complent : ((Bool,String)->Void)!){
        //查询邮箱是否存在
        let query : BmobQuery = BmobQuery.init(className: LIST_USERLIST)
        query.whereKey("email", equalTo: email)
        query .findObjectsInBackground { (array, error) in
            if((array == nil || array?.count == 0) && error == nil ){
                
                let object : BmobObject = BmobObject.init(className: LIST_USERLIST)
                object.setObject(name, forKey: "name")
                object.setObject(email, forKey: "email")
                object.setObject(pwd, forKey: "password")
                object.saveInBackground { (isSuccess, error) in
                    if(isSuccess && error == nil){
                        complent(true,"注册成功")
                    }else{
                        complent(false,"注册失败")
                    }
                }

            }else if(error != nil){
                complent(false,"网络异常")
            }else{
                complent(false,"邮箱已被注册")
            }
        }

    }
    
    ///登录
    func loginQuery(email : String , pwd : String , complent : ((Bool,String) -> Void)!) {
        let query : BmobQuery = BmobQuery.init(className: LIST_USERLIST)
        query.whereKey("email", equalTo: email)
        query.whereKey("password", equalTo: pwd)
        query .findObjectsInBackground { (array, error) in
            if(array != nil && array!.count > 0 && error == nil){
                complent(true,"登录成功")
                let objects : BmobObject = array![0] as! BmobObject
                let userModel : UserModel = UserModel.init(bmobObject: objects)
                Utils.savaUserInfo(dic: userModel.getModelDictionary())
            }else{
                complent(false,"登录失败")
            }
        }
    }
}
