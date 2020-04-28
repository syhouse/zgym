//
//  YXSSelectAccessoryVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/26.
//  Copyright © 2020 zgym. All rights reserved.
//  选择附件上传

import Foundation
import NightNight
import ObjectMapper

class YXSSelectAccessoryVC: YXSBaseTableViewController {
    
    var parentFolderId: Int = -1
    /// 文件夹列表
    var folderList: [YXSFolderModel] = [YXSFolderModel]()
    /// 文件列表
    var fileList: [YXSFileModel] = [YXSFileModel]()

//    var completionHandler:((_ selectedFileList: [YXSFileModel])->())?
    /// 已选择的文件
    var selectFiles:[YXSFileModel] = [YXSFileModel]()
    var maxSelectCount: Int = 9
    var compelect:((_ selectFiles: [YXSFileModel]?) ->())?
    
    init(parentFolderId: Int = -1,priorList: [YXSFileModel] = [YXSFileModel](),maxSelectCount: Int = 9,compelect:((_ selectFiles: [YXSFileModel]?) ->())? = nil) {
        super.init()
        self.compelect = compelect
        self.maxSelectCount = maxSelectCount
        self.parentFolderId = parentFolderId
        if priorList.count > 0 {
            self.selectFiles = priorList
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择附件"
        view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        view.addSubview(btnSearch)
        view.addSubview(bottomView)
        btnSearch.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        })
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(btnSearch.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(bottomView.snp_top)
        })
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(60)
        }
        tableView.register(YXSFileGroupCell.classForCoder(), forCellReuseIdentifier: "SLFileGroupCell")
        tableView.register(YXSFileAbleSlectedCell.classForCoder(), forCellReuseIdentifier: "YXSFileAbleSlectedCell")
        self.refreshBottomView()
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            yxs_setNavBack()
        } else {
            yxs_setNavLeftTitle(title: "取消")
        }
    }
    
    // MARK: - Request
    override func yxs_refreshData() {
        loadData()
        yxs_endingRefresh()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData() {
        YXSSatchelDocFilePageQueryRequest(currentPage: self.curruntPage).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.yxs_endingRefresh()
            let list = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
            if weakSelf.curruntPage == 1{
                weakSelf.fileList.removeAll()
            }
            weakSelf.fileList += list
            weakSelf.loadMore = json["hasNext"].boolValue
            weakSelf.fileList = list
            weakSelf.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func refreshBottomView(){
        var fileSize: Int = 0
        let selectFileCount = selectFiles.count
        if selectFiles.count > 0 {
            for file in selectFiles {
                fileSize += file.fileSize ?? 0
            }
        }
        bottomLbl.text = "已选择: \(self.fileSizeOfString(size: fileSize))"
        bottomBtn.setTitle("确定(\(selectFileCount))", for: .normal)
        if selectFileCount > 0 {
            bottomBtn.isEnabled = true
            bottomBtn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 200, height: 40), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20)
        } else {
            bottomBtn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 200, height: 40), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 20)
        }
        
    }
    
    func fileSizeOfString(size: Int) -> String {
        if size < 1024 {
            /// 返回kb
            return "\(size)KB"
        } else if size < 1024*1024 {
            /// 返回MB
            let f = Float(size) / 1024.0
            return String(format: "%.2fMB", f)
        } else {
            let f = Float(size) / 1024.0 / 1024.0
            return String(format: "%.2fG", f)
        }
    }
    
    // MARK: - Action
    @objc func okClick(sender: YXSButton) {
        if self.navigationController?.viewControllers.count ?? 0 > 1 {            
            let vc:YXSSelectAccessoryVC = self.navigationController?.viewControllers.first as! YXSSelectAccessoryVC
            vc.compelect?(selectFiles)
            self.dismiss(animated: true, completion: nil)
        } else {
            compelect?(selectFiles)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func searchClick(sender: YXSButton) {
        
    }
    
    @objc override func yxs_onBackClick(){
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            var selectList:[YXSFileModel] = selectFiles
            if selectFiles.count > 0 {
                selectList = selectFiles
            }
            self.compelect?(selectList)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let item = folderList[indexPath.row]
            let cell: YXSFileGroupCell = tableView.dequeueReusableCell(withIdentifier: "SLFileGroupCell") as! YXSFileGroupCell
            cell.model = item
            cell.lbTitle.text = item.folderName//"作业"
            return cell
            
        } else {
            let item = fileList[indexPath.row]//[indexPath.row]
            let cell: YXSFileAbleSlectedCell = tableView.dequeueReusableCell(withIdentifier: "YXSFileAbleSlectedCell") as! YXSFileAbleSlectedCell
            cell.lbTitle.text = item.fileName
            cell.lbSubTitle.text = "\(item.fileSize ?? 0)KB"
            cell.lbThirdTitle.text = "\(item.createTime?.yxs_DayTime() ?? "")"
            let strIcon = item.bgUrl?.count ?? 0 > 0 ? item.bgUrl : item.fileUrl
            cell.imgIcon.sd_setImage(with: URL(string: strIcon ?? ""), placeholderImage: kImageDefualtImage)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = folderList[indexPath.row]
            let vc = YXSSelectAccessoryVC(parentFolderId: item.id ?? -1,priorList: selectFiles,maxSelectCount: self.maxSelectCount) { [weak self](selectList)in
                guard let weakSelf = self else { return }
                if let list = selectList, list.count > 0 {
                    weakSelf.selectFiles = list
                    weakSelf.refreshBottomView()
                }
            }
            navigationController?.pushViewController(vc)
        } else {
            let item = fileList[indexPath.row]
            if !(item.isSelected ?? false) {
                if selectFiles.count >= self.maxSelectCount {
                    MBProgressHUD.yxs_showMessage(message: "最多只能选择\(self.maxSelectCount)个文件")
                    return
                }
            }
            item.isSelected = item.isSelected == true ? false : true
            tableView.reloadRows(at: [indexPath], with: .none)
            if item.isSelected ?? false {
                
                selectFiles = selectFiles.filter {$0.id != item.id}
                selectFiles.append(item)
            } else {
                selectFiles = selectFiles.filter {$0.id != item.id}
            }
            self.refreshBottomView()
        }
    }
    
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
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        view.addSubview(self.bottomLbl)
        view.addSubview(self.bottomBtn)
        let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
        view.yxs_addLine(position: .top, color: cl, lineHeight: 0.5)
        return view
    }()
    
    lazy var bottomLbl: YXSLabel = {
        let lbl = YXSLabel.init(frame: CGRect(x: 15, y: 10, width: SCREEN_WIDTH - 230, height: 40))
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.text = "已选择: 0KB"
        return lbl
    }()
    
    lazy var bottomBtn: YXSButton = {
        let btn = YXSButton.init(frame: CGRect(x: SCREEN_WIDTH - 211, y: 10, width: 200, height: 40))
        btn.isEnabled = false
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 200, height: 40), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0"), cornerRadius: 20)
        btn.setTitle("确定(0)", for: .normal)
        btn.addTarget(self, action: #selector(okClick(sender:)), for: .touchUpInside)
//        btn.addTarget(self, action: #selector(doneBtnClick()), for: .touchUpInside)
        btn.setMixedTitleColor(MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: kNight898F9A, night: kNight898F9A), forState: .disabled)
        return btn
    }()
    
}
