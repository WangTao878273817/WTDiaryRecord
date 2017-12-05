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
    
    private override init(){}
    
    //MARK: - AccountViewController (用户中心)
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
    
    //MARK: - EditInfoViewController (编辑用户信息)
    
    ///上传头像
    func updateUserIcon(image : UIImage , complent : ((Bool,String) -> Void)!){
        
        if(image.size.width <= 0 || image.size.height<=0 ){
            complent(false,"上传失败！")
            return
        }
        
        let group : DispatchGroup = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        let updateData : Data = UIImagePNGRepresentation(image)!
        let nUserIcon : String = "\(arc4random()%9999)_\(self.userModel.email!)_userIcon.png"
        let bmobFile : BmobFile = BmobFile.init(fileName: nUserIcon, withFileData: updateData)
        group.enter()
        queue.async {
            bmobFile.saveInBackground { (isSuccess, errer) in
                if(isSuccess == true && errer == nil){
                    group.leave()
                }else{
                    complent(false,"修改头像失败！")
                }
                
            }
        }
        
        let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_USERLIST, objectId: self.userModel.objectId)
        
        group.notify(queue: queue) {
            change.setObject(bmobFile.url, forKey: "imageUrl")
            change.updateInBackground { (isSuccess, error) in
                if(isSuccess == true && error == nil){
                    self.deleteOldFile(fileUrl: self.userModel.imageUrl)
                    self.userModel.imageUrl = bmobFile.url
                    Utils.savaUserInfo(userModel: self.userModel)
                    self.batchUpdateDiary(keyStr: "userObjectId", objectStr: self.userModel.objectId!, paramDic: ["userImageUrl":bmobFile.url])
                    complent(true,"修改头像成功！")
                }else{
                    self.deleteOldFile(fileUrl: bmobFile.url)
                    complent(false,"修改头像失败！")
                }
                
            }
        }
    }
    
    
    
    //MARK: - EditInfoDetailViewController (编辑用户信息详情)

    ///修改名字
    func modifyUserName(newName : String , complent : ((Bool,String) -> Void)!){
        
        let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_USERLIST, objectId: self.userModel.objectId)
        change.setObject(newName, forKey: "name")
        change.updateInBackground { (isSuccess, error) in
            if(isSuccess == true && error == nil){
                self.userModel.name=newName
                Utils.savaUserInfo(userModel: self.userModel)
                self.batchUpdateDiary(keyStr: "userObjectId", objectStr: self.userModel.objectId!, paramDic: ["userName":newName])
                complent (true,"保存成功！")
            }else{
                complent (false,"保存失败！")
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
                complent (true,"保存成功！")
            }else{
                complent (false,"保存失败！")
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
                    complent(false,"原密码不正确！")
                }
            })
        }
        
        group.notify(queue: queue) {
            let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_USERLIST, objectId: self.userModel.objectId)
            change.setObject(newPwd, forKey: "password")
            change.updateInBackground { (isSuccess, error) in
                if(isSuccess == true && error == nil){
                    complent (true,"修改密码成功,请重新登录！")
                }else{
                    complent (false,"修改密码失败！")
                }
            }
        }
        
    }
    
    //MARK: - NotepadViewController (日记本)
    
    ///获取日记本
    func getNotepad(complent : ((Bool,String,Array<NotepadModel>) -> Void)!){
        
        let query : BmobQuery = BmobQuery.init(className: LIST_NOTEPADLIST)
        query.whereKey("userObjectId", equalTo: self.userModel.objectId)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground({ (array, error) in
            if(array != nil && array!.count > 0 && error == nil){
                var resultArray : Array<NotepadModel> = Array.init()
                for item in array!{
                    let newItem : BmobObject = item as! BmobObject
                    let model : NotepadModel = NotepadModel.init(bmobObject: newItem)
                    resultArray.append(model)
                }
                complent(true,"",resultArray)
            }else{
                complent(false,"您还没有创建过日记本！",Array.init())
            }
        })
        
    }
    
    //MARK: - NotepadDetailViewController  (日记本详情-列表)
    func getDiaryList(notepadModel : NotepadModel , complent : ((Bool,String,Array<DiaryModel>) -> Void)!){
        
        let query : BmobQuery = BmobQuery.init(className: LIST_DIARYLIST)
        query.whereKey("notepadObjectId", equalTo: notepadModel.objectId)
        query.order(byDescending: "createdAt")
        query.limit = 50
        query.findObjectsInBackground({ (array, error) in
            if(array != nil && array!.count > 0 && error == nil){
                var resultArray : Array<DiaryModel> = Array.init()
                for item in array! {
                    let newItem : BmobObject = item as! BmobObject
                    let model : DiaryModel = DiaryModel.init(bmobObject: newItem)
                    resultArray.append(model)
                }
                complent(true,"",resultArray)
            }else{
                complent(false,"没有日记",Array.init())
            }
        })
        
    }
    
    //MARK: - NotepadAddViewController  (添加日记本)
    
    ///添加日记本
    func addNotepad(notepadModel : NotepadModel , complent : ((Bool,String) -> Void)!){
    
        let object : BmobObject = BmobObject.init(className: LIST_NOTEPADLIST)
        object.setObject(self.userModel.objectId, forKey: "userObjectId")
        object.setObject(notepadModel.notepadName, forKey: "notepadName")
        object.setObject(notepadModel.isPrivate, forKey: "isPrivate")
        object.setObject(Utils.stringToDate(dateStr: notepadModel.endDate!), forKey: "endDate")
        object.setObject(notepadModel.imageUrl, forKey: "imageUrl")
        object.saveInBackground { (isSuccess, error) in
            if(isSuccess && error == nil){
                complent(true,"添加成功！")
            }else{
                complent(false,"添加失败！")
            }
        }
        
    }
    
    //MARK: - NotepadEditViewController (编辑日记本)
    
    ///删除日记本
    func deleteNotepad(notepadModel : NotepadModel , complent : ((Bool,String) -> Void)!){
        
        let group : DispatchGroup = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        group.enter()
        queue.async {
            
            let query : BmobQuery = BmobQuery.init(className: LIST_DIARYLIST)
            query.whereKey("notepadObjectId", equalTo: notepadModel.objectId)
            query.findObjectsInBackground({ (array, error) in
                if((array == nil || array!.count == 0) && error == nil){
                    group.leave()
                }else{
                    complent(false,"日记本没有日记才能删除！")
                }
            })
            
        }
        
        group.notify(queue: queue) {
            let object : BmobObject = BmobObject.init(outDataWithClassName: LIST_NOTEPADLIST, objectId: notepadModel.objectId)
            object.deleteInBackground({ (isSuccess, error) in
                if(isSuccess == true && error == nil){
                    complent(true,"删除日记本成功！")
                }else{
                    complent(false,"删除日记本失败！")
                }
            })
            
        }
    }
    
    ///修改日记本
    func updateNotepad(notepadModel : NotepadModel , complent : ((Bool,String) -> Void)!){
        
        let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_NOTEPADLIST, objectId: notepadModel.objectId)
        change.setObject(notepadModel.notepadName, forKey: "notepadName")
        change.setObject(notepadModel.isPrivate, forKey: "isPrivate")
        change.updateInBackground { (isSuccess, error) in
            if(isSuccess == true && error == nil){
                self.batchUpdateDiary(keyStr: "notepadObjectId", objectStr: notepadModel.objectId!, paramDic: ["notepadName":notepadModel.notepadName!,"isPrivate":notepadModel.isPrivate!])
                complent (true,"保存成功！")
            }else{
                complent (false,"保存失败！")
            }
        }
        
    }
    
    ///修改日记封面
    func updateImageNotepad(image : UIImage , notepadModel : NotepadModel , complent : ((Bool,String) -> Void)!){
        
        if(image.size.width <= 0 || image.size.height<=0 ){
            complent(false,"上传失败！")
            return
        }
        
        let group : DispatchGroup = DispatchGroup.init()
        let queue = DispatchQueue.global()
        
        let updateData : Data = UIImagePNGRepresentation(image)!
        let nNotepadImage : String = "\(arc4random()%9999)_\(self.userModel.email!)_notepadImage.png"
        let bmobFile : BmobFile = BmobFile.init(fileName: nNotepadImage, withFileData: updateData)
        group.enter()
        queue.async {
            bmobFile.saveInBackground { (isSuccess, errer) in
                if(isSuccess == true && errer == nil){
                    group.leave()
                }else{
                    complent(false,"上传失败！")
                }
            }
        }
        
        group.notify(queue: queue) {
            
            let change : BmobObject = BmobObject.init(outDataWithClassName: LIST_NOTEPADLIST, objectId: notepadModel.objectId)
            change.setObject(bmobFile.url, forKey: "imageUrl")
            change.updateInBackground { (isSuccess, error) in
                if(isSuccess == true && error == nil){
                    self.deleteOldFile(fileUrl: notepadModel.imageUrl)
                    complent(true,"修改封面成功！")
                }else{
                    self.deleteOldFile(fileUrl: bmobFile.url)
                    complent(false,"修改封面失败！")
                }
            }
        }
        
    }
    
    //MARK: -DiaryDetailViewController  （日记详情评论）
    
    ///获取评论列表
    func getCommentList(diaryObjectId : String , complent : ((Bool,String,Array<CommentModel>) -> Void)!){
        
        let query : BmobQuery = BmobQuery.init(className: LIST_NOTEPADLIST)
        query.whereKey("diaryObjectId", equalTo: diaryObjectId)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground({ (array, error) in
            if(array != nil && array!.count > 0 && error == nil){
                var resultArray : Array<CommentModel> = Array.init()
                for item in array!{
                    let newItem : BmobObject = item as! BmobObject
                    let model : CommentModel = CommentModel.init(bmobObject: newItem)
                    resultArray.append(model)
                }
                complent(true,"",resultArray)
            }else{
                complent(false,"暂无品论！",Array.init())
            }
        })
        
    }
    
    //MARK: - 公共方法（文件操作）
    
    ///删除旧文件
    func deleteOldFile(fileUrl : String?){
        if(fileUrl == nil || fileUrl == ""){ return }
        BmobFile.filesDeleteBatch(with: [fileUrl!]) { (fileArray, isSuccess, error) in
            if(isSuccess == true &&  error == nil ){
                print("删除文件成功！")
            }
        }
    }
    
    ///批量修改日记信息
    func batchUpdateDiary(keyStr : String , objectStr : String , paramDic : Dictionary<String,String>){
        let query : BmobQuery = BmobQuery.init(className: LIST_DIARYLIST)
        query.whereKey(keyStr, equalTo: objectStr)
        query.order(byDescending: "createdAt")
        query.limit = 50
        query.findObjectsInBackground({ (array, error) in
            if(array != nil && array!.count > 0 && error == nil){
                let batch : BmobObjectsBatch = BmobObjectsBatch.init()
                for item in array!{
                    let newItem : BmobObject = item as! BmobObject
                    batch.updateBmobObject(withClassName: LIST_DIARYLIST, objectId: (newItem.object(forKey: "objectId") as? String), parameters: paramDic)
                }
                batch.batchObjects(inBackground: { (array, error) in
                    if(array != nil && array!.count > 0 && error == nil) {print("批量修改日记成功")}
                })
               
            }
        })
        
    }
    
}
