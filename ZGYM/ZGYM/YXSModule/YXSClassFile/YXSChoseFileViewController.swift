//
//  SLChoseFileViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

/// 从书包选择文件
class YXSChoseFileViewController: YXSBaseTableViewController {
    
    var parentFolderId: Int = -1
    /// 文件夹列表
    var folderList: [YXSFolderModel] = [YXSFolderModel]()
    /// 文件列表
    var fileList: [YXSFileModel] = [YXSFileModel]()
    /// 选中的文件集合
    var selectedFileList: [YXSFileModel] = [YXSFileModel]()
    
    /// 侦听下一级页面 选中的文件发生变化 刷新底部View
    var selectedItemsDidChangeBlock:((_ selectedFileList: [YXSFileModel])->())?
    
    var completionHandler:((_ selectedFileList: [YXSFileModel], _ vc: YXSChoseFileViewController)->())?
    
    init(parentFolderId: Int = -1, selectedFileList: [YXSFileModel] = [YXSFileModel](), completionHandler:((_ selectedFileList: [YXSFileModel], _ vc: YXSChoseFileViewController)->())?) {
        super.init()
        self.completionHandler = completionHandler
        self.parentFolderId = parentFolderId
        self.selectedFileList = selectedFileList
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        hasRefreshHeader = false
        showEmptyDataSource = true
        
        super.viewDidLoad()
        self.title = "选择文件"
        
        // Do any additional setup after loading the view.
        self.view.addSubview(searchBar)
        searchBar.editingChangedBlock = {[weak self](view) in
            guard let weakSelf = self else {return}
//            weakSelf.searchRequest(keyword: view.text ?? "") { [weak self](list) in
//                guard let weakSelf = self else {return}
//                DispatchQueue.main.async {
//                    weakSelf.fileList = list
//                    weakSelf.tableView.reloadData()
//                }
//            }
            
            // 出组
            YXSSatchelFilePageQueryRequest(currentPage: 1, parentFolderId: weakSelf.parentFolderId, keyword: view.text ?? "").request({ [weak self](json) in
                guard let weakSelf = self else {return}
//                let hasNext = json["hasNext"].boolValue
//                weakSelf.loadMore = hasNext
                DispatchQueue.main.async {
                    weakSelf.fileList = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
                    for sub in weakSelf.selectedFileList {
                        for obj in weakSelf.fileList {
                            if sub.id == obj.id {
                                obj.isSelected = true
                                break
                            }
                        }
                    }
                    weakSelf.tableView.reloadData()
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
        searchBar.snp.makeConstraints({ (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                // Fallback on earlier versions
                make.top.equalTo(0)
            }
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        /// 初始化
        var size = 0
        for sub in selectedFileList {
            size += sub.fileSize ?? 0
        }
        totalSize = UInt(size)
        
        tableView.backgroundColor = kTableViewBackgroundColor
        tableView.register(YXSFileGroupCell.classForCoder(), forCellReuseIdentifier: "SLFileGroupCell")
        tableView.register(YXSFileAbleSlectedCell.classForCoder(), forCellReuseIdentifier: "SLFileAbleSlectedCell")
        
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(searchBar.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
            
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(tableView.snp_bottom).offset(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(60)
        })
    }
    
    // MARK: - Request
    override func yxs_refreshData() {
        loadData(keyword: "")
//        searchRequest(keyword: "") { [weak self](list) in
//            guard let weakSelf = self else {return}
//            DispatchQueue.main.async {
//                weakSelf.fileList.removeAll()
//                weakSelf.fileList = list
//                weakSelf.tableView.reloadData()
//                weakSelf.yxs_endingRefresh()
//            }
//        }
    }
    
    override func yxs_loadNextPage() {
        loadData(keyword: "")
//        searchRequest(keyword: "") { [weak self](list) in
//            guard let weakSelf = self else {return}
//            DispatchQueue.main.async {
//                weakSelf.fileList += list
//                weakSelf.tableView.reloadData()
//                weakSelf.yxs_endingRefresh()
//            }
//        }
    }
    
     @objc func loadData(keyword:String) {
            
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        var tmpFolderList = [YXSFolderModel]()
        var tmpFileList = [YXSFileModel]()
        
        // 入组
        workingGroup.enter()
        workingQueue.async {
            // 出组
            YXSSatchelFolderPageQueryRequest(currentPage: 1, parentFolderId: self.parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
//                let hasNext = json["hasNext"].boolValue
//                weakSelf.loadMore = hasNext
                
                tmpFolderList = Mapper<YXSFolderModel>().mapArray(JSONString: json["satchelFolderList"].rawString()!) ?? [YXSFolderModel]()
                workingGroup.leave()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
        // 入组
        workingGroup.enter()
        workingQueue.async {
            // 出组
            YXSSatchelFilePageQueryRequest(currentPage: self.curruntPage, parentFolderId: self.parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let hasNext = json["hasNext"].boolValue
                weakSelf.loadMore = hasNext
                
                tmpFileList = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
                workingGroup.leave()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        }

        // 调度组里的任务都执行完毕
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                /// 填充选中的Cell
                for sub in self.selectedFileList {
                    for obj in tmpFileList {
                        if sub.id == obj.id {
                            obj.isSelected = true
                            break
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
    
    @objc func searchRequest(keyword:String, completionHandler:((_ result: [YXSFileModel])->())?) {
        
        YXSSatchelDocFilePageQueryRequest(currentPage: self.curruntPage, keyword: keyword).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            let hasNext = json["hasNext"].boolValue
            weakSelf.loadMore = hasNext
            
            let list = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
            
            /// 填充选中状态
            for sub in weakSelf.selectedFileList {
                for item in list {
                    if sub.id == item.id {
                        item.isSelected = sub.isSelected
                        break
                    }
                }
            }
            
            completionHandler?(list)
            
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            
            MBProgressHUD.yxs_showMessage(message: msg)
            weakSelf.yxs_endingRefresh()
        }
    }
    
    // MARK: - Setter
    /// 选中的文件总大小 kb
    var totalSize: UInt = 0 {
        didSet {
            bottomView.lbSize.text = YXSFileManagerHelper.sharedInstance.stringSizeOfDataSrouce(fileSize: UInt64(self.totalSize))
            bottomView.btnDone.setTitle("确定(\(selectedFileList.count))", for: .normal)
        }
    }
    
    // MARK: - Action
    @objc func doneClick(sender: YXSButton) {
        /// 赋值satchelFileId字段 原因服务器需要知道文件是从书包过来的
        for sub in selectedFileList {
            sub.satchelFileId = sub.id
        }
        completionHandler?(selectedFileList, self)
    }
    
    @objc func cancelClick(sender:YXSButton) {
        self.navigationController?.popViewController()
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
            let cell: YXSFileGroupCell = tableView.dequeueReusableCell(withIdentifier: "SLFileGroupCell") as! YXSFileGroupCell
            cell.model = item
            cell.lbTitle.text = item.folderName
            return cell

        } else {
            let item = fileList[indexPath.row]//[indexPath.row]
            let cell: YXSFileAbleSlectedCell = tableView.dequeueReusableCell(withIdentifier: "SLFileAbleSlectedCell") as! YXSFileAbleSlectedCell
            cell.lbTitle.text = item.fileName
            let fileSize: String = YXSFileManagerHelper.sharedInstance.stringSizeOfDataSrouce(fileSize: UInt64(item.fileSize ?? 0))
            cell.lbSubTitle.text = fileSize
            cell.lbThirdTitle.text = "\(item.createTime?.yxs_DayTime() ?? "")"
            
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = folderList[indexPath.row]
            
            let vc = YXSChoseFileViewController(parentFolderId: item.id ?? 0, selectedFileList: selectedFileList) { [weak self](list, vc) in
                guard let weakSelf = self else {return}
                weakSelf.completionHandler?(list, vc)
            }
            
            /// 侦听下一级页面 选中的文件发生变化 刷新底部View
            vc.selectedItemsDidChangeBlock = { [weak self] (list) in
                 guard let weakSelf = self else {return}
                 weakSelf.selectedFileList = list
                 var size = 0
                 for sub in list {
                     size += sub.fileSize ?? 0
                 }
                 weakSelf.totalSize = UInt(size)
             }

            navigationController?.pushViewController(vc)
            
        } else {
            let cell: YXSFileAbleSlectedCell = tableView.cellForRow(at: indexPath) as! YXSFileAbleSlectedCell
            cell.btnSelect.isSelected = !cell.btnSelect.isSelected
            
            let fileItem = fileList[indexPath.row]
            fileItem.isSelected = cell.btnSelect.isSelected
            
            if cell.btnSelect.isSelected {
                /// 选中
                var tmpIdx: Int? = nil
                for (index, sub) in selectedFileList.enumerated() {
                    if sub.id == fileItem.id {
                        tmpIdx = index
                        break
                    }
                }
                if tmpIdx == nil {
                    selectedFileList.append(fileItem)
                    totalSize += UInt(fileItem.fileSize ?? 0)
                }

            } else {
                /// 取消选中
                var tmpIdx: Int? = nil
                for (index, sub) in selectedFileList.enumerated() {
                    if sub.id == fileItem.id {
                        tmpIdx = index
                        break
                    }
                }
                if let idx = tmpIdx {
                    selectedFileList.remove(at: idx)
                    totalSize -= UInt(fileItem.fileSize ?? 0)
                }
            }
            selectedItemsDidChangeBlock?(selectedFileList)
        }
    }
    
    // MARK: - Other
//    @objc func getSelectedFileList() -> [YXSFileModel] {
//        var tmpArr = [YXSFileModel]()
//        for sub in fileList {
//            if sub.isSelected ?? false {
//                tmpArr.append(sub)
//            }
//        }
//        return tmpArr
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - LazyLoad
    lazy var searchBar: YXSSearchView = {
        let view = YXSSearchView(frame: CGRect.zero)
        view.lbTitle.font = UIFont.systemFont(ofSize: 14)
        view.tfInput.font = UIFont.systemFont(ofSize: 14)
        view.tfInput.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        view.btnCancel.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        view.tfInput.snp.updateConstraints({ (make) in
            make.height.equalTo(32)
        })
        view.bgMask.cornerRadius = 16
        return view
    }()
    
    lazy var bottomView: SLChoseFileBottomView = {
        let view = SLChoseFileBottomView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        view.btnDone.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    // MARK: - EmptyView
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  UIImage.init(named: "yxs_empty_file")
    }

    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "没有文件"
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(18)),
                          NSAttributedString.Key.foregroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
}

class SLChoseFileBottomView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(lbSize)
        self.addSubview(btnDone)
        
        lbSize.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(15)
        })
        
        btnDone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-10)
            make.width.equalTo(214)
            make.height.equalTo(40)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var lbSize: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "已选择：0KB"
        lb.textColor = k222222Color
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("确定(0)", for: .normal)
        btn.setTitleColor(kNightFFFFFF, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 214, height: 40), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20)
        btn.clipsToBounds = false
        return btn
    }()
}
