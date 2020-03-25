//
//  SLCacheHelper.swift
//  ZGYM
//
//  Created by hnsl_mac on 2020/2/7.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import UIKit

// MARK: - 列表
class SLCacheHelper: NSObject {
    
    /// 缓存首页列表数据
    /// - Parameter dataSource: 首页列表
    public static func sl_cacheHomeList(dataSource: [HomeSectionModel]){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.sl_archiveFile(file: "HomeList"))
        }
    }
    
    /// 获取首页列表的缓存数据
    public static func sl_getCacheHomeList() -> [HomeSectionModel]{
        var dataSource:[HomeSectionModel] = [HomeSectionModel]()
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "HomeList")) as? [HomeSectionModel]
        if let items = items{
            dataSource = items
        }else{
            for index in 0...2{
                let sectionModel = HomeSectionModel()
                if index == 1{
                    sectionModel.hasSection = true
                    sectionModel.showText = "今天的消息"
                }else if index == 2{
                    sectionModel.hasSection = true
                    sectionModel.showText = "更早消息"
                }
                sectionModel.items = [SLHomeListModel]()
                dataSource.append(sectionModel)
            }
        }
        return dataSource
    }

    
    /// 缓存优成长列表数据
    /// - Parameter dataSource: 优成长列表
    public static func sl_cacheFriendsList(dataSource: [SLFriendCircleModel]){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.sl_archiveFile(file: "friendsList"))
        }
    }
    
    /// 获取优成长列表的缓存数据
    public static func sl_getCacheFriendsList() -> [SLFriendCircleModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "friendsList")) as? [SLFriendCircleModel] ?? [SLFriendCircleModel]()
        return items
    }
    
    /// 缓存通知列表数据
    /// - Parameter dataSource: 通知列表
    public static func sl_cacheNoticeList(dataSource: [SLHomeListModel]){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.sl_archiveFile(file: "NoticeList"))
        }
    }
    
    /// 获取通知列表的缓存数据
    public static func sl_getCacheNoticeList() -> [SLHomeListModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "NoticeList")) as? [SLHomeListModel] ?? [SLHomeListModel]()
        return items
    }
    
    /// 缓存作业列表数据
    /// - Parameter dataSource: 作业列表
    public static func sl_cacheHomeWorkList(dataSource: [SLHomeListModel]){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.sl_archiveFile(file: "HomeWorkList"))
        }
    }
    
    /// 获取作业列表的缓存数据
    public static func sl_getCacheHomeWorkList() -> [SLHomeListModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "HomeWorkList")) as? [SLHomeListModel] ?? [SLHomeListModel]()
        return items
    }
    
    /// 缓存打卡列表数据
    /// - Parameter dataSource: 打卡列表
    public static func sl_cachePunchCardList(dataSource: [SLPunchCardModel]){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.sl_archiveFile(file: "PunchCardList"))
        }
    }
    
    /// 获取打卡列表的缓存数据
    public static func sl_getCachePunchCardList() -> [SLPunchCardModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "PunchCardList")) as? [SLPunchCardModel] ?? [SLPunchCardModel]()
        return items
    }
    
    /// 缓存接龙列表数据
    /// - Parameter dataSource: 接龙列表
    public static func sl_cacheSolitaireList(dataSource: [SLSolitaireModel]){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.sl_archiveFile(file: "SolitaireList"))
        }
    }
    
    /// 获取接龙列表的缓存数据
    public static func sl_getCacheSolitaireList() -> [SLSolitaireModel]{
        let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "SolitaireList")) as? [SLSolitaireModel] ?? [SLSolitaireModel]()
        return items
    }

}


// MARK: - 详情
extension SLCacheHelper {
    
    /// 缓存打卡任务数据
    /// - Parameters:
    ///   - model: 打卡任务Model
    ///   - clockInId: 打卡任务ID
    ///   - childrenId: 打卡孩子id  老师传nil
    public static func sl_cachePunchCardDetailTask(model: SLPunchCardModel,clockInId: Int, childrenId: Int?){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(model, toFile: NSUtil.sl_archiveFile(file: "PunchCardDetailTask\(clockInId)\(childrenId ?? 0)".MD5()))
        }
    }
    
    /// 缓存打卡任务打卡列表数据
    /// - Parameters:
    ///   - dataSource: 打卡列表
    ///   - clockInId: 打卡任务ID
    public static func sl_cachePunchCardDetailTaskList(dataSource: [PunchCardPublishListModel], clockInId: Int){
        DispatchQueue.main.async {
            NSKeyedArchiver.archiveRootObject(dataSource, toFile: NSUtil.sl_archiveFile(file: "PunchCardDetailTaskList\(clockInId)".MD5()))
        }
    }
    
    /// 获取打卡任务数据
    public static func sl_getCachePunchCardDetailTask(clockInId: Int, childrenId: Int?) -> SLPunchCardModel{
        let model = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "PunchCardDetailTask\(clockInId)\(childrenId ?? 0)".MD5())) as? SLPunchCardModel ?? SLPunchCardModel.init(JSON: ["" : ""])!
        return model
    }
    
    /// 获取打卡任务打卡列表数据
    public static func sl_getCachePunchCardDetailTaskList(clockInId: Int) -> [PunchCardPublishListModel]{
      let items = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: "PunchCardDetailTaskList\(clockInId)".MD5())) as? [PunchCardPublishListModel] ?? [PunchCardPublishListModel]()
        return items
    }
}


// MARK: - 清除所有
extension SLCacheHelper {
    
    /// 清除所有缓存归档
    public static func removeAllCacheArchiverFile(){
        let path = NSUtil.sl_cachePath().appendingPathComponent(SL_ArchiveFileDirectoryKey)
        try? FileManager.default.removeItem(atPath: path)
    }
}
