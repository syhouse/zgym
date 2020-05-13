//
//  YXSContactController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/11.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import IQKeyboardManager
import ObjectMapper
import NightNight

/// 私聊联系人
class YXSContactController: YXSBaseTableViewController{

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 登录
        if !YXSChatHelper.sharedInstance.isLogin() {
            YXSChatHelper.sharedInstance.login()
        }
    }
    
    var classId:Int?
    var currentClassIndex:Int = 0
    
    /// 所有组的数据
    var dataDict:[String:Array<YXSContactModel>] = Dictionary()
    /// 组标题
    var groupList:[String] = [String]()
    /// 特殊字符组的Cells数据(不包含老师组里的特殊字符成员)
    var nonameList:[YXSContactModel] = [YXSContactModel]()
    /// 老师组的Cells数据
    var teacherList:[YXSContactModel] = [YXSContactModel]()
    /// 家长组的Cells数据
    var parentList:[YXSContactModel] = [YXSContactModel]()
    var navRightBadgeBtn: SLBadgeButton = SLBadgeButton()
    
    /// 请求回来班级相应ID所有联系人
    var contactsModel:[YXSContactModel] = [YXSContactModel]()
    
    /// 若传班级参数 仅显示当前一个班级的成员
    init(classId:Int? = nil) {
        super.init()
        self.classId = classId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.hasRefreshHeader = false
        self.showBegainRefresh = false
        
        super.viewDidLoad()
        self.title = "通讯录"
        
        /// 取出缓存装载数据
        classesModel = YXSCacheHelper.yxs_getCacheChatContactClassList()
        gradeView.model = classesModel
        contactsModel = YXSCacheHelper.yxs_getCacheChatContactAllCellList(classId: classesModel?.first?.id ?? 0)
        processData(list: contactsModel)
        
        tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            yxs_setNavBack()
        }
//        setupRightBarButtonItem()

        // Do any additional setup after loading the view.
        
        
        gradeView.cellSelectedBlock = {[weak self](index) in
            guard let weakSelf = self else {return}
            weakSelf.currentClassIndex = index
            
            let id = weakSelf.classesModel?[index].id ?? 0
            weakSelf.contactsModel = YXSCacheHelper.yxs_getCacheChatContactAllCellList(classId: id)
            weakSelf.processData(list: weakSelf.contactsModel)
            weakSelf.tableView.reloadData()
            
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                weakSelf.teacherContactRequest()
            } else {
                weakSelf.parentContactRequest()
            }
        }
        self.view.addSubview(gradeView)
        gradeView.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(55)
        })
        
        /// 索引字颜色
        tableView.sectionIndexColor = kNightBCC6D4//UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        tableView.register(YXSContactCell.classForCoder(), forCellReuseIdentifier: "YXSContactCell")
        tableView.register(YXSContactSectionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "YXSContactSectionHeaderView")
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(gradeView.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        footerView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footerView
        
        yxs_refreshData()
    }
    
    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = nil
        navRightBadgeBtn = SLBadgeButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        navRightBadgeBtn.button.addTarget(self, action: #selector(rightBarButtonClick(sender:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: navRightBadgeBtn)
        navigationItem.rightBarButtonItem = rightItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkNavRightBadgeBtnBadge), name: NSNotification.Name(rawValue: kChatCallRefreshNotification), object: nil)
    }
    
    // MARK: - Request

    @objc func teacherRequest() {
//        MBProgressHUD.yxs_showLoading()
        YXSEducationGradeListRequest().request({ [weak self](json) in
            guard let weakSelf = self else {return}
//            MBProgressHUD.yxs_hideHUD()
            let joinClassList = Mapper<YXSClassModel>().mapArray(JSONString: json["listJoin"].rawString()!) ?? [YXSClassModel]()
            let createClassList = Mapper<YXSClassModel>().mapArray(JSONString: json["listCreate"].rawString()!) ?? [YXSClassModel]()
            var model = joinClassList + createClassList
            model = weakSelf.filter(classList: model)
            weakSelf.classesModel = model
            YXSCacheHelper.yxs_cacheChatContactClassList(classesModel: model)
            
            if model.count > 0 {
                weakSelf.teacherContactRequest()
            }
            
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        
    }
    
    @objc func teacherContactRequest() {
//        MBProgressHUD.yxs_showLoading()
        let cId = classesModel?[currentClassIndex].id ?? 0
        YXSEducationTeacherQueryContactsRequest(classId: cId).requestCollection({ [weak self](list:[YXSContactModel]) in
            guard let weakSelf = self else {return}
//            MBProgressHUD.yxs_hideHUD()
            weakSelf.contactsModel = list
            YXSCacheHelper.yxs_cacheChatContactAllCellList(classId: cId, allCellModel: weakSelf.contactsModel)
            weakSelf.processData(list: list)
            weakSelf.tableView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    @objc func parentRequest() {
//        MBProgressHUD.yxs_showLoading()
        YXSEducationGradeListRequest().request({ [weak self](json) in
            guard let weakSelf = self else {return}
//            MBProgressHUD.yxs_hideHUD()
            var model = Mapper<YXSClassModel>().mapArray(JSONString: json["listJoin"].rawString()!) ?? [YXSClassModel]()
            /// 去重
            model = model.yxs_filterDuplicates({$0.id})
            model = weakSelf.filter(classList: model)
            weakSelf.classesModel = model
            YXSCacheHelper.yxs_cacheChatContactClassList(classesModel: model)
            
            if model.count > 0 {
                weakSelf.parentContactRequest()
            }
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func parentContactRequest() {
//        MBProgressHUD.yxs_showLoading()
        let cId = classesModel?[currentClassIndex].id ?? 0
        YXSEducationParentQueryContactsRequest(classId: cId).requestCollection({ [weak self](list:[YXSContactModel]) in
            guard let weakSelf = self else {return}
//            MBProgressHUD.yxs_hideHUD()
            weakSelf.contactsModel = list
            YXSCacheHelper.yxs_cacheChatContactAllCellList(classId: cId, allCellModel: weakSelf.contactsModel)
            weakSelf.processData(list: list)
            weakSelf.tableView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    override func yxs_refreshData() {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            teacherRequest()
            
        } else {
            parentRequest()
        }
        
        checkNavRightBadgeBtnBadge()
    }
    
    // MARK: - Setter
    var classesModel: [YXSClassModel]? {
        didSet {
            gradeView.model = self.classesModel
        }
    }
    
    // MARK: - Action
    @objc func rightBarButtonClick(sender:UIButton) {
        let vc = YXSConversationListController()
        navigationController?.pushViewController(vc)
    }
    
    // MARK: - NewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = groupList[section]
        let list = dataDict[group]
        return list?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YXSContactCell = tableView.dequeueReusableCell(withIdentifier: "YXSContactCell") as! YXSContactCell
        let group = groupList[indexPath.section]
        let list = dataDict[group]
        cell.model = list?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: YXSContactCell = tableView.cellForRow(at: indexPath) as! YXSContactCell
        self.yxs_pushChatVC(imId: cell.model?.imId ?? "")
    }
    
    // MARK: -Group
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: YXSContactSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YXSContactSectionHeaderView") as! YXSContactSectionHeaderView
        let model = YXSContactSectionHeaderViewModel()
        
        let strTitle = groupList[section]
        if strTitle == "教" {
            model.titleName = "教师(\(teacherList.count))"
            model.gourpName = nil
            
        } else {
            if (teacherList.count == 0 && section == 0) || (teacherList.count != 0 && section == 1) {
                model.titleName = "成员(\(parentList.count))"
                model.gourpName = strTitle
                
            } else {
                model.titleName = nil
                model.gourpName = strTitle
            }
        }
        headerView.model = model
        return headerView
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return groupList
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    
    // MARK: - Other
    /// 过滤若有班级ID 仅显示当前一个班级的成员
    @objc func filter(classList:[YXSClassModel]) -> [YXSClassModel]{
        if self.classId == nil {
            return classList
            
        } else {
            var model: YXSClassModel = YXSClassModel(JSON: ["":""])!
            for sub in classList {
                if sub.id == self.classId {
                    model = sub
                }
            }
            return [model]
        }
    }
    
    @objc func filterTeacher(list:[YXSContactModel] ,completionHandler:((_ teacherList:[YXSContactModel], _ parentList:[YXSContactModel])->())) {
        
        teacherList.removeAll()
        var teacherListTmp:[YXSContactModel] = [YXSContactModel]()
        var parentListTmp:[YXSContactModel] = [YXSContactModel]()
        for sub in list {
            if sub.position == "HEADMASTER" {
                /// 班主任在首位
                teacherListTmp.insert(sub, at: 0)
                
            } else if sub.position == "TEACHER" {
                teacherListTmp.append(sub)
                
            } else {
                parentListTmp.append(sub)
            }
        }
        completionHandler(teacherListTmp, parentListTmp)
    }
    
    /// 排序
    @objc func processData(list:[YXSContactModel]) {
        nonameList.removeAll()
        groupList.removeAll()
        dataDict.removeAll()
        
        filterTeacher(list: list) { [weak self](teacherList, parentList) in
            guard let weakSelf = self else {return}
            weakSelf.teacherList = teacherList
            weakSelf.parentList = parentList
            
            for sub in parentList {
                let group: String = sub.imNick?.firstCharacterAsString ?? ""
                let strPinYin = convertString2Pinyin(group: group)
                //截取大写首字母
                var firstString:String = ""
                if strPinYin.count > 0 {
                    firstString = strPinYin.substring(to:strPinYin.index(strPinYin.startIndex, offsetBy: 1))
                    //判断首字母是否为大写
                    let regexA = "^[A-Z]$"
                    let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
                    if !predA.evaluate(with: firstString) {
                        nonameList.append(sub)
                        continue
                    }
                } else {
                    nonameList.append(sub)
                    continue
                }
                SLLog(">>>>>>>>>:\(firstString)")

                /// 存
                var list:[YXSContactModel]? = dataDict[firstString]
                if (list == nil) {
                    list = [YXSContactModel]()
                    list?.append(sub)
                    dataDict[firstString] = list
                    groupList.append(firstString)
                } else {
                    list?.append(sub)
                    dataDict[firstString] = list
                }
            }
            
            groupList.sort()
            if nonameList.count > 0 {
                groupList.append("#")
                dataDict["#"] = nonameList
            }
            
            if teacherList.count > 0 {
                let key = "教"
                groupList.insert(key, at: 0)
                dataDict[key] = teacherList
            }
        }
    }
    
    /// 将字符串转换成首字母 例如:"小天使"返回"X"
    @objc func convertString2Pinyin(group: String) -> String {
        CFStringTransform(group as! CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: group)

        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)

        //去掉声调
        let pinyinString = mutableString.folding(options:String.CompareOptions.diacriticInsensitive, locale:   NSLocale.current)

        //将拼音首字母换成大写
        let strPinYin = pinyinString.uppercased()
        
        return strPinYin
    }
    
    @objc func checkNavRightBadgeBtnBadge() {
        /// 检查右上角按钮红点显示/隐藏
        let list:[TIMConversation] = TIMManager.sharedInstance()?.getConversationList() ?? [TIMConversation]()
        var unReadCount: Int = 0
        for sub in list {
            if sub.getReceiver() == "spy" {
                continue
            }
            unReadCount += Int(sub.getUnReadMessageNum())
        }
        
        navRightBadgeBtn.isBadgeHidden = unReadCount > 0 ? false : true
    }
    
    // MARK: - LazyLoad
    lazy var gradeView: YXSContactGradeView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let gradeView = YXSContactGradeView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 55), collectionViewLayout: flow)
        return gradeView
    }()

    
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
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


class SLBadgeButton: UIControl {
    
    var isBadgeHidden: Bool? {
        didSet {
            redDot?.isHidden = self.isBadgeHidden ?? true
        }
    }
    
    var button: YXSButton!
    private var redDot: UIView?
    override init(frame: CGRect) {
        super.init(frame: frame)

        button = YXSButton(frame: CGRect.zero)
        button.setMixedTitleColor(MixedColor(normal: UIColor.black, night: kNight898F9A), forState: .normal)
        button.setTitle("私聊", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        
        redDot = UIView()
        redDot?.isHidden = true
        redDot?.backgroundColor = UIColor.red
        redDot?.cornerRadius = 3
        
        addSubview(button)
        addSubview(redDot!)
        
        button.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        redDot!.snp.makeConstraints({ (make) in
            make.top.equalTo(button.snp_top).offset(5)
            make.right.equalTo(button.snp_right).offset(0)
//            make.top.equalTo(self.snp_top).offset(5)
//            make.right.equalTo(self.snp_right).offset(0)
            make.width.equalTo(6)
            make.height.equalTo(6)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
