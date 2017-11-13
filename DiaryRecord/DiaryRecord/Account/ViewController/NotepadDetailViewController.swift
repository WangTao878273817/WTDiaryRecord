//
//  NotepadDetailViewController.swift
//  DiaryRecord
//
//  Created by Mac on 2017/11/12.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadDetailViewController: UIViewController {

    var notepadModel : NotepadModel = NotepadModel.init()
    var dairyArrayList = Array<Any>.init()
    
    let accManage = AccountDataManage.share
    let notManage = NotificationManager.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configViewControllerData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.popRefresh()
        
    }
    
    ///配置初始化数据
    func configViewControllerData(){
        
        self.title = "《\(self.notepadModel.notepadName!)》"
        
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
