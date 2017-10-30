//
//  LoginViewController.swift
//  DiaryRecord
//
//  Created by shoule on 2017/10/25.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var nameTxf: UITextField!
    @IBOutlet weak var emailTxf: UITextField!
    @IBOutlet weak var pwdTxf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var switchBtn: UIButton!
    
    var isLoginView : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configController()
        
    }
    
    ///设置视图
    func configController(){
        
        self.navigationController?.isNavigationBarHidden = true
        let userModel = Utils.getUserInfo()
        if(userModel!.email != nil && userModel!.email != ""){
            self.performSegue(withIdentifier: "loginToHome2", sender: "selfs")
        }
        
    }

    @IBAction func switchLoginStaut(_ sender: Any) {
        
        isLoginView = !isLoginView
        self.inputViewStartAnimation(isLogin: isLoginView)
        
    }
    @IBAction func loginBtnClick(_ sender: Any) {
        
        self.cancleFristResponse()
        
        let inputResult = self.judgeInput()
        if(inputResult?.0 == false){
            SVProgressHUD.showError(withStatus: inputResult?.1)
            return
        }
        SVProgressHUD.show(withStatus: "加载中...")
        if(isLoginView){
            self.login()
        }else{
            self.regist()
        }
        
    }
    
    
    // MARK: - Login And Regist
    func login(){
        
        let ldManage = LoginDataManage.shared
        ldManage.loginQuery(email:self.emailTxf.text! , pwd: self.pwdTxf.text!) { (isSuccess, msg) in
            if(isSuccess){
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginToHome", sender: "selfs")
            }else{
                SVProgressHUD.showError(withStatus: msg)
            }
        }
        
    }
    func regist(){
        
        let ldManage = LoginDataManage.shared
        ldManage.registInstall(name: self.nameTxf.text!, email: self.emailTxf.text!, pwd: self.pwdTxf.text!) { (isSuccess, msg) in
            if(isSuccess){
                SVProgressHUD.showSuccess(withStatus: msg)
            }else{
                SVProgressHUD.showError(withStatus: msg)
            }
        }
        
    }
    
    ///判读输入是否正确
    func judgeInput() -> (Bool,String)!{
        
        if(self.isLoginView == false && self.nameTxf.text == ""){
            return (false,"名字不能为空")
        }
        
        if(self.emailTxf.text == ""){
            return (false,"邮箱不能为空")
        }
        
        if(self.pwdTxf.text == ""){
            return (false,"密码不能为空")
        }
        
        return (true,"success")
    }
    
    ///取消第一相应
    func cancleFristResponse() {
        
        self.nameTxf.resignFirstResponder()
        self.emailTxf.resignFirstResponder()
        self.pwdTxf.resignFirstResponder()
        
    }
    
    
    //MARK: - Animation
    func inputViewStartAnimation(isLogin : Bool) {
        
        UIView.animate(withDuration: 0.3) {
            var bgViewRect : CGRect = self.textBgView.frame;
            bgViewRect.size.height=(isLogin ? 100 : 150)
            self.textBgView.frame=bgViewRect
            self.textView.frame=CGRect.init(x: 0, y: (isLogin ? 0 : 50), width: 300, height: 100)

            bgViewRect=self.loginButton.frame
            bgViewRect.origin.y=(isLogin ? bgViewRect.origin.y-50 : bgViewRect.origin.y+50)
            self.loginButton.frame=bgViewRect

            bgViewRect =  self.switchBtn.frame
            bgViewRect.origin.y=(isLogin ? bgViewRect.origin.y-50 : bgViewRect.origin.y+50)
            self.switchBtn.frame=bgViewRect
        }
        self.titleLab.text=(isLogin ? "欢迎来到日记记录" : "注册日记记录账号")
        self.loginButton.setTitle((isLogin ? "登录" : "注册"), for: UIControlState.normal)
        self.switchBtn.setTitle((isLogin ? "没有账号？注册一个" : "已有账号？马上登录"), for: UIControlState.normal)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
