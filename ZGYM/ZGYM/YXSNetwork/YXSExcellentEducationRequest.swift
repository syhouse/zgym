//
//  YXSExcellentEducationRequest.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//  优教育接口

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

// MARK: - 育儿好文
// MARK: 获取育儿好文首页分类
let childContentHomeListType = "/article/type/list"
class YXSEducationChildContentHomeListTypeRequest: YXSBaseRequset {
    override init() {
        super.init()
        method = .post
        host = host
        path = childContentHomeListType
    }
}

// MARK: 根据分类获取育儿好文列表数据
let childContentPageList = "/article/page"
class YXSEducationChildContentPageListRequest: YXSBaseRequset {
    init(size: Int = 20, current: Int = 0, type: Int = 0) {
        super.init()
        method = .post
        host = host
        path = childContentPageList
        var stage = YXSPersonDataModel.sharePerson.userModel.stage
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            let st = YXSPersonDataModel.sharePerson.userModel.curruntChild?.stage
            switch st {
            case .KINDERGARTEN:
                stage = "KINDERGARTEN"
            case .PRIMARY_SCHOOL:
                stage = "PRIMARY_SCHOOL"
            case .MIDDLE_SCHOOL:
                stage = "MIDDLE_SCHOOL"
            default:
                print("")
            }
        }
        if stage?.count ?? 0 <= 0 {
            stage = "PRIMARY_SCHOOL"
        }
        if type <= 0 {
            param = ["current": current,
                     "size":size,
                     "stage":stage ?? ""]
        } else {
            param = ["current": current,
                     "size":size,
                     "type":type,
                     "stage":stage ?? ""]
        }
        
    }
}

// MARK: 分页查询育儿好文收藏
let childContentCollectionArticle = "/article/collection/page"
class YXSEducationChildContentCollectionArticleRequest: YXSBaseRequset {
    init(size: Int = 20, current: Int = 1) {
        super.init()
        method = .post
        host = host
        path = childContentCollectionArticle
        param = ["current": current,
                "size": size]
    }
}

// MARK: 收藏或取消收藏育儿好文
let childContentCollectionArticleModify = "/article/collection/save/or/cancel"
class YXSEducationChildContentCollectionArticleModifyRequest: YXSBaseRequset {
    init(articleId: Int) {
        super.init()
        method = .post
        host = host
        path = childContentCollectionArticleModify
        param = ["articleId": articleId]
    }
}
