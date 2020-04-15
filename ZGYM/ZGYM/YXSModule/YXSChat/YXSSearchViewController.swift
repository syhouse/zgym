//
//  YXSSearchViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSSearchViewController: YXSBaseTableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 登录
        if !YXSChatHelper.sharedInstance.isLogin() {
            YXSChatHelper.sharedInstance.login()
        }
    }
    
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
            
            var tmp = [TUIConversationCellData]()
            for sub in weakSelf.dataList ?? [TUIConversationCellData]() {
                let arr = sub.title.components(separatedBy: "&")
                if let str = arr.last {
                    if str.contains(view.text) {
                        tmp.append(sub)
                    }
                }
            }
            weakSelf.searchResult = tmp
            weakSelf.tableView.reloadData()
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
        tableView.register(TUIConversationCell.classForCoder(), forCellReuseIdentifier: "TUIConversationCell")
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(searchBar.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
    }
    
    
    // MARK: - Getter Setter
    var searchResult: [TUIConversationCellData]? {
        didSet {
            
        }
    }
    
    var dataList: [TUIConversationCellData]? {
        get {
            TConversationListViewModel().dataList
        }
    }
    
    // MARK: - Action
    @objc func cancelClick(sender:YXSButton) {
        self.navigationController?.popViewController()
    }

    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchResult?[indexPath.row].height(ofWidth: SCREEN_WIDTH) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = searchResult?[indexPath.row] ?? TUIConversationCellData()
        let cell:TUIConversationCell = tableView.dequeueReusableCell(withIdentifier: "TUIConversationCell") as! TUIConversationCell
        ///Custom设置默认头像
        model.avatarImage = (model.convId.contains("TEACHER") ? kImageUserIconTeacherDefualtImage : kImageUserIconPartentDefualtImage)!
        
        ///切割&标题
        let arr = model.title.components(separatedBy: "&")
        model.title = arr.last ?? ""
        
        ///添加事件
        if (model.cselector == nil) {
            model.cselector = #selector(didSelectConversation(cell:))
        }
        
        /// 优学业助手 副标题显示消息内容
        if model.convId.contains("assistant") {
            model.subTitle = ""
            let c = TIMManager.sharedInstance()?.getConversation(TIMConversationType.C2C, receiver: model.convId)
            c?.getMessage(1, last: nil, succ: { (msgs) in
                if msgs?.count ?? 0 > 0 && msgs?.first is TIMMessage{
                    let msg: TIMMessage = msgs?.first as! TIMMessage
                    if YXSChatHelper.sharedInstance.isServiceMessage(msg: msg) {
                        model.subTitle = YXSChatHelper.sharedInstance.msg2IMCustomModel(msg: msg).content ?? ""
                    }
                    cell.fill(with: model)
                }
            }, fail: nil)
            
        } else {
            cell.fill(with: model)
        }
        
        //可以在此处修改，也可以在对应cell的初始化中进行修改。用户可以灵活的根据自己的使用需求进行设置。
//        cell.changeColorWhenTouched = true
        return cell
    }
  
    @objc func didSelectConversation(cell: TUIConversationCell) {
        let convData = cell.convData
        let conv = TIMManager.sharedInstance()?.getConversation(convData.convType, receiver: convData.convId)
        if convData.convId == "assistant" {
            let chat = YXSAssistantChatViewController(conversation: conv)
            self.navigationController?.pushViewController(chat!)
            
        } else {
            let chat = YXSChatViewController(conversation: conv)
            self.navigationController?.pushViewController(chat!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Group Style Use
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        let lb = YXSLabel()
        lb.text = "联系人"
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(lb)
        lb.snp.makeConstraints({ (make) in
            make.centerY.equalTo(view.snp_centerY)
            make.left.equalTo(20)
        })
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
//        return true
//    }

}
