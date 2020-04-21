//
//  YXSExcellentEducationRequest.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation


// MARK: - 同步课堂
// MARK: 获取同步课堂标签tab类型（年级分类 “一年级，二年级...”）
let excellentTabPage = "/synch-classroom/tab-page-query"
class YXSEducationExcellentTabPageRequest: YXSBaseRequset {
    init(pageSize: Int = 100, currentPage: Int = 0) {
        super.init()
        method = .post
        host = fileHost
        path = excellentTabPage
        param = ["currentPage": currentPage,
                 "pageSize":pageSize]
    }
}


// MARK: 标签文件夹分页查询
let folderPageQuery = "/synch-classroom/folder-page-query"
class YXSEducationFolderPageQueryRequest: YXSBaseRequset {
    init(pageSize: Int = 20, currentPage: Int = 0, tabId: Int) {
        super.init()
        method = .post
        host = fileHost
        path = folderPageQuery
        param = ["currentPage": currentPage,
                 "pageSize":pageSize,
                 "tabId":tabId]
    }
}

// MARK: 资源分页查询
let resourcePageQuery = "/synch-classroom/resource-page-query"
class YXSEducationResourcePageQueryRequest: YXSBaseRequset {
    init(pageSize: Int = 20, currentPage: Int = 0, folderId: Int) {
        super.init()
        method = .post
        host = fileHost
        path = resourcePageQuery
        param = ["currentPage": currentPage,
                 "pageSize":pageSize,
                 "folderId":folderId]
    }
}

// MARK: 播放数加1
let playAddCount = "/synch-classroom/add-play-count"
class YXSEducationPlayAddCountRequest: YXSBaseRequset {
    init(folderId: Int) {
        super.init()
        method = .post
        host = fileHost
        path = playAddCount
        param = ["folderId":folderId]
    }
}
