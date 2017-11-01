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
    
    
    func getAccountInfo(complent :((Dictionary<String,String>) -> Void)!){
        
        var resultDic : Dictionary<String,String> = Dictionary.init()
        let group : DispatchGroup = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        group.setTarget(queue: queue)
        group.enter()
        queue.async {       ///请求日记数量
            let query : BmobQuery = BmobQuery.init(className: LIST_DIARYLIST)
            query.whereKey("userId", equalTo: self.userModel.userId)
            query .findObjectsInBackground { (array, error) in
                if(array == nil && error == nil ){
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
            query.whereKey("userId", equalTo: self.userModel.userId)
            query .findObjectsInBackground { (array, error) in
                if(array == nil && error == nil ){
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
            query.whereKey("userId", equalTo: self.userModel.userId)
            query .findObjectsInBackground { (array, error) in
                if(array == nil && error == nil ){
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
    
}
