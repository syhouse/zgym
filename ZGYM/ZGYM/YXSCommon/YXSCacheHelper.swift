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
    public static func yxs_cacheHomeList(dataSource: [YXSHomeSectionModel]){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "HomeList\(YXSPersonDataModel.sharePerson.personRole.rawValue)"))
        }
    }
    
    /// 获取首页列表的缓存数据
    public static func yxs_getCacheHomeList() -> [YXSHomeSectionModel]{
        var dataSource:[YXSHomeSectionModel] = [YXSHomeSectionModel]()
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "HomeList\(YXSPersonDataModel.sharePerson.personRole.rawValue)")) as? [YXSHomeSectionModel]
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
    public static func yxs_cacheFriendsList(dataSource: [SLFriendCircleModel]){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "friendsList\(YXSPersonDataModel.sharePerson.personRole.rawValue)"))
        }
    }
    
    /// 获取优成长列表的缓存数据
    public static func yxs_getCacheFriendsList() -> [SLFriendCircleModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "friendsList\(YXSPersonDataModel.sharePerson.personRole.rawValue)")) as? [SLFriendCircleModel] ?? [SLFriendCircleModel]()
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
    public static func yxs_cacheSolitaireList(dataSource: [SLSolitaireModel], childrenId: Int?, isAgent: Bool){
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.yxs_archiveFile(file: "SolitaireList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)"))
        }
    }
    
    /// 获取接龙列表的缓存数据
    public static func yxs_getCacheSolitaireList(childrenId: Int?, isAgent: Bool) -> [SLSolitaireModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: "SolitaireList\(YXSPersonDataModel.sharePerson.personRole.rawValue)\(childrenId ?? 0)\(isAgent)")) as? [SLSolitaireModel] ?? [SLSolitaireModel]()
        return items
    }

}


// MARK: - 详情
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


// MARK: - 清除所有
extension YXSCacheHelper {
    
    /// 清除所有缓存归档
    public static func removeAllCacheArchiverFile(){
        let path = NSUtil.yxs_cachePath().appendingPathComponent(yxs_ArchiveFileDirectoryKey)
        try? FileManager.default.removeItem(atPath: path)
    }
}
