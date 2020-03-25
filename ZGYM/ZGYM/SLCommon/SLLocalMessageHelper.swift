//
//  SLLocalMessageHelper.swift
//  ZGYM
//
//  Created by hnsl_mac on 2020/1/9.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import UIKit


/// 家长端s首页本地红点消息
@objc class SLLocalMessageHelper: NSObject {
    @objc static let shareHelper:SLLocalMessageHelper = {
        let instance =  SLLocalMessageHelper()
        return instance
    }()
    
    private override init() {
        super.init()
        //从本地归档获取消息列表
        let fileList = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_archiveFile(file: kHomeRedServiceListKey + "\(self.sl_user.id ?? 0)")) as? [IMCustomMessageModel] ?? [IMCustomMessageModel]()
        sl_initListData(fileList: fileList)
    }
    
    
    /// 重新s初始化本地红点数据
    public func sl_changeListData(){
        sl_initListData(fileList: localMessageLists)
    }
    
    
    /// 用消息列表来初始化本地红点相关数据
    /// - Parameter fileList: 消息列表
    private func sl_initListData(fileList: [IMCustomMessageModel]){
        localRedServiceList.removeAll()
        if let gradeIds = self.sl_user.gradeIds{
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
            if SLPersonDataModel.sharePerson.personRole == .PARENT{
                DispatchQueue.main.async {
                    self.sl_showBadgeOnItem(index: 0, count: self.sl_localMessageCount())
                }
            }else{
                DispatchQueue.main.async {
                    self.sl_showBadgeOnItem(index: 0, count: 0)
                }
            }
        }
    }
    
    /// 更新本地红点消息
    /// - Parameter list: IM通知列表
    public func sl_changeLocalMessageLists(list: [IMCustomMessageModel]){
        if let gradeIds = self.sl_user.gradeIds{
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
                        for info in self.sl_childrenClassList{
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
            NSKeyedArchiver.archiveRootObject(localMessageLists, toFile: NSUtil.sl_archiveFile(file: kHomeRedServiceListKey + "\(self.sl_user.id ?? 0)"))
        }
    }
    
    
    /// 移除本地红点消息
    /// - Parameter serviceId: 服务Id
    public func sl_removeLocalMessage(serviceId: Int, childId: Int){
        if localRedServiceList.has(key: "\(childId)"){
            localRedServiceList["\(childId)"]?.remove(serviceId)
            DispatchQueue.global().async {
                //删除所有满足条件的本地数据
                self.localMessageLists.removeAll { (model) -> Bool in
                    return model.serviceId == serviceId && model.childrenId == childId
                }
                NSKeyedArchiver.archiveRootObject(self.localMessageLists, toFile: NSUtil.sl_archiveFile(file: kHomeRedServiceListKey + "\(self.sl_user.id ?? 0)"))
            }
        }
        
    }
    
    /// 是否位于本地红点中
    /// - Parameter serviceId: 服务Id
    public func sl_isLocalMessage(serviceId: Int, childId: Int) -> Bool{
        return localRedServiceList["\(childId)"]?.contains(serviceId) ?? false
    }
    
    
    /// 本地红点数量
    public func sl_localMessageCount(childId: Int? = nil) -> Int{
        if let childId = childId{
            return localRedServiceList["\(childId)"]?.count ?? 0
        }
        var count = 0
        for key in localRedServiceList.keys{
            if let set = localRedServiceList[key]{
                count += set.count
            }
        }
        SLLog(count)
        return count
    }
    
    
    /// 移除所有红点消息
    public func sl_removeAll(){
        localMessageLists = [IMCustomMessageModel]()
    }
}
