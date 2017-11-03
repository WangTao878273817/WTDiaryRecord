//
//  EditInfoViewController.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/2.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class EditInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var titleStyleArray : Array<Any>  = Array.init()
    private var dataArray : Array<Any> = Array.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configViewController()
        self.configLetData()
        self.configVarData()
        
    }
    ///Config ViewController
    func configViewController(){
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    ///Config letData
    func configLetData(){
        
        let session1 :Array<(String,AccountInfoCellStyle)> = [("头像",AccountInfoCellStyle.Image),
                                                              ("名字",AccountInfoCellStyle.Text),
                                                              ("座右铭",AccountInfoCellStyle.Text)]
        titleStyleArray.append(session1)
        
        let session2 :Array<(String,AccountInfoCellStyle)> = [("修改密码",AccountInfoCellStyle.Nomal)]
        titleStyleArray.append(session2)
        
//        let session2 :Array<(String,AccountInfoCellStyle)> = [("启动密码",AccountInfoCellStyle.Switch),
//                                                              ("推送提醒",AccountInfoCellStyle.Switch)]
//        titleStyleArray.append(session2)
        
        let session3 :Array<(String,AccountInfoCellStyle)> = [("清理缓存",AccountInfoCellStyle.Text),
                                                              ("关于",AccountInfoCellStyle.Text),
                                                              ("去评论",AccountInfoCellStyle.Nomal)]
//        titleStyleArray.append(session3)
        
    }
    
    ///Config varData
    func configVarData(){
//        switch self.reloadIndex {
//        case 1:     /// reload session1
//            self.getShowDataToSession1()
//            break;
//        case 2:     /// reload session2
//            self.getShowDataToSession2()
//            break;
//        case 3:     /// reload session3
//            self.getShowDataToSession3()
//            break;
//        default:
//            self.getShowDataToSession1()
//            self.getShowDataToSession2()
//            self.getShowDataToSession3()
//            break
//        }
        
        let userModel : UserModel = Utils.getUserInfo()
        let session1 : Array<Any> = [["image":(userModel.imageUrl == nil ? "" : userModel.imageUrl)],
                                     ["detail":userModel.name],
                                     ["detail":userModel.name],
                                     ["":""]]
        
        
        if(self.dataArray.count>=1){
            self.dataArray.insert(session1, at: 0)
        }else{
            self.dataArray.append(session1)
        }
        
        if(self.dataArray.count == 1){
            let session2 : Array<Any> = [["":""]]
            self.dataArray.append(session2)
        }
        
        self.tableView.reloadData()
        
    }
    
    
    ///back
    @IBAction func backViewController(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - TableView Delegate And DataSouce
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return titleStyleArray.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sessionArray = titleStyleArray[section] as! Array<Any>
        return sessionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : AccountInfoTableViewCell?  = tableView.dequeueReusableCell(withIdentifier: "cell") as? AccountInfoTableViewCell
        if(cell == nil){
            cell = AccountInfoTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cells")
        }
        let sessionArray = self.titleStyleArray[indexPath.section] as! Array<Any>
        cell?.titleStyleInfo = sessionArray[indexPath.row] as! (String, AccountInfoCellStyle)
        let tagArray = self.dataArray[indexPath.section] as! Array<Any>
        cell?.dataDic = tagArray[indexPath.row] as! Dictionary<String,String>
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sessionArray = self.titleStyleArray[indexPath.section] as! Array<Any>
        let clickData = sessionArray[indexPath.row] as! (String,AccountInfoCellStyle)
        self.disposeClickWithString(title: clickData.0)
        
    }
    
    //MARK: -获取显示数据
    ///用户信息
    func getShowDataToSession1(){
        
        let userModel : UserModel = Utils.getUserInfo()
        let session1 : Array<Any> = [["image":(userModel.imageUrl == nil ? "" : userModel.imageUrl)],
                                     ["detail":userModel.name],
                                     ["detail":userModel.name]]
        if(self.dataArray.count>=1){
            self.dataArray.insert(session1, at: 0)
        }else{
            self.dataArray.append(session1)
        }
        
    }

    ///切换信息
    func getShowDataToSession2(){
        
        let session2 : Array<Any> = [["switch":"1"],
                                     ["switch":""]]
        if(self.dataArray.count>=2){
            self.dataArray.insert(session2, at: 1)
        }else{
            self.dataArray.append(session2)
        }
        
    }
    ///app信息
    func getShowDataToSession3(){
        let session3 : Array<Any> = [["detail":"33.2M"],
                                     ["detail":"1.01V"],
                                     ["":""]]
        if(self.dataArray.count>=3){
            self.dataArray.insert(session3, at: 2)
        }else{
            self.dataArray.append(session3)
        }
    }
    
    ///点击Cell处理
    func disposeClickWithString(title : String)
    {
        var editType : Int = 0
        if(title == "头像"){
            
            return
        }else if(title == "名字"){
            editType = 0
        }else if(title == "座右铭"){
            editType = 1
        }else if(title == "修改密码"){
            editType = 2
        }
        self.performSegue(withIdentifier: "EditInfoDetailIdentifler", sender: editType)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
