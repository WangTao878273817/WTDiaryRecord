//
//  CommentTableViewCell.swift
//  DiaryRecord
//
//  Created by Mac on 2017/12/1.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    private var titleImg : UIImageView = UIImageView.init()
    private var nameLab : UILabel = UILabel.init()
    private var dateLab : UILabel = UILabel.init()
    private var detailLab : UILabel = UILabel.init()
    private var moreBtn : UIButton = UIButton.init()
    
    private var _commentData : (CommentModel,Bool) = (CommentModel.init() , false)
    var commentData : (CommentModel,Bool){
        set{
            _commentData = newValue
            self.setModelData()
        }
        get{
            return _commentData
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    ///配置视图
    func configView(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.titleImg.frame = CGRect.init(x: 15, y: 15, width: 40, height: 40)
        self.titleImg.layer.cornerRadius = 20
        self.titleImg.layer.masksToBounds = true
        self.titleImg.image = UIImage.init(named: "account_default_icon")
        self.addSubview(self.titleImg)
        
        self.nameLab.frame = CGRect.init(x: 60, y: 15, width: 80, height: 20)
        self.nameLab.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(self.nameLab)
        
        self.dateLab.frame = CGRect.init(x: SCREEN_WIDTH-50, y: 15, width: 40, height: 20)
        self.dateLab.font = UIFont.systemFont(ofSize: 11)
        self.dateLab.textAlignment = NSTextAlignment.right
        self.dateLab.textColor = UIColor.lightGray
        self.addSubview(self.dateLab)
        
        self.detailLab.frame = CGRect.init(x: 60, y: 40, width: SCREEN_WIDTH-60-15, height: 30)
        self.detailLab.font = UIFont.systemFont(ofSize: 15)
        self.detailLab.textColor = UIColor.darkGray
        self.detailLab.numberOfLines = 0
        self.addSubview(self.detailLab)
        
        self.moreBtn.frame = CGRect.init(x: SCREEN_WIDTH-40, y: 60, width: 25, height: 25)
        self.moreBtn.setBackgroundImage(UIImage.init(named: "account_diary_more_gray"), for: UIControlState.normal)
        self.moreBtn.addTarget(self, action: #selector(self.moreBtnClick), for: UIControlEvents.touchUpInside)
        self.addSubview(self.moreBtn)
        
    }
    
    @objc func moreBtnClick(){
        
    }
    
    ///设置模型数据
    func setModelData(){
        
        self.titleImg.sd_setImage(with: URL.init(string: self.commentData.0.userImageUrl!), placeholderImage: UIImage.init(named: "account_default_icon"))
        self.nameLab.text = self.commentData.0.userName
        self.dateLab.text = self.commentData.0.createdAt
        let textHeight = Utils.calculateTextHeight(text: self.commentData.0.detail, width: SCREEN_WIDTH-60-15, font: UIFont.systemFont(ofSize: 15))
        self.detailLab.text = self.commentData.0.detail
        self.detailLab.frame = CGRect.init(x: 60, y: 40, width: SCREEN_WIDTH-60-15, height: textHeight)
        self.moreBtn.isHidden = !self.commentData.1
        self.moreBtn.frame = CGRect.init(x: SCREEN_WIDTH-40, y: 40+textHeight+5, width: 25, height: 25)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
