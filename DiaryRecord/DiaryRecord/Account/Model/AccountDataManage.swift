//
//  AccountDataManage.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/1.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class AccountDataManage: NSObject {
    static let share = AccountDataManage.init()
    var _userModel : UserModel?
    var userModel : UserModel! {
        set{
            _userModel=userModel
        }
        get{
             if(_userModel == nil || _userModel?.email == ""){
                _userModel = Utils.getUserInfo()!
            }
            return _userModel!
        }
    }
    
    //MARK: - AccountViewController
    ///获取用户数量信息
    func getAccountInfo(complent :((Dictionary<String,String>) -> Void)!){
        
        var resultDic : Dictionary<String,String> = Dictionary.init()
        let group : DispatchGroup = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        group.setTarget(queue: queue)
        group.enter()
        queue.async {       ///请求日记数量
            let query : BmobQuery = BmobQuery.init(className: LIST_DIARYLIST)
            query.whereKey("objectId", equalTo: Int(self.userModel.objectId!))
            query .findObjectsInBackground { (array, error) in
                if(array != nil && error == nil ){
                    resultDic["diaryCount"]="\(array!.count)"
                }else{
                   resultDic["diaryCount"]="0"
                }
                group.leave()
            }
        }
        
        group.setTarget(queue: queue)
        group.enter()
        queue.async {       ///请求日记本数量
            let query : BmobQuery = BmobQuery.init(className: LIST_NOTEPADLIST)
            query.whereKey("objectId", equalTo: Int(self.userModel.objectId!))
            query .findObjectsInBackground { (array, error) in
                if(array != nil && error == nil ){
                    resultDic["notepadCount"]="\(array!.count)"
                }else{
                    resultDic["notepadCount"]="0"
                }
                group.leave()
            }
        }
        
        group.setTarget(queue: queue)
        group.enter()
        queue.async {       ///请求关注数量
            let query : BmobQuery = BmobQuery.init(className: LIST_CONCERNLIST)
            query.whereKey("objectId", equalTo: Int(self.userModel.objectId!))
            query .findObjectsInBackground { (array, error) in
                if(array != nil && error == nil ){
                    resultDic["concernCount"]="\(array!.count)"
                }else{
                    resultDic["concernCount"]="0"
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            complent(resultDic)
        }
        
    }
    
    ///上传文件（测试头像上传）
    func updateUserIcon(){
        
        let updateData : Data = UIImagePNGRepresentation(UIImage.init(named: "account_default_icon")!)!
        let bmobFile : BmobFile = BmobFile.init(fileName: "user.png", withFileData: updateData)
        bmobFile.saveInBackground { (isSuccess, errer) in
            
            print("staut-\(isSuccess)---url-\(bmobFile.url)")
            
        }
        
    }
    
    //MARK: - EditInfoDetailViewController
    ///修改名字
    func modifyUserName(newName : String , complent : ((Bool,String) -> Void)!){
        
        let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_USERLIST, objectId: self.userModel.objectId)
        change.setObject(newName, forKey: "name")
        change.updateInBackground { (isSuccess, error) in
            if(isSuccess == true && error == nil){
                self.userModel.name=newName
                Utils.savaUserInfo(userModel: self.userModel)
                complent (true,"修改成功")
            }else{
                complent (false,"修改姓名失败")
            }
        }
        
    }
    
    ///修改座右铭
    func modifyUserMotto(newMotto : String , complent : ((Bool,String) -> Void)!){
        
        let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_USERLIST, objectId: self.userModel.objectId)
        change.setObject(newMotto, forKey: "motto")
        change.updateInBackground { (isSuccess, error) in
            if(isSuccess == true && error == nil){
                self.userModel.motto=newMotto
                Utils.savaUserInfo(userModel: self.userModel)
                complent (true,"修改成功")
            }else{
                complent (false,"修改座右铭失败")
            }
        }
        
    }
    
    ///修改密码
    func modifyUserPwd(oldPwd : String, newPwd : String , complent : ((Bool,String) -> Void)!){
        
        let group : DispatchGroup = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        group.enter()
        queue.async {
            let query : BmobQuery = BmobQuery.init(className: LIST_USERLIST)
            query.whereKey("objectId", equalTo: self.userModel.objectId)
            query.whereKey("email", equalTo: self.userModel.email)
            query.whereKey("password", equalTo: oldPwd)
            query.findObjectsInBackground({ (array, error) in
                if(array != nil && array!.count > 0 && error == nil){
                    group.leave()
                }else{
                    complent(false,"原密码不正确")
                }
            })
        }
        
        group.notify(queue: queue) {
            let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_USERLIST, objectId: self.userModel.objectId)
            change.setObject(newPwd, forKey: "password")
            change.updateInBackground { (isSuccess, error) in
                if(isSuccess == true && error == nil){
                    complent (true,"修改密码成功,请重新登录")
                }else{
                    complent (false,"修改密码失败")
                }
            }
        }
        
    }
}
