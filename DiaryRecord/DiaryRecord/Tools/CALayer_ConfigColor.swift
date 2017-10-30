//
//  CALayer_ConfigColor.swift
//  DiaryRecord
//
//  Created by shoule on 2017/10/25.
//  Copyright © 2017年 WT. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    var borderColorFromUIColor:UIColor{
        
        set(color){
            self.borderColor = color.cgColor;
        }
        get{
            return UIColor.init(cgColor: self.borderColor!)
        }
    }
    
    public var boardUIColor : UIColor{
        get{
            return UIColor.init(cgColor: self.borderColor!)
        }
        set{
            self.borderColor = boardUIColor.cgColor
        }
    }
    
    
}
