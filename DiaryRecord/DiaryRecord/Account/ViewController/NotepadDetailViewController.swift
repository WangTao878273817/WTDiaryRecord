//
//  NotepadDetailViewController.swift
//  DiaryRecord
//
//  Created by Mac on 2017/11/12.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var notepadModel : NotepadModel = NotepadModel.init()
    var dairyArrayList : Array<DiaryModel> = Array.init()
    
    let accManage = AccountDataManage.share
    let notManage = NotificationManager.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configViewControllerData()
        self.getDiaryListRequest();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.popRefresh()
        
    }
    
    //MARK: - TableView Delegate And DataSource
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.getHeaderView(section: section)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (section != 1 ? 30 : 0.1)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dairyArrayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model : DiaryModel = self.dairyArrayList[indexPath.section]
        let height = self.calculateCellHeight(model: model)
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : DiaryTableViewCell? = tableview .dequeueReusableCell(withIdentifier: "cells") as? DiaryTableViewCell
        if(cell == nil){
            cell = DiaryTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cells")
        }
        let model = self.dairyArrayList[indexPath.section]
        cell!.cellData = (DiaryTableViewCellStyle.List , model)
        
        return cell!
    }
    
    ///配置初始化数据
    func configViewControllerData(){
        
        self.title = "《\(self.notepadModel.notepadName!)》"
        
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///获取日记列表
    func getDiaryListRequest(){
        
        SVProgressHUD.show(withStatus: "加载中...")
        accManage.getDiaryList(notepadModel: self.notepadModel) { (isSuccess, reason, array) in
            if(isSuccess == true){
                self.dairyArrayList = array
                self.tableview.reloadData()
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: reason)
            }
        }
        
    }
    
    ///返回刷新
    func popRefresh(){
        notManage.addObservers(vc: self) { (array) in
            for item in array {
                if(item == 1){
                    self.configViewControllerData()
                }
            }
        }
    }
    
    ///跳转页面传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.destination is NotepadEditViewController){
            let tagVC = segue.destination as! NotepadEditViewController
            tagVC.notepadModel = self.notepadModel
            
        }
    }
    
    ///计算cell的高度 （list样式计算方式）
    func calculateCellHeight(model : DiaryModel) -> CGFloat {
        
        let topHeight : CGFloat = 40
        let detailHeight = Utils.calculateTextHeight(text: model.detail, width: SCREEN_WIDTH-40, font: UIFont.systemFont(ofSize: 15))
        let imageHeight = Utils.calculateImageSize(diaryModel: model).height
        var bootHeight : CGFloat = (model.commentNum == "0" || model.commentNum == nil || model.commentNum == "") ? 20 : 40
        bootHeight = (imageHeight == 0) ? bootHeight : bootHeight+10
        return CGFloat.init(topHeight + detailHeight + imageHeight + bootHeight)
    }
    
    ///需要显示的HeaderView
    func getHeaderView(section : Int) -> UIView {
        
        let bgView : UIView = UIView.init()
        bgView.backgroundColor = UIColor.groupTableViewBackground
        
        let dateLab : UILabel = UILabel.init()
        dateLab.frame = CGRect.init(x: 20, y: 0, width: SCREEN_WIDTH, height: 30)
        dateLab.text = "今天"
        dateLab.textColor = UIColor.darkGray
        dateLab.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(dateLab)
        
        return bgView
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
