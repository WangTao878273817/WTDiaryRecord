//
//  NotepadAddViewController.swift
//  DiaryRecord
//
//  Created by Mac on 2017/11/8.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadAddViewController: UIViewController {

    @IBOutlet weak var nameTxf: UITextField!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var priSwitch: UISwitch!
    @IBOutlet weak var selectDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    
    let accManage : AccountDataManage = AccountDataManage.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configViewContrller()
    }

    ///设置视图
    func configViewContrller(){
        
        let pulsDate = Utils.getPlusDate(year: 0, month: 1, day: 0)
        self.dateBtn.setTitle(Utils.dateToString2(date: pulsDate), for: UIControlState.normal)
        self.selectDatePicker.minimumDate = pulsDate
        self.selectDatePicker.maximumDate = Utils.getPlusDate(year: 1, month: 0, day: 0)
        self.selectDatePicker.date = pulsDate
        if(self.nameTxf.canBecomeFirstResponder){self.nameTxf.becomeFirstResponder()}
        
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savaBtnClick(_ sender: Any) {
        if(self.nameTxf.text == "" || self.nameTxf.text == nil){
            SVProgressHUD.showError(withStatus: "名称不能为空！")
        }else if(self.nameTxf.text!.characters.count > 8){
            SVProgressHUD.showError(withStatus: "名称最多8个字符！")
        }else{
            SVProgressHUD.show(withStatus: "加载中...")

            accManage.addNotepad(notepadModel: self.getNotepadModel(), complent: { (isSuccess, reason) in
                if(isSuccess){
                    SVProgressHUD.dismiss()
                    Utils.showAlertView(str: reason, vc: self, clickHandler: { (aa) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    SVProgressHUD.showError(withStatus: reason)
                }
            })
        }
    }
    @IBAction func affirmBtnClick(_ sender: Any) {
        let selectDate = self.selectDatePicker.date
        self.dateBtn.setTitle(Utils.dateToString2(date: selectDate), for: UIControlState.normal)
        self.datePickerView.isHidden = true
    }
    @IBAction func cancleBtnClick(_ sender: Any) {
        self.datePickerView.isHidden = true
    }
    
    @IBAction func selectDateBtnClick(_ sender: Any) {
        if(self.nameTxf.canResignFirstResponder){self.nameTxf.resignFirstResponder()}
        if(self.datePickerView.isHidden == false){ return}
        self.datePickerView.isHidden = false
    }
    
    func getNotepadModel() ->NotepadModel {
        
        let notepadModel : NotepadModel = NotepadModel.init()
        notepadModel.notepadName = self.nameTxf.text
        notepadModel.isPrivate = (self.priSwitch.isOn ? "1" : "0")
        notepadModel.imageUrl = ""
        notepadModel.endDate = Utils.dateToString(date: self.selectDatePicker.date)
        return notepadModel
        
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
