//
//  NotepadEditViewController.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/10.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadEditViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var nameTxf: UITextField!
    @IBOutlet weak var priSwitch: UISwitch!
    
    var notepadModel : NotepadModel = NotepadModel.init()
    
    let accManage : AccountDataManage = AccountDataManage.share
    let notManage : NotificationManager = NotificationManager.share
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configViewController()
    }

    ///初始化视图
    func configViewController(){
        
        self.nameTxf.text = self.notepadModel.notepadName
        self.priSwitch.isOn = (self.notepadModel.isPrivate == "1")
        
    }
    
    ///返回
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///保存
    @IBAction func savaBtnClick(_ sender: Any) {
        if(self.nameTxf.canResignFirstResponder){self.nameTxf.resignFirstResponder()}
        if(self.nameTxf.text == "" || self.nameTxf.text == nil){
            SVProgressHUD.showError(withStatus: "名称不能为空！")
        }else if(self.nameTxf.text!.characters.count > 8){
            SVProgressHUD.showError(withStatus: "名称最多8个字符！")
        }else{
            self.savaNotepadRequest()
        }
    }
    
    ///设置封面
    @IBAction func settingImageBtnClick(_ sender: Any) {
        if(self.nameTxf.canResignFirstResponder){self.nameTxf.resignFirstResponder()}
        self.createUpdateStyle()
    }
    
    ///删除日记
    @IBAction func delegateBtnClick(_ sender: Any) {
        
        if(self.nameTxf.canResignFirstResponder){self.nameTxf.resignFirstResponder()}
        Utils.showAlertView2(str: "删除后不可恢复？", vc: self) { (aa) in
            self.deleteNotepadRequest()
        }
    }
    
    ///键盘收起
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.canResignFirstResponder){textField.resignFirstResponder()}
        return true
    }
    
    //MARK: -上传封面
    func createUpdateStyle(){
        
        let alertController = UIAlertController.init(title: "请选择", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let action1 = UIAlertAction.init(title: "相机", style: UIAlertActionStyle.default) { (aa) in
            self.openCamera(type: UIImagePickerControllerSourceType.camera)
        }
        alertController.addAction(action1)
        let action2 = UIAlertAction.init(title: "相册", style: UIAlertActionStyle.default) { (aa) in
            self.openCamera(type: UIImagePickerControllerSourceType.photoLibrary)
        }
        alertController.addAction(action2)
        let action3 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.destructive, handler: nil)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: -调出相机获取相册
    func openCamera(type : UIImagePickerControllerSourceType){
        let imagePickerVC : UIImagePickerController = UIImagePickerController.init()
        imagePickerVC.sourceType = type
        imagePickerVC.delegate=self
        imagePickerVC.allowsEditing = true
        self.present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let images : UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        SVProgressHUD.show(withStatus: "上传中...")
        accManage.updateImageNotepad(image: images , notepadModel: self.notepadModel) { (isSuccess, reason) in
            if(isSuccess == true){
                let notModel = NotificationManagerModel.init(name: "NotepadViewController", tagArray: [1])
                self.notManage.postNotification(notModel: notModel)
                SVProgressHUD.showSuccess(withStatus: reason)
            }else{
                SVProgressHUD.showError(withStatus: reason)
            }
        }
    }
    
    ///删除日记本请求
    func deleteNotepadRequest(){
        SVProgressHUD.show(withStatus: "删除中...")
        accManage.deleteNotepad(notepadModel: self.notepadModel) { (isSuccess, reason) in
            if(isSuccess == true){
                SVProgressHUD.dismiss()
                let notModel1 = NotificationManagerModel.init(name: "NotepadViewController", tagArray: [1])
                let notModel2 = NotificationManagerModel.init(name: "AccountViewController", tagArray: [2])
                self.notManage.postNotification(array: [notModel1,notModel2])
                Utils.showAlertView(str: reason, vc: self, clickHandler: { (aa) in
                    for vc in (self.navigationController?.viewControllers)!{
                        if (vc is NotepadViewController){
                            self.navigationController?.popToViewController(vc, animated: true)
                            return
                        }
                    }
                })
            }else{
                SVProgressHUD.showError(withStatus: reason)
            }
        }
    }
    
    ///保存修改请求
    func savaNotepadRequest(){
        let editModel : NotepadModel = NotepadModel.init(notepadModel: self.notepadModel)
        editModel.notepadName = self.nameTxf.text
        editModel.isPrivate = (self.priSwitch.isOn ? "1" : "0")
        SVProgressHUD.show(withStatus: "加载中...")
        accManage.updateNotepad(notepadModel: editModel) { (isSuccess, reason) in
            if(isSuccess){
                self.notepadModel.notepadName = editModel.notepadName
                self.notepadModel.isPrivate = editModel.isPrivate
                let notModel1 = NotificationManagerModel.init(name: "NotepadViewController", tagArray: [1])
                let notModel2 = NotificationManagerModel.init(name: "NotepadDetailViewController", tagArray: [1])
                self.notManage.postNotification(array: [notModel1,notModel2])
                SVProgressHUD.dismiss()
                Utils.showAlertView(str: reason, vc: self, clickHandler: { (aa) in
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                SVProgressHUD.showError(withStatus: reason)
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
