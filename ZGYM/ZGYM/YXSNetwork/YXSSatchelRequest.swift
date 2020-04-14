//
//  YXSSatchelRequest.swift
//  HNYMEducation
//
//  Created by Liu Jie on 2020/4/8.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
/// 创建文件夹
let satchelCreateFolder = "/satchel/create-folder"
class YXSSatchelCreateFolderRequest: YXSBaseRequset {
    init(folderName: String, parentFolderId: Int = -1) {
        super.init()
        method = .post
        host = fileHost
        path = satchelCreateFolder
        param = [
            "folderName":folderName,
            "parentFolderId":parentFolderId]
    }
}

/// 批量移动文件夹、文件
let satchelBatchMove = "/satchel/batch-move"
class YXSSatchelBatchMoveRequest: YXSBaseRequset {
    init(folderIdList: [Int] = [Int](), fileIdList: [Int] = [Int](), oldParentFolderId: Int, parentFolderId: Int){
        super.init()
        method = .post
        host = fileHost
        path = satchelBatchMove
        param = ["folderIdList":folderIdList,
                 "fileIdList":fileIdList,
            "oldParentFolderId":oldParentFolderId,
            "parentFolderId":parentFolderId]
    }
}


let satchelBatchDelete = "/satchel/batch-delete"
/// 批量删除书包文件夹、文件
class YXSSatchelBatchDeleteRequest: YXSBaseRequset {
    init(obj:[String: Any], parentFolderId: Int){
        super.init()
        method = .post
        host = fileHost
        path = satchelBatchDelete
        param = obj
        param = ["parentFolderId":parentFolderId]
    }
    
    init(fileIdList:[Int] = [Int](), folderIdList:[Int] = [Int](), parentFolderId: Int) {
        super.init()
        method = .post
        host = fileHost
        path = satchelBatchDelete
        param = ["parentFolderId":parentFolderId,
                 "fileIdList": fileIdList,
                 "folderIdList": folderIdList]
    }
}

let satchelRenameFile = "/satchel/rename-file"
/// 重命名文件
class YXSSatchelRenameFileRequest: YXSBaseRequset {
    init(fileId: Int, fileName: String){
        super.init()
        method = .post
        host = fileHost
        path = satchelRenameFile
        param = ["fileId":fileId,
                 "fileName":fileName]
    }
}

let satchelRenameFolder = "/satchel/rename-folder"
/// 重命名文件夹
class YXSSatchelRenameFolderRequest: YXSBaseRequset {
    init(folderId: Int, folderName: String){
        super.init()
        method = .post
        host = fileHost
        path = satchelRenameFolder
        param = ["folderId":folderId,
                 "folderName":folderName]
    }
}

/// 上传文件
let satchelUploadFile = "/satchel/upload-file"
class YXSSatchelUploadFileRequest: YXSBaseRequset {
    init(parentFolderId: Int, satchelFileList: [[String: Any]]){
        super.init()
        method = .post
        host = fileHost
        path = satchelUploadFile
        param = ["parentFolderId":parentFolderId,
                 "satchelFileList":satchelFileList]
    }
}

let satchelFilePageQuery = "/satchel/file-page-query"
/// 书包文件分页查询
class YXSSatchelFilePageQueryRequest: YXSBaseRequset {
    init(currentPage: Int, parentFolderId: Int){
        super.init()
        method = .post
        host = fileHost
        path = satchelFilePageQuery
        param = ["currentPage":currentPage,
                 "pageSize":20,
                 "parentFolderId":parentFolderId]
    }
}

/// 书包文件夹分页查询
let satchelFolderPageQuery = "/satchel/folder-page-query"
class YXSSatchelFolderPageQueryRequest: YXSBaseRequset {
    init(currentPage: Int, parentFolderId: Int = -1){
        super.init()
        method = .post
        host = fileHost
        path = satchelFolderPageQuery
//        let pId = parentFolderId != nil ? parentFolderId : -1
        param = ["currentPage":currentPage,
                 "pageSize":20,
                 "parentFolderId":parentFolderId]
    }
}
