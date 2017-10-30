//
//  Object-getAttribute.swift
//  DiaryRecord
//
//  Created by shoule on 2017/10/27.
//  Copyright © 2017年 WT. All rights reserved.
//

import Foundation
import UIKit

extension NSObject{
    
    func getPropertyNames() -> Array<String>{
        var resultArray : Array<String> = Array.init()
        
        var outCount:UInt32
        outCount = 0
        
        let propers:UnsafeMutablePointer<objc_property_t>! =  class_copyPropertyList(self.classForCoder, &outCount)
        
        let count:Int = Int(outCount);
        
        for i in 0...(count-1) {
            
            let aPro: objc_property_t = propers[i]
            
            let proName:String! = String.init(utf8String: property_getName(aPro));
            
            print(proName)
            
            resultArray.append(proName)
            
        }
        
        return resultArray
    }
    
    func getMethodNames() -> Array<String>{
        var resultArray : Array<String> = Array.init()
        
        var outCount:UInt32
        
        outCount = 0
        
        let methods:UnsafeMutablePointer<objc_property_t>! =  class_copyMethodList(self.classForCoder, &outCount)
        
        let count:Int = Int(outCount);
        
        print(outCount)
        
        for i in 0...(count-1) {
            
            let aMet: objc_property_t = methods[i]
            
            let methodName:String! = String.init(utf8String: property_getName(aMet));
            
            print(methodName)
            
            resultArray.append(methodName)
        }
        return resultArray
    }
    

    
}
