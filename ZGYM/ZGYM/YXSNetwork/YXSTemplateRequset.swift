//
//  YXSTemplateRequset.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

// MARK: -根据业务类型获取对应的所有标签和模板
let templateQueryRecommendTemplate = "/template/query-recommend-template"
class YXSEducationTemplateQueryRecommendTemplateRequest: YXSBaseRequset {
    init(serviceType: Int) {
        super.init()
        method = .post
        host = homeHost
        path = templateQueryRecommendTemplate
        param = ["serviceType": serviceType]
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

// MARK: -查询指定id模板详情

let templateQueryTemplateById = "/template/query-template-by-id"
class YXSEducationTemplateQueryTemplateByIdRequest: YXSBaseRequset {
    init(id: Int) {
        super.init()
        method = .post
        host = homeHost
        path = templateQueryTemplateById
        param = ["id": id]
    }
}

// MARK: -获取业务类型的所有标签、模板
//        业务类型(已完成0:幼儿园通知模板,1:作业,2:打卡,3:接龙,100:小学通知模板,101:中学通知模板)
let templateQueryTabTemplate = "/template/query-tab-template"
class YXSEducationTemplateQueryTabTemplateRequest: YXSBaseRequset {
    init(serviceType: Int) {
        super.init()
        method = .post
        host = homeHost
        path = templateQueryTabTemplate
            
        param = ["serviceType": serviceType]
    }
}

// MARK: -根据业务类型分页查询模板内容
//        业务类型(0:幼儿园通知模板,1:作业,2:打卡,3:接龙,100:小学通知模板,101:中学通知模板)
let templateQueryTabTemplateContent = "/template/page-query-template-content"
class YXSEducationTemplateQueryTabTemplateContentRequest: YXSBaseRequset {
    init(serviceType: Int,currentPage: Int = 1, pageSize: Int = 20) {
        super.init()
        method = .post
        host = homeHost
        path = templateQueryTabTemplateContent
        param = ["serviceType": serviceType,
                 "currentPage":currentPage,
                 "pageSize":pageSize]
    }
}


