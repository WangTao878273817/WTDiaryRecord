//
//  EditInfoDetailViewController.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/3.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class EditInfoDetailViewController: UIViewController {
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTxf: UITextField!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var oldPwdTxf: UITextField!
    @IBOutlet weak var nPwdTxf: UITextField!
    @IBOutlet weak var mPwdTxf: UITextField!
    
    /// 修改类型 default 0 - 名字 ， 1 - 详情 ， 2 - 密码
    var editType : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configViewController()
        self.configData()
        
        print("y---\(self.nameView.frame.origin.y)")
    }
    
    ///config ViewController
    func configViewController(){
        
        var titleString : String = ""
        
        switch self.editType {
        case 1:
            titleString = "修改座右铭"
            self.detailView.isHidden = false
            break;
        case 2:
            titleString = "修改密码"
            self.pwdView.isHidden = false
            break;
        default:
            titleString = "修改名字"
            self.nameView.isHidden = false
            break
        }
        self.title = titleString
        
    }
    
    func configData(){
        
        let userModel : UserModel = Utils.getUserInfo()
        self.nameTxf.text = userModel.name
        self.detailTV.text = userModel.motto
        
    }
    
    ///MARK: -Btn click
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savabtnClick(_ sender: Any) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.editType = sender as! Int
        print("sender - \(String(describing: sender))")
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
