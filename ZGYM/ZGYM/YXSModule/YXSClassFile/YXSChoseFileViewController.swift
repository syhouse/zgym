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
    ///
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
        tableView.backgroundColor = kTableViewBackgroundColor
        tableView.register(YXSFileGroupCell.classForCoder(), forCellReuseIdentifier: "SLFileGroupCell")
        tableView.register(YXSFileAbleSlectedCell.classForCoder(), forCellReuseIdentifier: "SLFileAbleSlectedCell")
        
        tableView.snp.remakeConstraints { (make) in
            make.left.top.right.equalTo(0)
        }
            
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
        loadData()
        yxs_endingRefresh()
    }
    
    @objc func loadData() {
        
        YXSSatchelDocFilePageQueryRequest(currentPage: self.curruntPage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            let hasNext = json["hasNext"]
            
            weakSelf.fileList = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
//            self.tableView.reloadData()
            weakSelf.tableView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        return
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        // 入组
        workingGroup.enter()
        workingQueue.async {
            // 出组
            YXSSatchelFolderPageQueryRequest(currentPage: self.curruntPage, parentFolderId: self.parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let hasNext = json["hasNext"]
                
                weakSelf.folderList = Mapper<YXSFolderModel>().mapArray(JSONString: json["satchelFolderList"].rawString()!) ?? [YXSFolderModel]()
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
                let hasNext = json["hasNext"]
                
                weakSelf.fileList = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
                workingGroup.leave()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        }

        // 调度组里的任务都执行完毕
        workingGroup.notify(queue: workingQueue) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        completionHandler?(selectedFileList, self)
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return folderList.count
//        } else {
            return fileList.count
//        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let item = folderList[indexPath.row]
//            let cell: YXSFileGroupCell = tableView.dequeueReusableCell(withIdentifier: "SLFileGroupCell") as! YXSFileGroupCell
//            cell.model = item
//            cell.lbTitle.text = item.folderName
//            return cell
//
//        } else {
            let item = fileList[indexPath.row]//[indexPath.row]
            let cell: YXSFileAbleSlectedCell = tableView.dequeueReusableCell(withIdentifier: "SLFileAbleSlectedCell") as! YXSFileAbleSlectedCell
            cell.lbTitle.text = item.fileName
            let fileSize: String = YXSFileManagerHelper.sharedInstance.stringSizeOfDataSrouce(fileSize: UInt64(item.fileSize ?? 0))
            cell.lbSubTitle.text = fileSize
            cell.lbThirdTitle.text = "\(item.createTime?.yxs_DayTime() ?? "")"
            
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
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//           let folderItem = folderList[indexPath.row]
//            let vc = YXSChoseFileViewController(parentFolderId: folderItem.id ?? 0, selectedFileList: selectedFileList, completionHandler: completionHandler)
//            vc.totalSize = totalSize
//            navigationController?.pushViewController(vc)
//
//        } else {
            let cell: YXSFileAbleSlectedCell = tableView.cellForRow(at: indexPath) as! YXSFileAbleSlectedCell
            cell.btnSelect.isSelected = !cell.btnSelect.isSelected
            
            let fileItem = fileList[indexPath.row]
            if cell.btnSelect.isSelected {
                /// 选中
                if selectedFileList.contains(fileItem) == false {
                    selectedFileList.append(fileItem)
                    totalSize += UInt(fileItem.fileSize ?? 0)
                }
                
                
            } else {
                /// 取消选中
                if selectedFileList.contains(fileItem) == true {
                    if let indx = selectedFileList.firstIndex(of: fileItem) {
                        selectedFileList.remove(at: indx)
                        totalSize -= UInt(fileItem.fileSize ?? 0)
                    }
                }
            }
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - LazyLoad
    lazy var bottomView: SLChoseFileBottomView = {
        let view = SLChoseFileBottomView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        view.btnDone.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return view
    }()
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
