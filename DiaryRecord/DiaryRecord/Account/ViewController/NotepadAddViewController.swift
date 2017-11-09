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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savaBtnClick(_ sender: Any) {
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
