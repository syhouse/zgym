//
//  Array+SLCategory.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/29.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import Foundation

extension Array {
    // 去重
    func sl_filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
    // 找出重复
    func sl_findDuplicates<T: Equatable>(filter: (Element)-> T) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
