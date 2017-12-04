//
//  DiaryTableViewCell.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/13.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

enum DiaryTableViewCellStyle {
    case Nomal      //默认样式，首页显示样式
    case List       //日记本列表显示样式
    case Detail     //日记详情显示样式
}

class DiaryTableViewCell: UITableViewCell {

    var userImageView : UIImageView = UIImageView.init()
    var userNameLab : UILabel = UILabel.init()
    var notepadNameLab : UILabel = UILabel.init()
    var createdAtLab : UILabel = UILabel.init()
    var detailLab : UILabel = UILabel.init()
    var diaryImageBtn : UIButton = UIButton.init(type: UIButtonType.system)
    var commentImageView : UIImageView = UIImageView.init()
    var commentLab : UILabel = UILabel.init()
    var lineView : UIView = UIView.init()
    
    private let top_magin : CGFloat = 15
    private let sl_magin : CGFloat = 20
    private let bl_magin : CGFloat = 60
    
    private var diaryModel : DiaryModel = DiaryModel.init()
    private var  _cellData : (DiaryTableViewCellStyle , DiaryModel) = (DiaryTableViewCellStyle.Nomal , DiaryModel.init())
    var cellData : (DiaryTableViewCellStyle , DiaryModel){
        set{
            _cellData = newValue
            self.diaryModel = newValue.1
            self.settingDisplay()
            self.settingData()
           
        }
        get{
            return _cellData
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configView()
        
    }
    
    ///初始化视图
    func configView(){
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.userImageView.frame = CGRect.init(x: 10, y: top_magin, width: 40, height: 40)
        self.userImageView.layer.cornerRadius = 20
        self.userImageView.layer.masksToBounds = true
        self.userImageView.isHidden = true
        self.addSubview(self.userImageView)
        
        self.userNameLab.frame = CGRect.init(x: 60, y: top_magin, width: 80, height: 20)
        self.userNameLab.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(self.userNameLab)
        
        self.notepadNameLab.frame = CGRect.init(x: 140, y: top_magin, width: 120, height: 20)
        self.notepadNameLab.font = UIFont.systemFont(ofSize: 13)
        self.notepadNameLab.textColor = UIColor.lightGray
        self.addSubview(self.notepadNameLab)
        
        self.createdAtLab.frame = CGRect.init(x: SCREEN_WIDTH-50, y: top_magin, width: 40, height: 20)
        self.createdAtLab.font = UIFont.systemFont(ofSize: 11)
        self.createdAtLab.textAlignment = NSTextAlignment.right
        self.createdAtLab.textColor = UIColor.lightGray
        self.addSubview(self.createdAtLab)
        
        self.detailLab.frame = CGRect.init(x: 60, y: 50, width: 300, height: 200)
        self.detailLab.font = UIFont.systemFont(ofSize: 15)
        self.detailLab.textColor = UIColor.darkGray
        self.detailLab.numberOfLines = 0
        self.addSubview(self.detailLab)
        
        self.diaryImageBtn.frame = CGRect.init(x: 60, y: 370, width: 100, height: 100)
        self.diaryImageBtn.addTarget(self, action: #selector(imageClick(_:)), for: UIControlEvents.touchUpInside)
        self.diaryImageBtn.backgroundColor = UIColor.lightGray
        self.addSubview(self.diaryImageBtn)
        
        self.commentImageView.frame = CGRect.init(x: 60, y: 480, width: 20, height: 20)
        self.commentImageView.image = UIImage.init(named: "account_cell_comment")
        self.addSubview(self.commentImageView)
        
        self.commentLab.frame = CGRect.init(x: 70, y: 480, width: 100, height: 20)
        self.commentLab.textColor = UIColor.lightGray
        self.commentLab.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(self.commentLab)
        
        self.lineView.frame = CGRect.init(x: 10, y: 510, width: SCREEN_WIDTH-20, height: 1)
        self.lineView.backgroundColor = UIColor.lightGray
        
    }
    
    ///设置显示
    func settingDisplay(){
        
        let imageSize : CGSize = Utils.calculateImageSize(diaryModel: self.diaryModel)
        let commentY :CGFloat = (imageSize.height == 0 || imageSize.height == 0) ? 10 : 20
        
        switch self.cellData.0 {
        case DiaryTableViewCellStyle.List:
            
            self.userImageView.isHidden = true
            self.userNameLab.isHidden = true
            self.notepadNameLab.isHidden = true
            self.createdAtLab.frame = CGRect.init(x: sl_magin, y: top_magin, width: 80, height: 20)
            self.createdAtLab.textAlignment = NSTextAlignment.left
            let textHeight = Utils.calculateTextHeight(text: self.diaryModel.detail, width: SCREEN_WIDTH-40, font: UIFont.systemFont(ofSize: 15))
            self.detailLab.frame = CGRect.init(x: 20, y: 40, width: SCREEN_WIDTH-sl_magin*2, height: textHeight)
            
            if(imageSize.height == 0 || imageSize.height == 0){
                self.diaryImageBtn.isHidden = true
            }else{
                self.diaryImageBtn.isHidden = false
                self.diaryImageBtn.frame = CGRect.init(origin: CGPoint.init(x: sl_magin, y: textHeight+50), size: imageSize)
            }
            self.commentImageView.frame = CGRect.init(x: sl_magin, y: 40+textHeight+imageSize.height+commentY, width: 20, height: 20)
            self.commentLab.frame = CGRect.init(x: sl_magin+30, y: 40+textHeight+imageSize.height+commentY, width: 100, height: 20)
            
            break
        case DiaryTableViewCellStyle.Detail:
            
            self.userImageView.isHidden = true
            self.userNameLab.isHidden = true
            self.notepadNameLab.textColor = UIColor.black
            self.notepadNameLab.frame = CGRect.init(x: sl_magin, y: top_magin, width: 120, height: 20)
            self.createdAtLab.frame = CGRect.init(x: SCREEN_WIDTH-100, y: top_magin, width: 80, height: 20)
            self.createdAtLab.textAlignment = NSTextAlignment.right
            let textHeight = Utils.calculateTextHeight(text: self.diaryModel.detail, width: SCREEN_WIDTH-40, font: UIFont.systemFont(ofSize: 15))
            self.detailLab.frame = CGRect.init(x: sl_magin, y: 40, width: SCREEN_WIDTH-sl_magin*2, height: textHeight)
            
            if(imageSize.height == 0 || imageSize.height == 0){
                self.diaryImageBtn.isHidden = true
            }else{
                self.diaryImageBtn.isHidden = false
                self.diaryImageBtn.frame = CGRect.init(origin: CGPoint.init(x: sl_magin, y: textHeight+50), size: imageSize)
            }
            
            break
        default:
            
            break
        }
        
        if(self.diaryModel.commentNum == nil || self.diaryModel.commentNum == "0" || self.diaryModel.commentNum == "" || self.cellData.0==DiaryTableViewCellStyle.Detail){
            self.commentImageView.isHidden = true
            self.commentLab.isHidden = true
        }else{
            self.commentImageView.isHidden = false
            self.commentLab.isHidden = false
        }
    }
    
    ///设置数据
    func settingData(){
        
        if(self.diaryModel.userImageUrl?.isEmpty == false && self.diaryModel.userImageUrl != ""){
            self.userImageView.sd_setImage(with: URL.init(string: self.diaryModel.userImageUrl!), placeholderImage: UIImage.init(named: "account_default_icon"),  completed: nil)
        }
        
        self.userNameLab.text = self.diaryModel.userName
        self.notepadNameLab.text = "《\(self.diaryModel.notepadName!)》"
        self.createdAtLab.text = Utils.newStringDate(dateStr: self.diaryModel.createdAt!, format: "HH:mm")
        self.detailLab.text = self.diaryModel.detail
        if(self.diaryModel.imageUrl != nil && self.diaryModel.imageUrl != ""){
            self.diaryImageBtn.sd_setBackgroundImage(with: URL.init(string: self.diaryModel.imageUrl!), for: UIControlState.normal, completed: nil)
        }
        self.commentLab.text = self.diaryModel.commentNum
        
    }
    
    ///图片点击
    @objc func imageClick(_ btn : UIButton) {
        print("click btn")
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
