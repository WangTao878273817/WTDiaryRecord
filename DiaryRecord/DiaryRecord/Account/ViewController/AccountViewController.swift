//
//  AccountViewController.swift
//  DiaryRecord
//
//  Created by Mac on 2017/10/30.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var accountBgImage: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var concernLab: UILabel!
    @IBOutlet weak var diaryLab: UILabel!
    @IBOutlet weak var notepadLab: UILabel!
    @IBOutlet weak var sunLab: UILabel!
    

    var bgShapeLayer : CAShapeLayer?
    let accManage = AccountDataManage.share
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configViewController()
        self.settingAccountInfo()
        self.requestAccountInfo()
        
    }
    
    ///初始化配置视图
    func configViewController(){
        
        self.scrollView.contentSize=CGSize.init(width: CGFloat(SCREEN_WIDTH), height: self.view.frame.size.height-64)
        self.scrollView.contentOffset=CGPoint.init(x: 0, y: 0 )
        
        self.userIcon.layer.borderColor=UIColor.white.cgColor
        self.configWhiteBgLayer()
    }
    
    ///配置遮挡layer
    func configWhiteBgLayer(){
        
        self.bgShapeLayer = CAShapeLayer.init()
        self.bgShapeLayer!.fillColor=UIColor.white.cgColor
        self.bgShapeLayer!.path=self.getBeizerPathWithY(y: self.scrollView.contentOffset.y)
        self.accountBgImage.layer.addSublayer(self.bgShapeLayer!)
        
    }
    
    ///获取bg layer的绘制path
    func getBeizerPathWithY(y : CGFloat) -> CGPath {
        
        var moveSize : CGFloat = (y + 20)
        moveSize = (moveSize>=0 ? 0 : moveSize)
        let beizerPath : UIBezierPath = UIBezierPath.init()
        beizerPath.move(to: CGPoint.init(x: 0, y: 320))
        beizerPath.addLine(to: CGPoint.init(x: 0, y: 450))
        beizerPath.addLine(to: CGPoint.init(x: Int(SCREEN_WIDTH), y: 450))
        beizerPath.addLine(to: CGPoint.init(x: Int(SCREEN_WIDTH), y: 320))
        beizerPath.addQuadCurve(to: CGPoint.init(x: 0, y: 320), controlPoint: CGPoint.init(x: Int(SCREEN_WIDTH/2), y: Int(360-moveSize)))
        beizerPath.lineCapStyle=CGLineCap.round
        beizerPath.lineJoinStyle=CGLineJoin.round
        return beizerPath.cgPath
        
    }
    
    ///设置用户信息(用户头像以及名称)
    func settingAccountInfo(){
        let userModel : UserModel = Utils.getUserInfo()!
        self.nameLab.text = userModel.name
        if(userModel.imageUrl != nil && userModel.imageUrl != ""){
            self.userIcon.sd_setImage(with: URL.init(string: userModel.imageUrl!))
        }
    }
    
    ///设置用户数据
    func settingAccountData(dataDic : Dictionary<String,String>){
        
        if(dataDic.count <= 0) {return}
        self.diaryLab.text=dataDic["diaryCount"]
        self.notepadLab.text=dataDic["notepadCount"]
        self.concernLab.text=dataDic["concernCount"]
        self.sunLab.text=(dataDic["sunCount"] == nil ? "0" : dataDic["sunCount"])
        
    }
    
    ///点击设置按钮
    @IBAction func settingBtnClick(_ sender: Any) {
        print("click setting")
    }
    
    ///点击小项按钮
    @IBAction func itemBtnClick(_ sender: UIButton) {

        switch sender.tag {
        case 5:
            self.performSegue(withIdentifier: "editInfoIdentifier", sender: "selfss")
        default:
            print("click other btn \(sender.tag)")
        }
    }
    
    
    
    // MARK: - request
    ///获取 Account Info
    func requestAccountInfo(){
        
        accManage.getAccountInfo { (dataDic) in
                self.settingAccountData(dataDic: dataDic)
        }
    }
    
    //MARK: - scorllview delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.bgShapeLayer?.path = self.getBeizerPathWithY(y: scrollView.contentOffset.y)
        
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
