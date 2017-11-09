//
//  NotificationManager.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/6.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotificationManager: NSObject {
    
    static let share = NotificationManager.init()
    private var modelArray : Array<NotificationManagerModel> = Array.init()
    
    private override init(){}
    
    ///发送一条刷新通知
    func postNotification(name : String ,  array : Array<Int>){
        
        var isExist = false
        for model in self.modelArray {
            if(model.name == name){
                model.tagArray += array
                model.tagArray = self.deleteRepeat(array: model.tagArray)
                isExist = true
                break
            }
        }
        
        if(isExist == false){
            let model : NotificationManagerModel = NotificationManagerModel.init()
            model.name = name
            model.tagArray = array
            self.modelArray.append(model)
        }
    }
    
    ///发送多条刷新通知
    func postNotification(array : Array<(name : String ,  array : Array<Int>)>) {
        if(array.isEmpty || array.count <= 0 ){ return}
        for item in array{
            self.postNotification(name: item.name, array: item.array)
        }
        
    }
    
    ///接收通知
    func addObservers(vcName : String , complent : (Array<Int>)->Void){
        var index : (Bool,Int) = (false,0)
        for mo in self.modelArray {
            if(vcName == mo.name){
                index.0=true
                if(mo.tagArray.count>0){
                    complent(mo.tagArray)
                }
                continue
            }
            index.1 = index.1 + 1
        }
        
        if(index.0 == true){
            self.modelArray.remove(at: index.1)
        }
    }
    
    ///数组中剔除重复的元素
    private func deleteRepeat(array : Array<Int> ) -> Array<Int>{

        let setArray : NSSet = NSSet.init(array: array)
        return setArray.allObjects as! Array<Int>
    }
    
}

class NotificationManagerModel: NSObject {
    var name : String = ""
    var tagArray = Array<Int>.init()
}
