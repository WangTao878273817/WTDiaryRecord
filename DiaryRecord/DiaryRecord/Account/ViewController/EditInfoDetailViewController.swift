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
    
    /// 修改类型 default 0 - 名字 ， 1 - 座右铭 ， 2 - 密码
    var editType : Int = 0
    var savaComplentHandler : () -> Void = { }
    let accManage = AccountDataManage.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configViewController()
        self.configData()
        
    }
    
    ///config ViewController
    func configViewController(){
        
        var titleString : String = ""
        
        switch self.editType {
        case 1:
            titleString = "修改座右铭"
            self.detailView.isHidden = false
            self.detailTV.becomeFirstResponder()
            break;
        case 2:
            titleString = "修改密码"
            self.pwdView.isHidden = false
            self.oldPwdTxf.becomeFirstResponder()
            break;
        default:
            titleString = "修改名字"
            self.nameView.isHidden = false
            self.nameTxf.becomeFirstResponder()
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

        let inputResult = self.inputJudge()
        if(inputResult.0 == false){
            SVProgressHUD.showError(withStatus: inputResult.1)
        }else{
            SVProgressHUD.show(withStatus: "加载中...")
            let complent : (Bool,String)->Void = { (isSuccess, reason) in
                if(isSuccess == false){
                    SVProgressHUD.showError(withStatus: reason)
                }else{
                    SVProgressHUD.dismiss()
                    self.modifySuccessAlert(str: reason)
                }
            }
            switch self.editType {
            case 1: //座右铭判断
                accManage.modifyUserMotto(newMotto: self.detailTV.text, complent: complent)
                break
            case 2:
                accManage.modifyUserPwd(oldPwd: self.oldPwdTxf.text!, newPwd: self.mPwdTxf.text!, complent: complent)
                break
            default:
                accManage.modifyUserName(newName: self.nameTxf.text!, complent: complent)
                break
            }
            
        }
    }
    
    //MARK: - 输入判断
    func inputJudge() -> (Bool,String) {
        
        switch self.editType {
        case 1: //座右铭判断
            if(self.detailTV.text == "" || self.detailTV.text == nil){
                return (false,"座右铭不能为空！")
            }
            break
        case 2:
            if(self.oldPwdTxf.text == nil || self.oldPwdTxf.text == "" || self.nPwdTxf.text == nil || self.nPwdTxf.text == "" || self.mPwdTxf.text == nil || self.mPwdTxf.text == ""){
                return (false,"密码不能为空！")
            }else if(self.nPwdTxf.text != self.mPwdTxf.text){
                return (false,"两次密码输入不相同！")
            }
            
            break
        default:
            if(self.nameTxf.text == "" || self.nameTxf.text == nil){
                return (false,"姓名不能为空！")
            }else if(self.nameTxf.text!.characters.count > 8){
                return (false,"姓名最多8个字符！")
            }
            break
        }
        
        return (true,"")
        
    }
    
    ///修改成功弹窗
    func modifySuccessAlert(str : String){
        
        let alertController : UIAlertController = UIAlertController.init(title: "提示", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (aa) in
            
            if(self.editType == 2){
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
                self.savaComplentHandler()
            }
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    ///取消第一响应
    func resignFirst(){
        if(self.nameTxf.canResignFirstResponder) {self.nameTxf.resignFirstResponder()}
        if(self.detailTV.canResignFirstResponder) {self.detailTV.resignFirstResponder()}
        if(self.oldPwdTxf.canResignFirstResponder) {self.oldPwdTxf.resignFirstResponder()}
        if(self.nPwdTxf.canResignFirstResponder) {self.nPwdTxf.resignFirstResponder()}
        if(self.mPwdTxf.canResignFirstResponder) {self.mPwdTxf.resignFirstResponder()}
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
