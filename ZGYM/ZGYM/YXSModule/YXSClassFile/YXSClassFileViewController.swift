//
//  YXSClassFileViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
import Photos

/// 班级文件
class YXSClassFileViewController: YXSBaseTableViewController, YXSSelectMediaHelperDelegate {

    /// 页面是否在编辑状态
    var isTbViewEditing: Bool = false
    var classId: Int = -1
    var parentFolderId: Int = -1
    /// 文件夹列表
    var folderList: [YXSFolderModel] = [YXSFolderModel]()
    /// 文件列表
    var fileList: [YXSFileModel] = [YXSFileModel]()
    
    private var navRightBtn: YXSButton = YXSButton()
    
    init(classId: Int, parentFolderId: Int) {
        super.init()
        
        self.classId = classId
        self.parentFolderId = parentFolderId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "班级文件"
        
        view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        
        tableView.register(YXSFileGroupCell.classForCoder(), forCellReuseIdentifier: "SLFileGroupCell")
        tableView.register(YXSFileCell.classForCoder(), forCellReuseIdentifier: "SLFileCell")
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            setupRightBarButtonItem()
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(tableViewLongPress(gestureRecognizer:)))
            tableView.addGestureRecognizer(longPress)
        }
        
        view.addSubview(btnSearch)
        btnSearch.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        })
                
                
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(btnSearch.snp_bottom).offset(14)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        view.insertSubview(bottomView, aboveSubview: tableView)
        bottomView.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(60) /// 让其伸出屏幕
            make.height.equalTo(60)
        })
    }
    
    func setupRightBarButtonItem() {
        let btnAdd = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnAdd.setTitle("添加", for: .normal)
        btnAdd.setTitle("取消", for: .selected)
        btnAdd.setTitleColor(k575A60Color, for: .normal)
        btnAdd.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btnAdd.addTarget(self, action: #selector(addFileClick), for: .touchUpInside)
        navRightBtn = btnAdd
        
        let navShareItem = UIBarButtonItem(customView: navRightBtn)
        self.navigationItem.rightBarButtonItems = [navShareItem]
    }
    
    // MARK: - Request
    override func yxs_refreshData() {
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    @objc func loadData() {
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        var tmpFolderList = [YXSFolderModel]()
        var tmpFileList = [YXSFileModel]()
        
        // 入组
        workingGroup.enter()
        workingQueue.async {
            // 出组
            YXSFileFolderPageQueryRequest(classId: self.classId, currentPage: 1, folderId: self.parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let hasNext = json["hasNext"]
                
                tmpFolderList = Mapper<YXSFolderModel>().mapArray(JSONString: json["classFolderList"].rawString()!) ?? [YXSFolderModel]()
                workingGroup.leave()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
        // 入组
        workingGroup.enter()
        workingQueue.async {
            // 出组
            YXSFilePageQueryRequest(classId: self.classId, currentPage: self.curruntPage, folderId: self.parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                
                let hasNext = json["hasNext"].boolValue
                weakSelf.loadMore = hasNext
                
                tmpFileList = Mapper<YXSFileModel>().mapArray(JSONString: json["classFileList"].rawString()!) ?? [YXSFileModel]()
                workingGroup.leave()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }

        // 调度组里的任务都执行完毕
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                if self.isTbViewEditing {
                    /// 编辑状态 下拉刷新 填充选中的Cell
                    for sub in self.getSelectedFolerList() {
                        for obj in tmpFolderList {
                            if sub.id == obj.id {
                                obj.isSelected = true
                                break
                            }
                        }
                    }
                    

                    for sub in self.getSelectedFileList() {
                        for obj in tmpFileList {
                            if sub.id == obj.id {
                                obj.isSelected = true
                                break
                            }
                        }
                    }
                }
                
                if self.curruntPage == 1{
                    self.fileList.removeAll()
                }
                
                self.folderList = tmpFolderList
                self.fileList += tmpFileList
                
                self.tableView.reloadData()
                self.yxs_endingRefresh()
            }
        }
    }
    
    /// 批量删除
    @objc func batchDeleteRequest(fileIdList:[Int] = [Int](), folderIdList:[Int] = [Int](), completionHandler:(()->Void)?) {
        
        let alert = YXSConfirmationAlertView.showIn(target: self.view) { [weak self](sender, view) in
            guard let weakSelf = self else {return}
            if sender.titleLabel?.text == "删除" {
                YXSFileBatchDeleteRequest(classId: weakSelf.classId, fileIdList: fileIdList, folderIdList: folderIdList, parentFolderId: weakSelf.parentFolderId).request({ (json) in
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
        alert.lbContent.text = "删除文件夹会同时删除该文件夹内所有文件，确定要删除吗?"
        alert.btnDone.setTitle("删除", for: .normal)
        

    }
    
    // MARK: - Action
    @objc func addFileClick() {
        if isTbViewEditing {
            endEditing()
            
        } else {
            let lists = [YXSCommonBottomParams.init(title: "从相册选择", event: "album"),YXSCommonBottomParams.init(title: "从我的文件选择", event: "bag"),YXSCommonBottomParams.init(title: "新建文件夹", event: "createFolder")]
            
            YXSCommonBottomAlerView.showIn(buttons: lists) { [weak self](model) in
                guard let strongSelf = self else { return }
                switch model.event {
                case "album":
                    strongSelf.selectedFromAlbumClick()
                case "bag":
                    strongSelf.selectedFromBagClick()
                case "createFolder":
                    strongSelf.createFolderClick()
                default:
                    break
                }
            }
        }
    }
    
    @objc func selectedFromAlbumClick() {
        YXSSelectMediaHelper.shareHelper.pushImagePickerController(mediaStyle: SLSelectMediaStyle.bothImageVideoGif, showTakePhoto: false, maxCount: 30)
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    @objc func selectedFromBagClick() {
        let vc = YXSChoseFileViewController { [weak self](choseFileList, vc) in
            guard let weakSelf = self else {return}
            
            YXSFileUploadFileRequest(classId: weakSelf.classId, folderId: weakSelf.parentFolderId, classFileList: choseFileList).request({ (json) in
                DispatchQueue.main.async {
                    weakSelf.loadData()
                    vc.navigationController?.popViewController()
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        navigationController?.pushViewController(vc)
    }
    
    @objc func createFolderClick() {
        let view = YXSInputAlertView2.showIn(target: self.view) { [weak self](result, btn) in
            guard let weakSelf = self else {return}
            if btn.titleLabel?.text == "创建" {
                YXSFileCreateFolderRequest(classId: weakSelf.classId, folderName: result, parentId: weakSelf.parentFolderId).request({ [weak self](json) in
                    guard let weakSelf = self else {return}
                    weakSelf.loadData()
                    
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
    
    @objc func searchClick(sender: YXSButton) {
        let vc = YXSSearchFileViewController(searchType: .classFile, classId: classId)
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func tableViewLongPress(gestureRecognizer:UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizer.State.began) {

            if(isTbViewEditing == false) {
                beginEditing()
                
            } else {
                endEditing()
            }
        }
    }
    
    // MARK: -重命名、移动、删除
    @objc func renameBtnClick(sender: YXSButton) {
        
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
                        YXSFileRenameFolderRequest(classId: weakSelf.classId, folderId: tmpItem?.id ?? 0, folderName: result).request({ [weak self](json) in
                            guard let weakSelf = self else {return}
                            tmpItem?.folderName = result
                            weakSelf.tableView.reloadSections([0], with: .none)
                            
                        }) { (msg, code) in
                            
                        }
                        
                    } else if tmpFileList.count == 1 {
                        /// 文件更名
                        let tmpItem = tmpFileList.first
                        let fileName = "\(result).\(tmpItem?.fileType ?? "")"
                        YXSFileRenameFileRequest(classId: weakSelf.classId, folderId: weakSelf.parentFolderId, fileId: tmpItem?.id ?? 0, fileName: fileName).request({ [weak self](json) in
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
    
    @objc func moveBtnClick(sender: YXSButton) {
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
        
        let vc = YXSMoveToViewController(classId: classId, folderIdList: selectedFolderList, fileIdList: selectedFileList, oldParentFolderId: -1, parentFolderId: -1) { [weak self](oldParentFolderId, parentFolderId) in
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
    
    @objc func deleteBtnClick(sender: YXSButton) {
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
    func didSelectMedia(asset: YXSMediaModel) {
        didSelectSourceAssets(assets: [asset])
    }
    
    /// 选中图片资源
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        var tmpArr: [PHAsset] = [PHAsset]()
        for sub in assets {
            tmpArr.append(sub.asset)
        }
        
        MBProgressHUD.yxs_showLoading(inView: self.view)

        uploadHelper.uploadPHAssetDataSource(mediaAssets: tmpArr, storageType: .classFile, classId: self.classId, progress: { (progress) in
            
        }, sucess: { [weak self](list) in
            guard let weakSelf = self else {return}
            
            var dicArr = [[String: Any]]()
            for sub in list {
                dicArr.append(sub.toJSON())
            }
            YXSFileUploadFileRequest(classId: weakSelf.classId, folderId: weakSelf.parentFolderId, classFileList: dicArr).request({ (json) in
                DispatchQueue.main.async {
                    MBProgressHUD.yxs_hideHUDInView(view: weakSelf.view)
                    MBProgressHUD.yxs_showMessage(message: "上传成功")
                    weakSelf.loadData()
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
//            YXSFileUploadFileRequest(classId: weakSelf.classId, folderId: weakSelf.parentFolderId, classFileList: dicArr).request({ (json) in
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
    
    // MARK: - Other
    /// 预览文件
    @objc func previewFile(fileModel: YXSFileModel) {
        let wk = YXSBaseWebViewController()
        wk.loadUrl = fileModel.fileUrl
        wk.title = fileModel.fileName
        navigationController?.pushViewController(wk)
    }
    
    @objc func saveImageFileToDocument(image: UIImage) {

    }
    
    /// 检测重命名按钮可否点击
    @objc func verifyBottomViewBtnEnable() {
        var selectedCount = 0
        for sub in folderList {
            if sub.isSelected == true {
                selectedCount += 1
            }
        }
        
        for sub in fileList {
            if sub.isSelected == true {
                selectedCount += 1
            }
        }
        
        bottomView.btnFirst.isEnabled = selectedCount == 1 ? true : false
        bottomView.btnSecond.isEnabled = selectedCount < 1 ? false : true
        bottomView.btnThird.isEnabled = selectedCount < 1 ? false : true
    }
    
    /// 进入编辑状态
    @objc func beginEditing() {
        isTbViewEditing = true
        
        navRightBtn.isSelected = true
        
        for sub in folderList {
            sub.isEditing = true
        }
        
        for sub in fileList {
            sub.isEditing = true
        }
        
        bottomView.isHidden = false
        verifyBottomViewBtnEnable()
        UIView.animate(withDuration: 0.3) {
            self.bottomView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(0)
            })
            
            self.tableView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-60)
            })
            self.view.layoutIfNeeded()
        }
        tableView.reloadData()
    }
    
    /// 退出编辑状态
    @objc func endEditing() {
        isTbViewEditing = false
        
        navRightBtn.isSelected = false

        for sub in folderList {
             sub.isEditing = false
        }
        
        for sub in fileList {
             sub.isEditing = false
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.snp.updateConstraints({ (make) in
                 make.bottom.equalTo(60)
            })
            
            self.tableView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(0)
            })
            self.view.layoutIfNeeded()
            
        }) { (result) in
             self.bottomView.isHidden = true
        }
        tableView.reloadData()
    }
    
    // MARK: -Tool
    @objc func getSelectedFolerList() -> [YXSFolderModel] {
        var tmpArr = [YXSFolderModel]()
        for sub in folderList {
            if sub.isSelected ?? false {
                tmpArr.append(sub)
            }
        }
        return tmpArr
    }
    
    @objc func getSelectedFileList() -> [YXSFileModel] {
        var tmpArr = [YXSFileModel]()
        for sub in fileList {
            if sub.isSelected ?? false {
                tmpArr.append(sub)
            }
        }
        return tmpArr
    }
    
    
    
    @objc func getUnselectedFolerList() -> [YXSFolderModel] {
        var tmpArr = [YXSFolderModel]()
        for sub in folderList {
            if !(sub.isSelected ?? false) {
                tmpArr.append(sub)
            }
        }
        return tmpArr
    }
    
    @objc func getUnselectedFileList() -> [YXSFileModel] {
        var tmpArr = [YXSFileModel]()
        for sub in fileList {
            if !(sub.isSelected ?? false) {
                tmpArr.append(sub)
            }
        }
        return tmpArr
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
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
            cell.model = item
            cell.lbTitle.text = item.folderName//"作业"
            return cell
            
        } else {
            let item = fileList[indexPath.row]
            item.isEditing = isTbViewEditing
            let cell: YXSFileCell = tableView.dequeueReusableCell(withIdentifier: "SLFileCell") as! YXSFileCell
            cell.lbTitle.text = item.fileName
            let fileSize: String = YXSFileManagerHelper.sharedInstance.stringSizeOfDataSrouce(fileSize: UInt64(item.fileSize ?? 0))
            cell.lbSubTitle.text = "\(fileSize) | \(item.createTime?.yxs_DayTime() ?? "")" ///"老师名 | 2020-8-16"
            
            if let url = URL(string: item.fileUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                if let img = YXSFileManagerHelper.sharedInstance.getIconWithFileUrl(url) {
                    cell.imgIcon.image = img
                    
                } else {
                    let strIcon = item.bgUrl?.count ?? 0 > 0 ? item.bgUrl : item.fileUrl
                    cell.imgIcon.sd_setImage(with: URL(string: strIcon ?? ""), placeholderImage: kImageDefualtImage)
                }
            }
            cell.model = item
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0  {
            return CGFloat.leastNormalMagnitude
            
        } else {
            
            return folderList.count == 0 ? CGFloat.leastNormalMagnitude : 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTbViewEditing == false {
            
            if indexPath.section == 0 {
                let item = folderList[indexPath.row]
                navigationController?.pushViewController(YXSClassFileViewController(classId: classId, parentFolderId: item.id ?? -1))
                
            } else {
                let item = fileList[indexPath.row]
                
                if item.fileType == "jpg" {
                    YXSShowBrowserHelper.showImage(urls: [URL(string: item.fileUrl ?? "")!], curruntIndex: 0)
                    
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
                tableView.reloadRows(at: [indexPath], with: .none)
                
            } else {
                let item = fileList[indexPath.row]
                item.isSelected = item.isSelected == true ? false : true
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            verifyBottomViewBtnEnable()
        }
    }

    // MARK: 可编辑Cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            return true
        } else {
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

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
    lazy var btnSearch: YXSButton = {
        let btn = YXSButton()
        btn.setImage(UIImage(named: "yxs_chat_search"), for: .normal)
        btn.setTitle("搜索", for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNight2C3144)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightFFFFFF), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightFFFFFF), forState: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(searchClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var bottomView: YXSClassFileBottomView = {
        let view = YXSClassFileBottomView()
//        view.backgroundColor = UIColor.red
        view.isHidden = true
        view.btnFirst.addTarget(self, action: #selector(renameBtnClick(sender:)), for: .touchUpInside)
        view.btnSecond.addTarget(self, action: #selector(moveBtnClick(sender:)), for: .touchUpInside)
        view.btnThird.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var uploadHelper: YXSFileUploadHelper = {
        let helper = YXSFileUploadHelper()
        return helper
    }()
    
    // MARK: - EmptyView
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  NightNight.theme == nil ? UIImage.init(named: "yxs_empty_file") : UIImage(named: "yxs_empty_file")
    }

    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "没有文件"
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(18)),
                          NSAttributedString.Key.foregroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


class YXSClassFileBottomView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        addSubview(btnFirst)
        addSubview(btnSecond)
        addSubview(btnThird)
        
        btnFirst.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(btnSecond.snp_width)
        })
        
        btnSecond.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(btnFirst.snp_right)
            make.bottom.equalTo(0)
            make.width.equalTo(btnThird.snp_width)
        })
        
        btnThird.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(btnSecond.snp_right)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(btnFirst.snp_width)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var btnFirst: YXSButton = {
        let btn = YXSButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/3.0, height: 60.0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("重命名", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: k575A60Color), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1"), night: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1")), forState: .disabled)
        btn.setMixedImage(MixedImage(normal: "yxs_file_edit_1", night: "yxs_file_edit_1"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_file_edit_2", night: "yxs_file_edit_2"), forState: .disabled)
        btn.yxs_setIconInTopWithSpacing(4)
        return btn
    }()
    
    lazy var btnSecond: YXSButton = {
        let btn = YXSButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/3.0, height: 60.0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("移动", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: k575A60Color), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1"), night: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1")), forState: .disabled)
        btn.setMixedImage(MixedImage(normal: "yxs_file_move", night: "yxs_file_move"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_file_move_2", night: "yxs_file_move_2"), forState: .disabled)
        btn.yxs_setIconInTopWithSpacing(4)
        return btn
    }()
    
    lazy var btnThird: YXSButton = {
        let btn = YXSButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/3.0, height: 60.0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("删除", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: k575A60Color), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1"), night: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1")), forState: .disabled)
        btn.setMixedImage(MixedImage(normal: "yxs_file_delete", night: "yxs_file_delete"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_file_delete_2", night: "yxs_file_delete_2"), forState: .disabled)
        btn.yxs_setIconInTopWithSpacing(4)
        return btn
    }()
}
