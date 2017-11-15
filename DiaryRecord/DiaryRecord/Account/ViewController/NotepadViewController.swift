//
//  NotepadViewController.swift
//  DiaryRecord
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var notepadModelArray : Array<NotepadModel> = Array.init()
    
    let notManage : NotificationManager = NotificationManager.share
    let accManage : AccountDataManage = AccountDataManage.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configViewCotroller()
        self.getNotepadRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.popRefresh()
    }
    
    ///设置页面
    func configViewCotroller(){
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    ///返回按钮
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UICollectionView Delegate And DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notepadModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifyStr : String = "NotepadCell"
        let cell : NotepadCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifyStr, for: indexPath) as! NotepadCollectionViewCell
        let notepadModel : NotepadModel = self.notepadModelArray[indexPath.item]
        cell.layer.borderColor = UIColor.init(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1).cgColor
        cell.pageNameLab.text = notepadModel.notepadName
        if(notepadModel.imageUrl == nil || notepadModel.imageUrl == ""){
            cell.pageImage.image = UIImage.init(named: "account_notepad")
        }else{
            cell.pageImage.sd_setImage(with: URL.init(string: notepadModel.imageUrl!), placeholderImage: UIImage.init(named: "account_notepad"), completed: nil)
        }
        let dateStr : String = (Utils.judgeCurrutDateInTwoDate(startDateStr: notepadModel.createdDate!, endDateStr: notepadModel.endDate!) == true ? "未过期" : "已过期")
        let startStr : String = Utils.newStringDate(dateStr: notepadModel.createdDate!, format: "yyyy-MM-dd")
        let endStr : String = Utils.newStringDate(dateStr: notepadModel.endDate!, format: "yyyy-MM-dd")
        cell.describeLab.text = "\(dateStr)\n\(startStr)至\(endStr)"
        cell.privateLab.isHidden = (notepadModel.isPrivate == "0")
        
        return cell
    }

    
    
    //MARK: - Request
    ///请求日记本
    func getNotepadRequest(){
        
        SVProgressHUD.show(withStatus: "加载中...")
        accManage.getNotepad { (isSuccess, reason, dataArray) in
            if(isSuccess == true){
                self.notepadModelArray = dataArray
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: reason)
            }
        }
        
    }
    
    ///返回刷新
    func popRefresh(){
        self.notManage.addObservers(vc: self) { (array) in
            for item in array {
                if(item == 1){
                    self.getNotepadRequest()
                }
            }
        }
    }
    
    ///跳转页面传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.destination is NotepadDetailViewController){
            let indexPaths =  self.collectionView.indexPathsForSelectedItems
            let indexPath : IndexPath = indexPaths![0]
            let tagVC = segue.destination as! NotepadDetailViewController
            tagVC.notepadModel = self.notepadModelArray[indexPath.item]
            
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
