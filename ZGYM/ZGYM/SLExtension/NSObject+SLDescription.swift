//
//  NSObject+SLDescription.swift
//  ZGYM
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

extension NSObject{
    public func sl_description() -> String{
        do{
            let infoData = try JSONSerialization.data(withJSONObject: self.sl_covertToDictionary(), options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: infoData, encoding: String.Encoding.utf8) ?? ""
        }catch{
            
        }
        return ""
    }

    private func sl_covertToDictionary() -> Dictionary<String, Any?> {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &count)
        
        var propertyInfo = Dictionary<String, Any?>()
        for i in 0 ..< Int(count){
            let property = properties![i]
            let name = property_getName(property)
            
            let propertyName = String(cString: name)
            
            let value = self.value(forKey: propertyName)
            
            propertyInfo[propertyName] = value
        }
        free(properties)
        return propertyInfo
    }
    
    public func sl_allPropertyNames() ->[String] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &count)
        
        var propertyNames = [String]()
        for i in 0 ..< Int(count){
            let property = properties![i]
            let name = property_getName(property)
            
            let propertyName = String(cString: name)
            
            propertyNames.append(propertyName)
        }
        free(properties)
        return propertyNames
    }
    
    /// 获取对象的所有属性名称跟值
    public func sl_allPropertys() ->[String : Any?] {
        
        var dict:[String : Any?] = [String : Any?]()
        
        // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        var count: UInt32 = 0
        
        let properties = class_copyPropertyList(self.classForCoder, &count)
        
        for i in 0 ..< Int(count) {
            
            // 获取属性名称
            let property = properties![i]
            let name = property_getName(property)
            let propertyName = String(cString: name)
            
            if (!propertyName.isEmpty) {
                
                // 获取Value数据
                let propertyValue = self.value(forKey: propertyName)
                
                dict[propertyName] = propertyValue
            }
        }
        
        // 释放内存，否则C语言的指针很容易成野指针的
        free(properties)
        
        return dict
    }
}
