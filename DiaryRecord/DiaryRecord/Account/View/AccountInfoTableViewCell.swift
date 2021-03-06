//
//  AccountInfoTableViewCell.swift
//  DiaryRecord
//
//  Created by shoule on 2017/11/2.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class AccountInfoTableViewCell: UITableViewCell {
    private var _dataDic : Dictionary<String,String>! = Dictionary.init()
    var dataDic : Dictionary<String,String>!{
        set{
            _dataDic = newValue
            self.settingData()
        }
        get{
            return _dataDic
        }
    }
    
    private var _titleStyleInfo : (String,AccountInfoCellStyle) = ("标题",AccountInfoCellStyle.Nomal)
    var titleStyleInfo : (String,AccountInfoCellStyle){
        set{
            _titleStyleInfo=newValue
            self.configShowStyle()
        }
        get{
            return _titleStyleInfo
        }
    }
    
    var titleLab : UILabel! = UILabel.init()
    var arrowsImg : UIImageView! = UIImageView.init()
    var detailLab : UILabel! = UILabel.init()
    var uSwitch : UISwitch! = UISwitch.init()
    var detailImg : UIImageView! = UIImageView.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configView()

    }
    
    ///设置视图样式
    func configView(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.titleLab.frame = CGRect.init(x: MARGIN_LEFT_DEFAULT, y: 0, width: SCREEN_WIDTH/2-MARGIN_LEFT_DEFAULT, height: CELL_HEIGHT_DEFAULT)
        self.titleLab.font = UIFont.systemFont(ofSize: 15.0)
        self.addSubview(self.titleLab)
        
        self.arrowsImg.frame = CGRect.init(x: SCREEN_WIDTH-MARGIN_LEFT_DEFAULT-10, y: CELL_HEIGHT_DEFAULT/2-5, width: MARGIN_LEFT_DEFAULT/2, height: MARGIN_LEFT_DEFAULT/2)
        self.arrowsImg.image = UIImage.init(named: "account_arrows_icon")
        self.addSubview(self.arrowsImg)
        
        self.detailLab.frame = CGRect.init(x: SCREEN_WIDTH/2, y: 0, width: SCREEN_WIDTH/2-MARGIN_LEFT_DEFAULT-14, height: CELL_HEIGHT_DEFAULT)
        self.detailLab.textColor = UIColor.darkGray
        self.detailLab.textAlignment = NSTextAlignment.right
        self.detailLab.font = UIFont.systemFont(ofSize: 13.0)
        self.addSubview(self.detailLab)
        
        self.uSwitch.frame = CGRect.init(x: SCREEN_WIDTH-69, y: 7, width: 49, height: 31)
        self.uSwitch.addTarget(self, action: #selector(switchChange(_:)), for: UIControlEvents.valueChanged)
        self.addSubview(self.uSwitch)
        
        self.detailImg.frame = CGRect.init(x: SCREEN_WIDTH-70, y: 4, width: 36, height: 36)
        self.detailImg.layer.cornerRadius = 18
        self.detailImg.layer.masksToBounds = true
        self.addSubview(self.detailImg)
        
    }
    
    ///设置显示样式
    func configShowStyle(){
        self.titleLab.text = self.titleStyleInfo.0
        self.initializationShow()
        switch self.titleStyleInfo.1 {
        case AccountInfoCellStyle.Switch:
            self.detailImg.isHidden = true
            self.detailLab.isHidden = true
            self.arrowsImg.isHidden = true
            break
        case AccountInfoCellStyle.Text:
            self.detailImg.isHidden = true
            self.uSwitch.isHidden = true
            break
        case AccountInfoCellStyle.Image:
            self.detailLab.isHidden = true
            self.uSwitch.isHidden = true
            break
        default:
            self.detailImg.isHidden = true
            self.detailLab.isHidden = true
            self.uSwitch.isHidden = true
            break
        }
        
    }
    
    ///设置数据
    func settingData(){
        
        self.detailLab.text = (self.dataDic["detail"] == nil ? "" : self.dataDic["detail"])
        self.uSwitch.isOn =  (self.dataDic["switch"] == "1" ? true : false)
        if(self.dataDic["image"] != nil && self.dataDic["image"] != ""){
            self.detailImg.sd_setImage(with: URL.init(string: self.dataDic["image"]!))
        }else{
            self.detailImg.image = UIImage.init(named: "account_default_icon")
        }
        
    }
    
    ///初始化显示
    func initializationShow(){
        self.detailLab.isHidden = false
        self.detailImg.isHidden = false
        self.uSwitch.isHidden = false
        self.arrowsImg.isHidden = false
    }
    
    ///切换改变
    @objc func switchChange(_ iSwitch : UISwitch) {
        print("change value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
enum AccountInfoCellStyle {
    case Nomal
    case Switch
    case Image
    case Text
}
