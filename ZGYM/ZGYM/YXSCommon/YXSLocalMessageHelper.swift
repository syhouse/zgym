//
//  YXSLocalMessageHelper.swift
//  ZGYM
//
//  Created by zgjy_mac on 2020/1/9.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import UIKit

private let kHomeRedServiceListKey = "HomeRedServiceListKey"
/// 家长端首页本地红点消息
@objc class YXSLocalMessageHelper: NSObject {
    @objc static let shareHelper:YXSLocalMessageHelper = {
        let instance =  YXSLocalMessageHelper()
        return instance
    }()
    
    private override init() {
        super.init()
        //从本地归档获取消息列表
        let fileList = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_archiveFile(file: kHomeRedServiceListKey + "\(self.yxs_user.id ?? 0)")) as? [IMCustomMessageModel] ?? [IMCustomMessageModel]()
        yxs_initListData(fileList: fileList)
    }
    
    
    /// 重新s初始化本地红点数据
    public func yxs_changeListData(){
        yxs_initListData(fileList: localMessageLists)
    }
    
    
    /// 用消息列表来初始化本地红点相关数据
    /// - Parameter fileList: 消息列表
    private func yxs_initListData(fileList: [IMCustomMessageModel]){
        localRedServiceList.removeAll()
        if let gradeIds = self.yxs_user.gradeIds{
            var messageLists = [IMCustomMessageModel]()
            for model in fileList{
                if gradeIds.contains(model.classId ?? 0){
                    if let childrenId = model.childrenId{
                        if localRedServiceList.has(key: "\(childrenId)"){
                            localRedServiceList["\(childrenId)"]?.insert(model.serviceId ?? 0)
                        }else{
                            localRedServiceList["\(childrenId)"] = Set([model.serviceId ?? 0])
                        }
                    }
                    messageLists.append(model)
                }
            }
            localMessageLists = messageLists
        }else{
            localMessageLists = [IMCustomMessageModel]()
        }
    }
    
    
    /// 本地红点集合
    private var localRedServiceList: [String: Set<Int>] = [String: Set<Int>]()
    
    
    /// 消息列表数组
    private var localMessageLists: [IMCustomMessageModel] = [IMCustomMessageModel](){
        didSet{
            if YXSPersonDataModel.sharePerson.personRole == .PARENT{
                DispatchQueue.main.async {
                    self.yxs_showBadgeOnItem(index: 0, count: self.yxs_localMessageCount())
                }
            }else{
                DispatchQueue.main.async {
                    self.yxs_showBadgeOnItem(index: 0, count: 0)
                }
            }
        }
    }
    
    /// 更新本地红点消息
    /// - Parameter list: IM通知列表
    public func yxs_changeLocalMessageLists(list: [IMCustomMessageModel]){
        SLLog(list.toJSONString())
        if let gradeIds = self.yxs_user.gradeIds{
            var newList = [IMCustomMessageModel]()
            for model in list{
                if gradeIds.contains(model.classId ?? 0){
                    //删除
                    if model.msgType == 3{
                        for key in localRedServiceList.keys{
                            if var set = localRedServiceList[key]{
                                set.remove(model.serviceId ?? 0)
                                localRedServiceList[key] = set
                            }
                        }
                        for message in localMessageLists{
                            if message.serviceId == model.serviceId{
                                localMessageLists.remove(at: list.firstIndex(of: model) ?? 0)
                                break
                            }
                        }
                    }//新增
                    else{
                        for info in self.yxs_childrenClassList{
                            if model.classId == info["classId"]{
                                if model.childrenId == nil{
                                    model.childrenId = info["childrenId"]
                                    if localRedServiceList.has(key: "\(model.childrenId ?? 0)"){
                                        localRedServiceList["\(model.childrenId ?? 0)"]?.insert(model.serviceId ?? 0)
                                    }else{
                                        localRedServiceList["\(model.childrenId ?? 0)"] = Set([model.serviceId ?? 0])
                                    }
                                    newList.append(model)
                                }else{
                                    let newModel = model.copy()
                                    if let newModel = newModel as? IMCustomMessageModel{
                                        newModel.childrenId = info["childrenId"]
                                        if localRedServiceList.has(key: "\(newModel.childrenId ?? 0)"){
                                            localRedServiceList["\(newModel.childrenId ?? 0)"]?.insert(newModel.serviceId ?? 0)
                                        }else{
                                            localRedServiceList["\(newModel.childrenId ?? 0)"] = Set([newModel.serviceId ?? 0])
                                        }
                                        newList.append(newModel)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
            }
            localMessageLists += newList
            NSKeyedArchiver.archiveRootObject(localMessageLists, toFile: NSUtil.yxs_archiveFile(file: kHomeRedServiceListKey + "\(self.yxs_user.id ?? 0)"))
        }
    }
    
    
    /// 移除本地红点消息
    /// - Parameter serviceId: 服务Id
    public func yxs_removeLocalMessage(serviceId: Int, childId: Int){
        if localRedServiceList.has(key: "\(childId)"){
            localRedServiceList["\(childId)"]?.remove(serviceId)
            DispatchQueue.global().async {
                SLLog("serviceId=\(serviceId), childId = \(childId)")
                //删除所有满足条件的本地数据
                self.localMessageLists.removeAll { (model) -> Bool in
                    return model.serviceId == serviceId && model.childrenId == childId
                }
                NSKeyedArchiver.archiveRootObject(self.localMessageLists, toFile: NSUtil.yxs_archiveFile(file: kHomeRedServiceListKey + "\(self.yxs_user.id ?? 0)"))
            }
        }
        
    }
    
    /// 是否位于本地红点中
    /// - Parameter serviceId: 服务Id
    public func yxs_isLocalMessage(serviceId: Int, childId: Int) -> Bool{
        return localRedServiceList["\(childId)"]?.contains(serviceId) ?? false
    }
    
    
    /// 本地红点数量
    public func yxs_localMessageCount(childId: Int? = nil) -> Int{
        if let childId = childId{
            return localRedServiceList["\(childId)"]?.count ?? 0
        }
        var count = 0
        for key in localRedServiceList.keys{
            if let set = localRedServiceList[key]{
                count += set.count
            }
        }
//        SLLog(count)
        return count
    }
    
    
    /// 移除所有红点消息
    public func yxs_removeAll(){
        localMessageLists = [IMCustomMessageModel]()
    }
}
