//
//  NotepadDetailViewController.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/10.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notepadModel : NotepadModel = NotepadModel.init()
    
    let notManage = NotificationManager.share
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configViewController()
        self.configViewControllerData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.popRefresh()
    }
    
    ///初始化视图
    func configViewController(){
        
        
    }
    
    ///设置数据
    func configViewControllerData(){
        
        self.title = self.notepadModel.notepadName
        
    }

    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingBtnClick(_ sender: Any) {
    }
    
    
    ///跳转页面传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.destination is NotepadEditViewController){
            let tagVC = segue.destination as! NotepadEditViewController
            tagVC.notepadModel = self.notepadModel
        }
    }
    
    ///返回刷新
    func popRefresh(){
        self.notManage.addObservers(vc: self) { (array) in
            for item in array {
                if(item == 1){
                    self.configViewControllerData()
                }
            }
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
