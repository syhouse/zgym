//
//  YXSTemplateRequset.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

// MARK: -根据业务类型获取对应的所有标签和模板
let templateQueryTabTemplate = "/template/query-tab-template"
class YXSEducationTemplateQueryTabTemplateRequest: YXSBaseRequset {
    override init() {
        super.init()
        method = .post
        host = homeHost
        path = templateQueryTabTemplate
    }
}
// MARK: -根据业务类型获取所有模板模板内容(适用如打卡模板)

let templateQueryAllTemplate = "/template/query-all-template"
class YXSEducationTemplateQueryAllTemplateRequest: YXSBaseRequset {
    init(serviceType: Int) {
        super.init()
        method = .post
        host = homeHost
        path = templateQueryAllTemplate
        param = ["serviceType": serviceType]
    }
}

