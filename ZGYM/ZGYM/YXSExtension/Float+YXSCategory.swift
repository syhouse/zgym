//
//  Float+YXSCategory.swift
//  ZGYM
//
//  Created by yihao on 2020/6/12.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

extension Float {
    
    var cleanZero : String {
        let testNumber = String(self)
        var outNumber = testNumber
        if testNumber.contains(".") {
            let endStr = testNumber.components(separatedBy: ".").last
            let endStrArr = endStr?.charactersArray ?? [Character]()
            for char in endStrArr.reversed() {
                if char == "0" {
                    outNumber.removeLast()
                } else {
                    break
                }
            }
            
            if outNumber.last == "." {
                outNumber.removeLast()
            }
            return outNumber
        } else {
            return testNumber
        }
    }
}
