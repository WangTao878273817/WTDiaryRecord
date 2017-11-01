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
                return Utils.getUserInfo()!
            }
            return _userModel!
        }
    }
    
    ///获取用户数量信息
    func getAccountInfo(complent :((Dictionary<String,String>) -> Void)!){
        
        var resultDic : Dictionary<String,String> = Dictionary.init()
        let group : DispatchGroup = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        group.setTarget(queue: queue)
        group.enter()
        queue.async {       ///请求日记数量
            let query : BmobQuery = BmobQuery.init(className: LIST_DIARYLIST)
            query.whereKey("userId", equalTo: Int(self.userModel.userId!))
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
            query.whereKey("userId", equalTo: Int(self.userModel.userId!))
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
            query.whereKey("userId", equalTo: Int(self.userModel.userId!))
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
}
