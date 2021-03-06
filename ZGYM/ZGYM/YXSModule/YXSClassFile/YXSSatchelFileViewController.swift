//
//  YXSSatchelFileViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
import Photos

/// 老师-书包
class YXSSatchelFileViewController: YXSClassFileViewController {    
    
    init(parentFolderId: Int = -1) {
        super.init(classId: -1, parentFolderId: parentFolderId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "我的文件"
        
        /// 取出缓存数据赋值
        folderList = YXSCacheHelper.yxs_getCacheSatchelFolderList(parentFolderId: parentFolderId)
        fileList = YXSCacheHelper.yxs_getCacheSatchelFileList(parentFolderId: parentFolderId)

        // Do any additional setup after loading the view.
//        view.addSubview(btnSearch)
//        view.addSubview(btnAddFileFromComputer)
//        btnSearch.snp.makeConstraints({ (make) in
//            make.top.equalTo(0)
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.height.equalTo(44)
//        })
        
//        btnAddFileFromComputer.snp.remakeConstraints({ (make) in
//            make.top.equalTo(btnSearch.snp_bottom).offset(14)
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.height.equalTo(30)
//        })
        
//        tableView.snp.remakeConstraints({ (make) in
////            make.top.equalTo(btnAddFileFromComputer.snp_bottom).offset(0)
//            make.top.equalTo(btnSearch.snp_bottom).offset(14)
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.bottom.equalTo(0)
//        })
    }
    
    
    // MARK: - Request
    override func yxs_refreshData() {
        loadMore = true
        folderHasNext = true
        loadData2()
    }
    
    override func yxs_loadNextPage() {
        loadData2()
    }
    
    @objc override func loadData2() {
        if folderHasNext {
            /// 请求文件夹
            YXSSatchelFolderPageQueryRequest(currentPage: self.currentPage, parentFolderId: self.parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                weakSelf.folderHasNext = json["hasNext"].boolValue

                let tmpFolderList = Mapper<YXSFolderModel>().mapArray(JSONString: json["satchelFolderList"].rawString()!) ?? [YXSFolderModel]()
                
                if weakSelf.currentPage == 1 {
                    weakSelf.folderList.removeAll()
                }
                weakSelf.folderList += tmpFolderList
                
                if weakSelf.isTbViewEditing {
                    /// 编辑状态 下拉刷新 填充选中的Cell
                    for sub in weakSelf.selectedFolderList {
                        for obj in weakSelf.folderList {
                            if sub.id == obj.id {
                                obj.isSelected = true
                                break
                            }
                        }
                    }
                }
                
                YXSCacheHelper.yxs_cacheSatchelFolderList(dataSource: weakSelf.folderList, parentFolderId: weakSelf.parentFolderId)
                
                if weakSelf.folderHasNext {
                    /// 文件夹还有
                    weakSelf.fileList.removeAll()
                    YXSCacheHelper.yxs_cacheSatchelFileList(dataSource: weakSelf.fileList, parentFolderId: weakSelf.parentFolderId)
                    weakSelf.tableView.reloadData()
                    weakSelf.yxs_endingRefresh()
                    
                } else {
                    /// 文件夹没了 请求文件数据
                    weakSelf.currentPage = 1
                    weakSelf.requestFile()
                }
                
            }) { [weak self](msg, code) in
                guard let weakSelf = self else {return}
                
                MBProgressHUD.yxs_showMessage(message: msg)
                weakSelf.yxs_endingRefresh()
            }
            
        } else {
            /// 请求文件
            requestFile()
        }
    }
    
    @objc override func requestFile(completionHandler:(([YXSFileModel])->())? = nil) {
        YXSSatchelFilePageQueryRequest(currentPage: self.currentPage, parentFolderId: self.parentFolderId).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            let hasNext = json["hasNext"].boolValue
            weakSelf.loadMore = hasNext
            
            let tmpFileList = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
            if weakSelf.currentPage == 1 {
                weakSelf.fileList.removeAll()
            }
            weakSelf.fileList += tmpFileList
            if weakSelf.isTbViewEditing {
                /// 填充Cell的选中
                for sub in weakSelf.selectedFileList {
                    for obj in weakSelf.fileList {
                        if sub.id == obj.id {
                            obj.isSelected = true
                            break
                        }
                    }
                }
            }
            YXSCacheHelper.yxs_cacheSatchelFileList(dataSource: weakSelf.fileList, parentFolderId: weakSelf.parentFolderId)
            
            completionHandler?(tmpFileList)
            weakSelf.tableView.reloadData()
            weakSelf.yxs_endingRefresh()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showMessage(message: msg)
            weakSelf.yxs_endingRefresh()
        }
    }
    
//    @objc override func loadData() {
//
//        let workingGroup = DispatchGroup()
//        let workingQueue = DispatchQueue(label: "request_queue")
//
//        var tmpFolderList = [YXSFolderModel]()
//        var tmpFileList = [YXSFileModel]()
//
//        // 入组
//        workingGroup.enter()
//        workingQueue.async {
//            // 出组
//            YXSSatchelFolderPageQueryRequest(currentPage: 1, parentFolderId: self.parentFolderId).request({ [weak self](json) in
//                guard let weakSelf = self else {return}
////                let hasNext = json["hasNext"].boolValue
////                weakSelf.loadMore = hasNext
//
//                tmpFolderList = Mapper<YXSFolderModel>().mapArray(JSONString: json["satchelFolderList"].rawString()!) ?? [YXSFolderModel]()
//                workingGroup.leave()
//
//            }) { (msg, code) in
//                MBProgressHUD.yxs_showMessage(message: msg)
//            }
//        }
//
//        // 入组
//        workingGroup.enter()
//        workingQueue.async {
//            // 出组
//            YXSSatchelFilePageQueryRequest(currentPage: self.currentPage, parentFolderId: self.parentFolderId).request({ [weak self](json) in
//                guard let weakSelf = self else {return}
//                let hasNext = json["hasNext"].boolValue
//                weakSelf.loadMore = hasNext
//
//                tmpFileList = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
//                workingGroup.leave()
//
//            }) { (msg, code) in
//                MBProgressHUD.yxs_showMessage(message: msg)
//            }
//
//        }
//
//        // 调度组里的任务都执行完毕
//        workingGroup.notify(queue: workingQueue) {
//            DispatchQueue.main.async {
//                if self.isTbViewEditing {
//                    /// 编辑状态 下拉刷新 填充选中的Cell
//                    for sub in self.getSelectedFolerList() {
//                        for obj in tmpFolderList {
//                            if sub.id == obj.id {
//                                obj.isSelected = true
//                                break
//                            }
//                        }
//                    }
//
//                    for sub in self.getSelectedFileList() {
//                        for obj in tmpFileList {
//                            if sub.id == obj.id {
//                                obj.isSelected = true
//                                break
//                            }
//                        }
//                    }
//                }
//
//                if self.currentPage == 1{
//                    self.fileList.removeAll()
//                }
//
//                self.folderList = tmpFolderList
//                self.fileList += tmpFileList
//
//                self.tableView.reloadData()
//
//                YXSCacheHelper.yxs_cacheSatchelFolderList(dataSource: self.folderList, parentFolderId: self.parentFolderId)
//                YXSCacheHelper.yxs_cacheSatchelFileList(dataSource: self.fileList, parentFolderId: self.parentFolderId)
//
//                self.yxs_endingRefresh()
//            }
//        }
//    }
    
    /// 批量删除
    @objc override func batchDeleteRequest(fileIdList:[Int] = [Int](), folderIdList:[Int] = [Int](), completionHandler:(()->Void)?) {
        let alert = YXSConfirmationAlertView.showIn(target: self.view) { [weak self](sender, view) in
            guard let weakSelf = self else {return}
            
            if sender.titleLabel?.text == "删除" {
                YXSSatchelBatchDeleteRequest(fileIdList: fileIdList, folderIdList: folderIdList, parentFolderId: weakSelf.parentFolderId).request({ (json) in
                    completionHandler?()
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
                
                view.close()
                weakSelf.endEditing()
                
            } else {
                /// 取消
            }
        }
        alert.lbTitle.text = "提示"
        if folderIdList.count > 0 {
            alert.lbContent.text = "删除文件夹会同时删除该文件夹内所有文件，确定要删除吗?"
        } else {
            alert.lbContent.text = "确定要删除文件吗?"
        }
        alert.btnDone.setTitle("删除", for: .normal)
    }
    
    // MARK: - Action
    @objc func addFileFromComputerClick() {
        
    }
    
    @objc override func searchClick(sender: YXSButton) {
        let vc = YXSSearchFileViewController(searchType: .satchel)
        self.navigationController?.pushViewController(vc)
    }
    
    @objc override func addFileClick() {
        if isTbViewEditing {
            endEditing()
            
        } else {
            let lists = [YXSCommonBottomParams.init(title: "从相册选择", event: "album"),YXSCommonBottomParams.init(title: "新建文件夹", event: "createFolder")]
            
            YXSCommonBottomAlerView.showIn(buttons: lists) { [weak self](model) in
                guard let strongSelf = self else { return }
                switch model.event {
                case "album":
                    strongSelf.selectedFromAlbumClick()
                case "createFolder":
                    strongSelf.createFolderClick()
                default:
                    break
                }
            }
        }
    }
    
    @objc override func createFolderClick() {
        let view = YXSInputAlertView2.showIn(target: self.view) { [weak self](result, btn) in
            guard let weakSelf = self else {return}
            if btn.titleLabel?.text == "创建" {
                YXSSatchelCreateFolderRequest(folderName: result, parentFolderId: weakSelf.parentFolderId).request({ [weak self](json) in
                    guard let weakSelf = self else {return}
                    weakSelf.loadData2()
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
        }
        view.lbTitle.text = "创建文件夹"
        view.tfInput.placeholder = "请输入文件夹名称"
        view.btnDone.setTitle("创建", for: .normal)
        view.btnCancel.setTitle("取消", for: .normal)
    }
    
    // MARK: -重命名、移动、删除(批处理)
    @objc override func renameBtnClick(sender: YXSButton) {
        
        let tmpFolderList = getSelectedFolerList()
        let tmpFileList = getSelectedFileList()
        
        if tmpFolderList.count == 1 || tmpFileList.count == 1 {
            let view = YXSInputAlertView2.showIn(target: self.view) { [weak self](result, btn) in
                guard let weakSelf = self else {return}
                if btn.titleLabel?.text == "确定" {
                    
                    if result.isBlank {
                        MBProgressHUD.yxs_showMessage(message: "名称不能为空", inView: weakSelf.view)
                        return
                    }
                    
                    if tmpFolderList.count == 1 {
                        /// 文件夹更名
                        let tmpItem = tmpFolderList.first
                        YXSSatchelRenameFolderRequest(folderId: tmpItem?.id ?? 0, folderName: result).request({ [weak self](json) in
                            guard let weakSelf = self else {return}
                            tmpItem?.folderName = result
                            weakSelf.tableView.reloadSections([0], with: .none)
                            
                        }) { (msg, code) in
                            
                        }
                        
                    } else if tmpFileList.count == 1 {
                        /// 文件更名
                        let tmpItem = tmpFileList.first
                        let fileName = "\(result).\(tmpItem?.fileType ?? "")"
                        YXSSatchelRenameFileRequest(fileId: tmpItem?.id ?? 0, fileName: fileName).request({ [weak self](json) in
                            guard let weakSelf = self else {return}
                            tmpItem?.fileName = fileName
                            weakSelf.tableView.reloadSections([1], with: .none)
                            
                        }) { (msg, code) in
                            
                        }
                    }
                }
            }
            
            
            view.lbTitle.text = "重命名"
            view.tfInput.placeholder = "请输入名称"
            view.btnDone.setTitle("确定", for: .normal)
            view.btnCancel.setTitle("取消", for: .normal)
            var name = ""
            if tmpFolderList.count == 1 {
                name = tmpFolderList.first?.folderName ?? ""
            } else if tmpFileList.count == 1 {
                name = tmpFileList.first?.fileName?.deletingPathExtension ?? ""
            }
            view.tfInput.text = name
        }
    }
    
    @objc override func moveBtnClick(sender: YXSButton) {
        var selectedFolderList :[Int] = [Int]()
        var selectedFileList :[Int] = [Int]()
        
        for sub in getSelectedFolerList() {
            if sub.isSelected ?? false {
                selectedFolderList.append(sub.id ?? 0)
            }
        }
        
        for sub in getSelectedFileList() {
            if sub.isSelected ?? false {
                selectedFileList.append(sub.id ?? 0)
            }
        }
        
        let vc = YXSMoveToViewController(classId: nil, folderIdList: selectedFolderList, fileIdList: selectedFileList, oldParentFolderId: -1, parentFolderId: -1) { [weak self](oldParentFolderId, parentFolderId) in
            guard let weakSelf = self else {return}
            /// 移动成功
            /// 取消编辑
            weakSelf.endEditing()

            /// 当前目录移动到当前目录 不刷新界面
            if oldParentFolderId == parentFolderId {
                return
            }
            
            /// 更新界面
            weakSelf.folderList = weakSelf.getUnselectedFolerList()
            weakSelf.fileList = weakSelf.getUnselectedFileList()
            weakSelf.tableView.reloadData()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc override func deleteBtnClick(sender: YXSButton) {
        let tmpFolderList = getSelectedFolerList()
        let tmpFileList = getSelectedFileList()
        
        if tmpFolderList.count > 0 || tmpFileList.count > 0 {

            var tmpFolderIdArr = [Int]()
            var tmpFileIdIdArr = [Int]()
            for (index, value) in tmpFolderList.enumerated() {
                tmpFolderIdArr.append(value.id ?? 0)
            }

            for (index, value) in tmpFileList.enumerated() {
                tmpFileIdIdArr.append(value.id ?? 0)
            }

            batchDeleteRequest(fileIdList: tmpFileIdIdArr, folderIdList: tmpFolderIdArr) { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.folderList = weakSelf.getUnselectedFolerList()
                weakSelf.fileList = weakSelf.getUnselectedFileList()
                weakSelf.tableView.reloadData()
            }
        }
    }
    
     // MARK: - 图片选择代理
    /// 拍照完成/选中视频
    override func didSelectMedia(asset: YXSMediaModel) {
        didSelectSourceAssets(assets: [asset])
    }
        
    /// 选中图片资源
    override func didSelectSourceAssets(assets: [YXSMediaModel]) {
        
        var tmpArr: [PHAsset] = [PHAsset]()
        for sub in assets {
            tmpArr.append(sub.asset)
        }
        
        MBProgressHUD.yxs_showLoading(inView: self.view)
        uploadHelper.uploadPHAssetDataSource(mediaAssets: tmpArr, storageType: .satchel, progress: { (progress) in
            
        }, sucess: { [weak self](list) in
            guard let weakSelf = self else {return}
            
            var dicArr = [[String: Any]]()
            for sub in list {
                dicArr.append(sub.toJSON())
            }
            YXSSatchelUploadFileRequest(parentFolderId: weakSelf.parentFolderId, satchelFileList: dicArr).request({ (json) in
                DispatchQueue.main.async {
                    MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
                    MBProgressHUD.yxs_showMessage(message: "上传成功")
                    weakSelf.loadData2()
                }

            }) { (msg, code) in
                DispatchQueue.main.async {
                    MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
//        uploadHelper.uploadMedias(mediaAssets: tmpArr, progress: { (progress) in
//
//        }, sucess: { [weak self](list) in
//            guard let weakSelf = self else {return}
//
//            var dicArr = [[String: Any]]()
//            for sub in list {
//                dicArr.append(sub.toJSON())
//            }
//            YXSSatchelUploadFileRequest(parentFolderId: weakSelf.parentFolderId, satchelFileList: dicArr).request({ (json) in
//                DispatchQueue.main.async {
//                    MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
//                    MBProgressHUD.yxs_showMessage(message: "上传成功")
//                    weakSelf.loadData()
//                }
//
//            }) { (msg, code) in
//                MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
//                MBProgressHUD.yxs_showMessage(message: msg)
//            }
//
//        }) { [weak self](msg, code) in
//            guard let weakSelf = self else {return}
//
//            MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
//            MBProgressHUD.yxs_showMessage(message: msg)
//        }
    }

    // MARK: - Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return folderList.count
        } else {
            return fileList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let item = folderList[indexPath.row]
            item.isEditing = isTbViewEditing
            let cell: YXSFileGroupCell = tableView.dequeueReusableCell(withIdentifier: "SLFileGroupCell") as! YXSFileGroupCell
            cell.lbTitle.text = item.folderName//"作业"
            cell.model = item
            return cell
            
        } else {
            let item = fileList[indexPath.row]
            item.isEditing = isTbViewEditing
            let cell: YXSFileCell = tableView.dequeueReusableCell(withIdentifier: "SLFileCell") as! YXSFileCell
            cell.lbTitle.text = item.fileName
            let fileSize: String = YXSFileManagerHelper.sharedInstance.stringSizeOfDataSrouce(fileSize: UInt64(item.fileSize ?? 0))
            
            cell.lbSubTitle.text = "\(fileSize) | \(item.createTime?.yxs_DayTime() ?? "")" ///"老师名 | 2020-8-16"
            
            /// 图标
            if item.bgUrl?.count ?? 0 > 0 {
                /// 首图
                cell.imgIcon.sd_setImage(with: URL(string: item.bgUrl ?? ""), placeholderImage: kImageDefualtImage)
                
            } else {
                if let url = URL(string: item.fileUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                    if let img = YXSFileManagerHelper.sharedInstance.getIconWithFileUrl(url) {
                        /// 文件类型
                        cell.imgIcon.image = img
                        
                    } else {
                        /// 图片
                        cell.imgIcon.sd_setImage(with: url, placeholderImage: kImageDefualtImage)
                    }
                }
            }
            
            /// 视频图标显示
            switch item.fileType {
            case "mp4","MP4","mov":
                cell.imgVideoTag.isHidden = false
            default:
                cell.imgVideoTag.isHidden = true
            }
            
            cell.model = item
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0  {
            return CGFloat.leastNormalMagnitude
            
        } else {
            
            return folderList.count == 0 ? CGFloat.leastNormalMagnitude : 10
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTbViewEditing == false {
            ///
            if indexPath.section == 0 {
                let item = folderList[indexPath.row]
                navigationController?.pushViewController(YXSSatchelFileViewController(parentFolderId: item.id ?? -1))
                
            } else {
                let item = fileList[indexPath.row]
                
                if item.fileType == "jpg" {
                    YXSShowBrowserHelper.showImage(urls: [URL(string: item.fileUrl ?? "")!], currentIndex: 0)
                    
                } else if item.fileType == "mp4" {
                    // 视频
                    YXSShowBrowserHelper.yxs_VedioBrowser(videoURL: URL(string: item.fileUrl ?? ""))
                } else {
                    previewFile(fileModel: item)
                }

            }
            
        } else {
            /// 编辑状态
            if indexPath.section == 0 {
                let item = folderList[indexPath.row]
                item.isSelected = item.isSelected == true ? false : true
                if item.isSelected ?? false {
                    /// 选中
                     var tmpIdx: Int? = nil
                     for (index, sub) in selectedFolderList.enumerated() {
                         if sub.id == item.id {
                             tmpIdx = index
                             break
                         }
                     }
                     if tmpIdx == nil {
                         selectedFolderList.append(item)
                     }
                    
                } else {
                    /// 取消选中
                    var tmpIdx: Int? = nil
                    for (index, sub) in selectedFolderList.enumerated() {
                        if sub.id == item.id {
                            tmpIdx = index
                            break
                        }
                    }
                    if let idx = tmpIdx {
                        selectedFolderList.remove(at: idx)
                    }
                }
                tableView.reloadRows(at: [indexPath], with: .none)
                
            } else {
                let item = fileList[indexPath.row]
                item.isSelected = item.isSelected == true ? false : true
                if item.isSelected ?? false {
                    /// 选中
                     var tmpIdx: Int? = nil
                     for (index, sub) in selectedFileList.enumerated() {
                         if sub.id == item.id {
                             tmpIdx = index
                             break
                         }
                     }
                     if tmpIdx == nil {
                         selectedFileList.append(item)
                     }
                    
                } else {
                    /// 取消选中
                    var tmpIdx: Int? = nil
                    for (index, sub) in selectedFileList.enumerated() {
                        if sub.id == item.id {
                            tmpIdx = index
                            break
                        }
                    }
                    if let idx = tmpIdx {
                        selectedFileList.remove(at: idx)
                    }
                }
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            verifyBottomViewBtnEnable()
        }
    }
    
    // MARK: 可编辑Cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .insert | .delete
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            if indexPath.section == 0 {
                let tmp = folderList[indexPath.row].id
                batchDeleteRequest(folderIdList: [tmp!]) { [weak self] in
                    guard let weakSelf = self else {return}
                    weakSelf.folderList.remove(at: indexPath.row)
                    weakSelf.tableView.reloadData()
                }
                
            } else {
                let tmp = fileList[indexPath.row].id
                batchDeleteRequest(fileIdList: [tmp!]) { [weak self] in
                    guard let weakSelf = self else {return}
                    weakSelf.fileList.remove(at: indexPath.row)
                    weakSelf.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - LazyLoad
//    lazy var btnSearch: YXSButton = {
//        let btn = YXSButton()
//        btn.setImage(UIImage(named: "yxs_chat_search"), for: .normal)
//        btn.setTitle("搜索", for: .normal)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        btn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNight2C3144)
//        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightFFFFFF), forState: .normal)
//        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightFFFFFF), forState: .highlighted)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        btn.clipsToBounds = true
//        btn.layer.cornerRadius = 22
//        btn.addTarget(self, action: #selector(searchClick(sender:)), for: .touchUpInside)
//        return btn
//    }()
    
    lazy var btnAddFileFromComputer: YXSButton = {
        let btn = YXSButton()
        btn.contentHorizontalAlignment = .left
        btn.setImage(UIImage(named: "yxs_file_computer"), for: .normal)
        btn.setTitle("试试电脑端添加文件", for: .normal)
        btn.setTitleColor(kNight898F9A, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -25)
        btn.addTarget(self, action: #selector(addFileFromComputerClick), for: .touchUpInside)
        return btn
    }()
    
//    lazy var uploadHelper: YXSFileUploadHelper = {
//        let helper = YXSFileUploadHelper()
//        return helper
//    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
