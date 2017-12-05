//
//  DiaryDetailViewController.swift
//  DiaryRecord
//
//  Created by Mac on 2017/11/20.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class DiaryDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var putView: UIView!
    @IBOutlet weak var putTxf: UITextField!
    
    let accManager : AccountDataManage = AccountDataManage.share
    
    var diaryModel : DiaryModel = DiaryModel.init()
    var commentArray : Array<CommentModel> = Array.init()
    var isMeDiary : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configViewController()
        self.addKeyBoardNotification()
    }
    
    ///configViewController
    func configViewController(){
        
        self.isMeDiary = (self.diaryModel.userObjectId == Utils.getUserInfo().objectId)
        
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag;
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.resignTxf))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        
    }

    //MARK: - TableView DataSource And Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){return 1}
        return self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){return 0.01}else{return 40}
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){return nil}
        return self.getSectionView(num: self.commentArray.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if(indexPath.row == 0){
            return self.calculateCellHeight(model: self.diaryModel)
        }else{
            let cModel = self.commentArray[indexPath.row]
            let textHeight = Utils.calculateTextHeight(text: cModel.detail, width: SCREEN_WIDTH-75, font: UIFont.systemFont(ofSize: 15))
            return (textHeight + 70)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0){
            let cell : DiaryTableViewCell = DiaryTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DiaryTableViewCell")
            cell.cellData = (DiaryTableViewCellStyle.Detail,self.diaryModel)
            return cell
        }else{
            var cell : CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell
            if(cell == nil){
                cell = CommentTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "CommentTableViewCell")
            }
            let cModel : CommentModel = self.commentArray[indexPath.row]
            cell!.commentData = (cModel,self.isMeDiary)
            
            return cell!
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreBtnClick(_ sender: Any) {
        print("click more")
    }
    @IBAction func addComment(_ sender: Any) {
    }
    
    ///计算cell的高度 （Detail样式计算方式）
    func calculateCellHeight(model : DiaryModel) -> CGFloat {
        
        let topHeight : CGFloat = 40
        let detailHeight = Utils.calculateTextHeight(text: model.detail, width: SCREEN_WIDTH-40, font: UIFont.systemFont(ofSize: 15))
        let imageHeight = Utils.calculateImageSize(diaryModel: model).height
        let bootHeight : CGFloat = (imageHeight == 0) ? 20 : 30
        return CGFloat.init(topHeight + detailHeight + imageHeight + bootHeight)
    }
    
    ///生成sectionView
    func getSectionView(num : Int) -> UIView {
        let resultView : UIView = UIView.init()
        resultView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40)
        resultView.backgroundColor = UIColor.groupTableViewBackground
        
        let textLab : UILabel = UILabel.init()
        textLab.frame = CGRect.init(x: 15, y: 0, width: SCREEN_WIDTH-30, height: 40)
        textLab.textColor = DIARY_TEXTCOLOR
        textLab.font = UIFont.systemFont(ofSize: 13)
        textLab.text = "共 \(num) 条回复"
        resultView.addSubview(textLab)
        
        return resultView
    }
    
    ///添加键盘监听
    func addKeyBoardNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyBoardWillShow(noti : Notification){
        
        let userInfo = noti.userInfo
        let kbFrame : CGRect = userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.putView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-40-kbFrame.size.height-64, width: SCREEN_WIDTH, height: 40)
        }
        
    }
    
    @objc func keyBoardWillHide(noti : Notification){
        
        let userInfo = noti.userInfo
        let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.putView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-40-64, width: SCREEN_WIDTH, height: 40)
        }
    }
    
    @objc func resignTxf(){
        if(self.putTxf.canResignFirstResponder){self.putTxf.resignFirstResponder()}
    }
    
    ///获取评论列表
    func getCommentList(){
        SVProgressHUD.show(withStatus: "加载中...")
        accManager.getCommentList(diaryObjectId: self.diaryModel.objectId!) { (isSuccess, reason, array) in
            if(isSuccess){
                self.commentArray = array
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: reason)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
