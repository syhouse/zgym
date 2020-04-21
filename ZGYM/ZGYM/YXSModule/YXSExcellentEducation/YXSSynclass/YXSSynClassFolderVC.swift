//
//  YXSSynClassFolderVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/21.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight
import ObjectMapper

class YXSSynClassFolderVC:YXSBaseTableViewController {
    var folderId: Int?
    var isShowContent: Bool = true
    var folderInfoModel: YXSSynClassFolderInfoModel?
    var dataSource: [YXSSynClassFolderModel] = [YXSSynClassFolderModel]()
    init(folderId: Int, title: String) {
        super.init()
        self.folderId = folderId
        self.title = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSSynClassFolderCell.self, forCellReuseIdentifier: "YXSSynClassFolderCell")
        tableView.tableHeaderView = tableHeaderView
    }
    
    // MARK: -loadData
    override func yxs_refreshData() {
        curruntPage = 1
        loadData()
        
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        YXSEducationResourcePageQueryRequest.init(currentPage: curruntPage, folderId: folderId ?? 0).request({ (json) in
            self.yxs_endingRefresh()
            let list = Mapper<YXSSynClassFolderModel>().mapArray(JSONObject: json["resourceList"].object) ?? [YXSSynClassFolderModel]()
            let infoModel = Mapper<YXSSynClassFolderInfoModel>().map(JSONObject:json["folderInfo"].object) ?? YXSSynClassFolderInfoModel.init(JSON: ["": ""])!
            self.folderInfoModel = infoModel
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            self.dataSource += list
            self.loadMore = json["hasNext"].boolValue
            self.tableHeaderView.headerImageV.sd_setImage(with: URL(string: self.folderInfoModel?.homeUrl ?? ""), placeholderImage: UIImage.init(named: "yxs_synclass_folderheader_default"))
            
            let paragraphStye = NSMutableParagraphStyle()
            //调整行间距
            paragraphStye.lineSpacing = kMainContentLineHeight
            paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
            let attributedString = NSMutableAttributedString.init(string: self.folderInfoModel?.synopsis ?? "", attributes: [NSAttributedString.Key.paragraphStyle:paragraphStye,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
            self.footerTextView.attributedText = attributedString
            self.refreshTableViewFooter()
            self.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    func refreshTableViewFooter() {
        self.footerTextView.sizeToFit()
        self.tableFooterView.height = self.footerTextView.height
        
        if self.isShowContent {
            self.tableView.tableFooterView = nil
        } else {
            self.tableView.tableFooterView = nil
            self.tableView.tableFooterView = tableFooterView
        }
        self.tableView.reloadData()
    }
    
    func addPlayCountRequest(model:YXSSynClassFolderModel) {
        YXSEducationPlayAddCountRequest.init(folderId: model.folderId!).request({ (json) in
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isShowContent {
            return  self.dataSource.count
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSSynClassFolderCell") as! YXSSynClassFolderCell
        if self.isShowContent {
            cell.contentView.isHidden = false
            cell.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), lineHeight: 0.5)
            if dataSource.count > indexPath.row {
                let model = dataSource[indexPath.row]
                cell.setModel(model: model)
            }
        } else {
            cell.contentView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if dataSource.count > indexPath.row {
            let model = dataSource[indexPath.row]
            self.addPlayCountRequest(model: model)
            let vc = YXSBaseWebViewController()
            vc.loadUrl = model.resourceUrl
            self.navigationController?.pushViewController(vc)
        }
        
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView:YXSSynClassFolderTableHeaderView = {
        let headerView = YXSSynClassFolderTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 225))
        headerView.folderHeaderClickBlock = { (isContent) in
            self.isShowContent = isContent
            self.refreshTableViewFooter()
        }
        headerView.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), lineHeight: 1)
        return headerView
    }()
    
    lazy var tableFooterView:UIView = {
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        footerView.addSubview(self.footerTextView)
        self.footerTextView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
        }
        return footerView
    }()
    
    lazy var footerTextView:UITextView = {
        let textView = UITextView.init(frame: CGRect(x: 15, y: 0, width: SCREEN_WIDTH - 30, height: 0))
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#4E4E4E"), night: kNight898F9A)
        textView.isEditable = false
        return textView
    }()
    
}
class YXSSynClassFolderTableHeaderView:UIView {
    var folderHeaderClickBlock:((_ isContent: Bool) -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.headerImageV)
        self.addSubview(self.contentBtn)
        self.addSubview(self.introBtn)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc func contentBtnClick(sender: UIButton) {
        sender.isSelected = true
        self.introBtn.isSelected = false
        self.introBtn.yxs_removeLine()
        if sender.yxs_getIsShowLineView() {
            sender.yxs_removeLine()
        } else {
            sender.yxs_addLine(position: .bottom, color: kNight5E88F7, leftMargin: 15, rightMargin: 15, lineHeight: 2)
        }
        self.folderHeaderClickBlock?(true)
    }
    @objc func introBtnClick(sender: UIButton) {
        sender.isSelected = true
        self.contentBtn.isSelected = false
        self.contentBtn.yxs_removeLine()
        if sender.yxs_getIsShowLineView() {
            sender.yxs_removeLine()
        } else {
            sender.yxs_addLine(position: .bottom, color: kNight5E88F7, leftMargin: 15, rightMargin: 15, lineHeight: 2)
        }
        self.folderHeaderClickBlock?(false)
    }
    
    // MARK: - getter&setter
    lazy var headerImageV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 175))
        return imgV
    }()
    
    lazy var contentBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH / 3 - 30, y: 175, width: 60, height: 50))
        btn.setTitle("内容", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNight898F9A), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight5E88F7), forState: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.isSelected = true
        btn.yxs_addLine(position: .bottom, color: kNight5E88F7, leftMargin: 15, rightMargin: 15, lineHeight: 2)
        btn.addTarget(self, action: #selector(contentBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var introBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH / 3 * 2 - 30, y: 175, width: 60, height: 50))
        btn.setTitle("简介", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNight898F9A), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight5E88F7), forState: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(introBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
}
