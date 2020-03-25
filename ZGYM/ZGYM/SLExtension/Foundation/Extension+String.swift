//
//  String+Extension.swift
//  WKWebViewSwift
//
//  Created by XiaoFeng on 2017/10/20.
//  Copyright © 2017年 XiaoFeng. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    /// 截取字符串
    ///
    /// - Parameter index: 截取从index位开始之前的字符串
    /// - Returns: 返回一个新的字符串
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    /// 截取字符串
    ///
    /// - Parameter index: 截取从index位开始到末尾的字符串
    /// - Returns: 返回一个新的字符串
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    func MD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}

