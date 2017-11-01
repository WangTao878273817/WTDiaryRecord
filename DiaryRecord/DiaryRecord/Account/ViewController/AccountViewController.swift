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
    var bgShapeLayer : CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configViewController()
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
    
    @IBAction func settingBtnClick(_ sender: Any) {
        print("click setting")
    }
    
    
    
    // MARK: - request
    ///获取 Account Info
    func requestAccountInfo(){
        let accManage = AccountDataManage.share
        accManage.userModel = Utils.getUserInfo()!
        accManage.getAccountInfo { (dataDic) in
                print("request complent -- \(dataDic)")
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
