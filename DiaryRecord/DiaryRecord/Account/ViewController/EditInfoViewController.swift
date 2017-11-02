//
//  EditInfoViewController.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/2.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class EditInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    
    
    ///back
    @IBAction func backViewController(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - TableView Delegate And DataSouce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : AccountInfoTableViewCell?  = tableView.dequeueReusableCell(withIdentifier: "cell") as? AccountInfoTableViewCell
        if(cell == nil){
            cell = AccountInfoTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cells")
        }
        cell?.cellStyle = AccountInfoCellStyle.Text
        cell?.dataDic = ["111":"11111"]
        
        return cell!
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
