//
//  YXSSearchFileViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/6.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

/// 文件搜索界面
class YXSSearchFileViewController: YXSBaseTableViewController {

    /// 文件列表
    var fileList: [YXSFileModel] = [YXSFileModel]()
    
    override func viewDidLoad() {
        self.tableViewIsGroup = true
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
        fd_prefersNavigationBarHidden = true
        
        super.viewDidLoad()
        self.title = ""
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            yxs_setNavBack()
        }
        // Do any additional setup after loading the view.
        
        searchBar.editingChangedBlock = {[weak self](view) in
            guard let weakSelf = self else {return}
            weakSelf.searchRequest(keyword: view.text ?? "") { (list) in
                DispatchQueue.main.async {
                    weakSelf.fileList = list
                    weakSelf.tableView.reloadData()
                }
            }
        }
        self.view.addSubview(searchBar)
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
        
        
        tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        tableView.register(YXSFileCell.classForCoder(), forCellReuseIdentifier: "SLFileCell")
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(searchBar.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
    }
    
    @objc func searchRequest(keyword:String, completionHandler:((_ result: [YXSFileModel])->())?) {
        // 出组
        YXSSatchelFilePageQueryRequest(currentPage: self.curruntPage, parentFolderId: -1, keyword: keyword).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            let hasNext = json["hasNext"]
            
            let tmpFileList = Mapper<YXSFileModel>().mapArray(JSONString: json["satchelFileList"].rawString()!) ?? [YXSFileModel]()
            completionHandler?(tmpFileList)
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func cancelClick(sender:YXSButton) {
        self.navigationController?.popViewController()
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fileList[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fileList[indexPath.row]
        
        if item.fileType == "jpg" {
            YXSShowBrowserHelper.showImage(urls: [URL(string: item.fileUrl ?? "")!], curruntIndex: 0)
            
        } else if item.fileType == "mp4" {
            // 视频
            YXSShowBrowserHelper.yxs_VedioBrowser(videoURL: URL(string: item.fileUrl ?? ""))
            
        } else {
            let wk = YXSBaseWebViewController()
            wk.loadUrl = item.fileUrl
            navigationController?.pushViewController(wk)
        }
    }

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
    
    
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    override func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return  NightNight.theme == nil ? UIImage.init(named: "yxs_empty_search_night") : UIImage(named: "yxs_empty_search")
    }

    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "没有找到相关内容"
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(18)),
                          NSAttributedString.Key.foregroundColor: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
}
