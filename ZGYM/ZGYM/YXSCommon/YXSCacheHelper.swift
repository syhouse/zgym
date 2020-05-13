//
//  YXSCacheHelper.swift
//  ZGYM
//
//  Created by zgjy_mac on 2020/2/7.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import UIKit

// MARK: - 列表
class YXSCacheHelper: NSObject {
    /// 缓存首页列表数据
    /// - Parameter dataSource: 首页列表
    public static func yxs_cacheHomeList(dataSource: [YXSHomeSectionModel], childrenId: Int?){
        DispatchQueue.global().async {
            let personModel = YXSPersonDataModel.sharePerson
            let cachePath = "HomeList\(personModel.personRole.rawValue)\(personModel.userModel.id ?? 0)\(childrenId ?? 0)"
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: cachePath))
        }
    }
    
    /// 获取首页列表的缓存数据
    public static func yxs_getCacheHomeList(childrenId: Int?) -> [YXSHomeSectionModel]{
        var dataSource:[YXSHomeSectionModel] = [YXSHomeSectionModel]()
        let personModel = YXSPersonDataModel.sharePerson
        let cachePath = "HomeList\(personModel.personRole.rawValue)\(personModel.userModel.id ?? 0)\(childrenId ?? 0)"
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: cachePath)) as? [YXSHomeSectionModel]
        if let items = items{
            dataSource = items
        }else{
            for index in 0...2{
                let sectionModel = YXSHomeSectionModel()
                if index == 1{
                    sectionModel.hasSection = true
                    sectionModel.showText = "今天的消息"
                }else if index == 2{
                    sectionModel.hasSection = true
                    sectionModel.showText = "更早消息"
                }
                sectionModel.items = [YXSHomeListModel]()
                dataSource.append(sectionModel)
            }
        }
        return dataSource
    }

    
    /// 缓存优成长列表数据
    /// - Parameter dataSource: 优成长列表
    public static func yxs_cacheFriendsList(dataSource: [YXSFriendCircleModel]){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "friendsList\(YXSPersonDataModel.sharePerson.personRole.rawValue)"))
        }
    }
    
    /// 获取优成长列表的缓存数据
    public static func yxs_getCacheFriendsList() -> [YXSFriendCircleModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "friendsList\(YXSPersonDataModel.sharePerson.personRole.rawValue)")) as? [YXSFriendCircleModel] ?? [YXSFriendCircleModel]()
        return items
    }
    
    /// 缓存通知列表数据
    /// - Parameter dataSource: 通知列表
    public static func yxs_cacheNoticeList(dataSource: [YXSHomeListModel], childrenId: Int?, isAgent: Bool){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "NoticeList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)"))
        }
    }
    
    /// 获取通知列表的缓存数据
    public static func yxs_getCacheNoticeList(childrenId: Int?, isAgent: Bool) -> [YXSHomeListModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "NoticeList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)")) as? [YXSHomeListModel] ?? [YXSHomeListModel]()
        return items
    }
    
    /// 缓存作业列表数据
    /// - Parameter dataSource: 作业列表
    public static func yxs_cacheHomeWorkList(dataSource: [YXSHomeListModel], childrenId: Int?, isAgent: Bool){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "HomeWorkList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)"))
        }
    }
    
    /// 获取作业列表的缓存数据
    public static func yxs_getCacheHomeWorkList(childrenId: Int?, isAgent: Bool) -> [YXSHomeListModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "HomeWorkList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)")) as? [YXSHomeListModel] ?? [YXSHomeListModel]()
        return items
    }
    
    /// 缓存打卡列表数据
    /// - Parameter dataSource: 打卡列表
    public static func yxs_cachePunchCardList(dataSource: [YXSPunchCardModel], childrenId: Int?, isAgent: Bool){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "PunchCardList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)"))
        }
    }
    
    /// 获取打卡列表的缓存数据
    public static func yxs_getCachePunchCardList(childrenId: Int?, isAgent: Bool) -> [YXSPunchCardModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "PunchCardList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)")) as? [YXSPunchCardModel] ?? [YXSPunchCardModel]()
        return items
    }
    
    /// 缓存接龙列表数据
    /// - Parameter dataSource: 接龙列表
    public static func yxs_cacheSolitaireList(dataSource: [YXSSolitaireModel], childrenId: Int?, isAgent: Bool){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "SolitaireList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)"))
        }
    }
    
    /// 获取接龙列表的缓存数据
    public static func yxs_getCacheSolitaireList(childrenId: Int?, isAgent: Bool) -> [YXSSolitaireModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SolitaireList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)")) as? [YXSSolitaireModel] ?? [YXSSolitaireModel]()
        return items
    }
}

// MARK: - 班级列表
extension YXSCacheHelper {
    /// 缓存班级列表数据(加入的班级)
    public static func yxs_cacheClassJoinList(dataSource: [YXSClassModel]){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "ClassJoin\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)"))
        }
    }
    
    /// 获取缓存班级列表数据(加入的班级)
    public static func yxs_getCacheClassJoinList() -> [YXSClassModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "ClassJoin\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)")) as? [YXSClassModel] ?? [YXSClassModel]()
        return items
    }
    
    /// 缓存班级列表数据(创建的班级)
    public static func yxs_cacheClassCreateList(dataSource: [YXSClassModel]){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "ClassCreate\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)"))
        }
    }
    
    /// 获取班级列表的缓存数据(创建的班级)
    public static func yxs_getCacheClassCreateList() -> [YXSClassModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "ClassCreate\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)")) as? [YXSClassModel] ?? [YXSClassModel]()
        return items
    }
}


// MARK: - 文件
extension YXSCacheHelper {
    /// 缓存书包文件夹列表数据
    public static func yxs_cacheSatchelFolderList(dataSource: [YXSFolderModel], parentFolderId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "SatchelFolder\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)"))
        }
    }
    
    /// 获取书包文件夹列表数据
    public static func yxs_getCacheSatchelFolderList(parentFolderId: Int)-> [YXSFolderModel] {
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SatchelFolder\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)")) as? [YXSFolderModel] ?? [YXSFolderModel]()
        return items
    }
    
    /// 缓存书包文件列表数据
    public static func yxs_cacheSatchelFileList(dataSource: [YXSFileModel], parentFolderId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "SatchelFile\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)"))
        }
    }
    
    /// 获取书包文件列表数据
    public static func yxs_getCacheSatchelFileList(parentFolderId: Int)-> [YXSFileModel] {
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SatchelFile\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)")) as? [YXSFileModel] ?? [YXSFileModel]()
        return items
    }
    
    /// 缓存班级文件夹列表数据
    public static func yxs_cacheClassFolderList(dataSource: [YXSFolderModel], classId:Int, parentFolderId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "ClassFolder\(classId)\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)"))
        }
    }
    
    /// 获取书包文件夹列表数据
    public static func yxs_getCacheClassFolderList(classId:Int, parentFolderId: Int)-> [YXSFolderModel] {
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "ClassFolder\(classId)\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)")) as? [YXSFolderModel] ?? [YXSFolderModel]()
        return items
    }
    
    /// 缓存班级文件列表数据
    public static func yxs_cacheClassFileList(dataSource: [YXSFileModel], classId:Int, parentFolderId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "ClassFile\(classId)\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)"))
        }
    }
    
    /// 获取班级文件列表数据
    public static func yxs_getCacheClassFileList(classId:Int, parentFolderId: Int)-> [YXSFileModel] {
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "ClassFile\(classId)\(parentFolderId)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)")) as? [YXSFileModel] ?? [YXSFileModel]()
        return items
    }
}

// MARK: - 打卡详情
extension YXSCacheHelper {
    
    /// 缓存打卡任务数据
    /// - Parameters:
    ///   - model: 打卡任务Model
    ///   - clockInId: 打卡任务ID
    ///   - childrenId: 打卡孩子id  老师传nil
    public static func yxs_cachePunchCardDetailTask(model: YXSPunchCardModel,clockInId: Int, childrenId: Int?){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(model, toFile: NSUtil.yxs_archiveFile(file: "PunchCardDetailTask\(clockInId)\(childrenId ?? 0)".MD5()))
        }
    }
    
    
    /// 获取打卡任务数据
    public static func yxs_getCachePunchCardDetailTask(clockInId: Int, childrenId: Int?) -> YXSPunchCardModel{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "PunchCardDetailTask\(clockInId)\(childrenId ?? 0)".MD5())) as? YXSPunchCardModel ?? YXSPunchCardModel.init(JSON: ["" : ""])!
        return model
    }
    
    
    ///打卡提交列表数据
    public static func yxs_cachePunchCardTaskStudentCommintList(dataSource: [YXSPunchCardCommintListModel], clockInId: Int, childrenId: Int? , type: YXSSingleStudentListType){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "PunchCardTaskStudentCommintList\(clockInId)\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(type.rawValue))\(childrenId ?? 0)".MD5()))
        }
    }
    
    /// 获取打卡提交列表数据
    public static func yxs_getCachePunchCardTaskStudentCommintList(clockInId: Int, childrenId: Int?, type: YXSSingleStudentListType) -> [YXSPunchCardCommintListModel]{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "PunchCardTaskStudentCommintList\(clockInId)\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(type.rawValue))\(childrenId ?? 0)".MD5())) as? [YXSPunchCardCommintListModel] ?? [YXSPunchCardCommintListModel]()
        return model
    }

}

// MARK: - 接龙详情
extension YXSCacheHelper {
    /// 获取接龙详情数据
    public static func yxs_getCacheSolitaireDetailTask(censusId: Int, childrenId: Int) -> YXSHomeworkDetailModel{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SolitaireDetailTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)\(censusId)\(childrenId)".MD5())) as? YXSHomeworkDetailModel ?? YXSHomeworkDetailModel.init(JSON: ["" : ""])!
        return model
    }
    
    /// 缓存接龙详情数据
    public static func yxs_cacheSolitaireDetailTask(model: YXSHomeworkDetailModel,censusId: Int, childrenId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(model, toFile: NSUtil.yxs_archiveFile(file: "SolitaireDetailTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)\(censusId)\(childrenId)".MD5()))
        }
    }
    
    /// 获取接龙详情未接龙人员数据
    public static func yxs_getCacheSolitaireNotJoinStaffListTask(censusId: Int) -> [YXSClassMemberModel]{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SolitaireNotJoinStaffListTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)\(censusId)".MD5())) as? [YXSClassMemberModel] ?? [YXSClassMemberModel]()
        return model
    }
    /// 缓存接龙详情未接龙人员数据
    public static func yxs_cacheSolitaireNotJoinStaffListTask(dataSource: [YXSClassMemberModel],censusId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "SolitaireNotJoinStaffListTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)\(censusId)".MD5()))
        }
    }
    
    /// 获取接龙详情已接龙人员数据
    public static func yxs_getCacheSolitaireJoinStaffListTask(censusId: Int) -> [YXSClassMemberModel]{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SolitaireJoinStaffListTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)\(censusId)".MD5())) as? [YXSClassMemberModel] ?? [YXSClassMemberModel]()
        return model
    }
    /// 缓存接龙详情已接龙人员数据
    public static func yxs_cacheSolitaireJoinStaffListTask(dataSource: [YXSClassMemberModel],censusId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "SolitaireJoinStaffListTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)\(censusId)".MD5()))
        }
    }
}

// MARK: - 作业详情
extension YXSCacheHelper {
    /// 获取老师发布的作业详情数据
    public static func yxs_getCachePublishHomeworkDetailTask(homeworkId: Int) -> YXSHomeworkDetailModel{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "PublishHomeworkDetailTask\(homeworkId)".MD5())) as? YXSHomeworkDetailModel ?? YXSHomeworkDetailModel.init(JSON: ["" : ""])!
        return model
    }
    ///缓存老师发布的作业详情数据
    public static func yxs_cachePublishHomeworkDetailTask(data: YXSHomeworkDetailModel, homeworkId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(data, toFile: NSUtil.yxs_archiveFile(file: "PublishHomeworkDetailTask\(homeworkId)".MD5()))
        }
    }
    
    /// 获取家长提交的作业详情列表数据
    public static func yxs_getCacheSubmitHomeworkDetailTask(homeworkId: Int, isGood: Int, isRemark: Int) -> [YXSHomeworkDetailModel]{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SubmitHomeworkDetailTask\(homeworkId)\(isGood)\(isRemark)".MD5())) as? [YXSHomeworkDetailModel] ?? [YXSHomeworkDetailModel]()
        return model
    }
    ///缓存家长提交的作业详情列表数据
    public static func yxs_cacheSubmitHomeworkDetailTask(data: [YXSHomeworkDetailModel], homeworkId: Int, isGood: Int, isRemark: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(data, toFile: NSUtil.yxs_archiveFile(file: "SubmitHomeworkDetailTask\(homeworkId)\(isGood)\(isRemark)".MD5()))
        }
    }
    
    /// 获取历史优秀作业列表数据
    public static func yxs_getCacheHomeworkHistoryGoodListTask(childrenId: Int, classId: Int) -> [YXSHomeworkDetailModel]{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "HomeworkHistoryGoodListTask\(childrenId)\(classId)".MD5())) as? [YXSHomeworkDetailModel] ?? [YXSHomeworkDetailModel]()
        return model
    }
    ///缓存历史优秀作业列表数据
    public static func yxs_cacheHomeworkHistoryGoodListTask(data: [YXSHomeworkDetailModel], childrenId: Int, classId: Int){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(data, toFile: NSUtil.yxs_archiveFile(file: "HomeworkHistoryGoodListTask\(childrenId)\(classId)".MD5()))
        }
    }
}

// MARK: - 我的收藏
extension YXSCacheHelper {
    /// 获取我的收藏声音数据
    public static func yxs_getCacheMyCollectionVoiceTask() -> [YXSMyCollectModel]{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "MyCollectVoiceTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)".MD5())) as? [YXSMyCollectModel] ?? [YXSMyCollectModel]()
        return model
    }
    ///缓存我的收藏声音数据
    public static func yxs_cacheMyCollectionVoiceTask(dataSource: [YXSMyCollectModel]){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "MyCollectVoiceTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)".MD5()))
        }
    }
    
    /// 获取我的收藏专辑数据
    public static func yxs_getCacheMyCollectionAlbumTask() -> [YXSMyCollectModel]{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "MyCollectAlbumTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)".MD5())) as? [YXSMyCollectModel] ?? [YXSMyCollectModel]()
        return model
    }
    ///缓存我的收藏专辑数据
    public static func yxs_cacheMyCollectionAlbumTask(dataSource: [YXSMyCollectModel]){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "MyCollectAlbumTask\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(YXSPersonDataModel.sharePerson.userModel.id ?? 0)".MD5()))
        }
    }
}


// MARK: - 清除所有
extension YXSCacheHelper {
    
    /// 清除所有缓存归档
    public static func removeAllCacheArchiverFile(){
        let path = NSUtil.yxs_cachePath().appendingPathComponent(yxs_ArchiveFileDirectoryKey)
        try? FileManager.default.removeItem(atPath: path)
    }
}
