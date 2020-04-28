//
//  YXSSatchelRequest.swift
//  ZGYM
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
//    init(obj:[String: Any], parentFolderId: Int){
//        super.init()
//        method = .post
//        host = fileHost
//        path = satchelBatchDelete
//        param = obj
//        param = ["parentFolderId":parentFolderId]
//    }
    
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
    
    init(parentFolderId: Int, satchelFileList: [YXSFileModel]){
        super.init()
        method = .post
        host = fileHost
        path = satchelUploadFile
        
        var dicArr = [[String: Any]]()
        for sub in satchelFileList {
            dicArr.append(sub.toJSON())
        }
        param = ["parentFolderId":parentFolderId,
                 "satchelFileList":dicArr]
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

/// 书包所有文档类型文件查询(doc,xls,ppt,pdf)
let satchelDocFilePageQuery = "/satchel/doc-file-page-query"
class YXSSatchelDocFilePageQueryRequest: YXSBaseRequset {
    init(currentPage: Int){
        super.init()
        method = .post
        host = fileHost
        path = satchelDocFilePageQuery
        param = ["currentPage":currentPage,
                 "pageSize":20]
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




let fileCreateFolder = "/file/create-folder"
/// 创建文件夹
class YXSFileCreateFolderRequest: YXSBaseRequset {
    init(classId: Int = 0, folderName: String, parentId: Int = -1) {
        super.init()
        method = .post
        host = fileHost
        path = fileCreateFolder
        param = [
            "classId":classId,
            "folderName":folderName,
            "parentId":parentId]
    }
}


let fileBatchMove = "/file/batch-move"
/// 批量移动文件夹、文件
class YXSFileBatchMoveRequest: YXSBaseRequset {
    init(classId: Int = 0, folderIdList: [Int] = [Int](), fileIdList: [Int] = [Int](), oldParentFolderId: Int, parentFolderId: Int){
        super.init()
        method = .post
        host = fileHost
        path = fileBatchMove
        param = [
            "classId":classId,
            "folderIdList":folderIdList,
                 "fileIdList":fileIdList,
            "oldParentFolderId":oldParentFolderId,
            "parentFolderId":parentFolderId]
    }
}


let fileBatchDelete = "/file/batch-delete"
/// 批量删除书包文件夹、文件
class YXSFileBatchDeleteRequest: YXSBaseRequset {
    init(classId:Int, fileIdList:[Int] = [Int](), folderIdList:[Int] = [Int](), parentFolderId: Int) {
        super.init()
        method = .post
        host = fileHost
        path = fileBatchDelete
        param = [
            "classId":classId,
            "parentFolderId":parentFolderId,
                 "fileIdList": fileIdList,
                 "folderIdList": folderIdList]
    }
}

let fileRenameFile = "/file/rename-file"
/// 重命名文件
class YXSFileRenameFileRequest: YXSBaseRequset {
    init(classId: Int, folderId: Int, fileId: Int, fileName: String){
        super.init()
        method = .post
        host = fileHost
        path = fileRenameFile
        param = [
            "classId":classId,
            "folderId":folderId,
            "fileId":fileId,
             "fileName":fileName]
    }
}

let fileRenameFolder = "/file/rename-folder"
/// 重命名文件夹
class YXSFileRenameFolderRequest: YXSBaseRequset {
    init(classId: Int, folderId: Int, folderName: String){
        super.init()
        method = .post
        host = fileHost
        path = fileRenameFolder
        param = [
            "classId":classId,
            "folderId":folderId,
                 "folderName":folderName]
    }
}

/// 上传文件
let fileUploadFile = "/file/upload-file"
class YXSFileUploadFileRequest: YXSBaseRequset {
    init(classId: Int, folderId: Int, classFileList: [[String: Any]]){
        super.init()
        method = .post
        host = fileHost
        path = fileUploadFile
        param = [
            "classId":classId,
            "folderId":folderId,
                 "classFileList":classFileList]
    }
    
    init(classId: Int, folderId: Int, classFileList: [YXSFileModel]){
        super.init()
        method = .post
        host = fileHost
        path = fileUploadFile
        
        var dicArr = [[String: Any]]()
        for sub in classFileList {
            dicArr.append(sub.toJSON())
        }
        param = [
            "classId":classId,
            "folderId":folderId,
                 "classFileList":dicArr]
    }
}

let filePageQuery = "/file/page-query"
/// 班级文件分页查询
class YXSFilePageQueryRequest: YXSBaseRequset {
    init(classId: Int, currentPage: Int, folderId: Int){
        super.init()
        method = .post
        host = fileHost
        path = filePageQuery
        param = [
            "classId":classId,
            "currentPage":currentPage,
                 "pageSize":20,
                 "folderId":folderId]
    }
}


let fileFolderPageQuery = "/file/folder-page-query"
/// 班级文件夹分页查询
class YXSFileFolderPageQueryRequest: YXSBaseRequset {
    init(classId: Int, currentPage: Int, folderId: Int = -1){
        super.init()
        method = .post
        host = fileHost
        path = fileFolderPageQuery
        param = [
            "classId":classId,
            "currentPage":currentPage,
                 "pageSize":20,
                 "folderId":folderId]
    }
}
