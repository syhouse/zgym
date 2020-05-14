//
//  YXSHomeworkBatchRemarkController.swift
//  ZGYM
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class SelectModel: NSObject{
    var childrenId: Int = 0
    var isSelect: Bool = false
}

class YXSHomeworkBatchRemarkController: YXSBaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "批量点评"
        // Do any additional setup after loading the view.
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)

        self.view.yxs_addLine(position: .top, color: kTableViewBackgroundColor, leftMargin: 0, rightMargin: 0, lineHeight: 10)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(YXSHomeworkUncommetListCell.classForCoder(), forCellReuseIdentifier: "YXSHomeworkUncommetListCell")

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(SCREEN_HEIGHT - 56 - kSafeTopHeight - kSafeBottomHeight)
        })
        
        self.view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(56 + kSafeBottomHeight)
            make.bottom.equalTo(0)
        })
        
        self.bottomView.addSubview(self.btnSelect)
        self.btnSelect.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.top.equalTo(7)
            make.height.equalTo(42)
            make.width.equalTo(70)
        })
        
        self.bottomView.addSubview(self.btnComment)
        self.btnComment.snp.makeConstraints({ (make) in
            make.right.equalTo(-10)
            make.top.equalTo(7)
            make.height.equalTo(42)
            make.width.equalTo(114)
        })
      
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.uncommeListModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YXSHomeworkUncommetListCell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeworkUncommetListCell") as! YXSHomeworkUncommetListCell
        cell.btnSelect.tag = indexPath.row
        let model:YXSClassMemberModel = (self.uncommeListModel?[indexPath.row] ?? nil)!
        let selectModel:SelectModel = (self.childrenIdList?[indexPath.row] ?? nil)!
        cell.btnSelect.isSelected = selectModel.isSelect
        cell.selectBlock = { () -> () in
            selectModel.isSelect = cell.btnSelect.isSelected
            if cell.btnSelect.isSelected == false {
                self.btnSelect.isSelected = false
            }
//            guard let weakSelf = self else {return}
        }
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    

    func deleteCommetingList(idList: [Int]) {
//        var list = [SelectModel]()
//        for sub in childrenIdList ?? [SelectModel]() {
//            var isOwn = false
//            for id in idList {
//                if sub.childrenId == id {
//                    isOwn = true
//                    break
//                }
//            }
//            if !isOwn {
//                list.append(sub)
//            }
//        }
        var uncommeList = [YXSClassMemberModel]()
        for sub in uncommeListModel ?? [YXSClassMemberModel]() {
            var isOwn = false
            for id in idList {
                if sub.childrenId == id {
                    isOwn = true
                    break
                }
            }
            if !isOwn {
                uncommeList.append(sub)
            }
        }
        uncommeListModel = uncommeList
//        childrenIdList = list
        self.tableView.reloadData()
    }
    
    @objc func yxs_addCommentClick(sender:YXSButton) {//老师点评
        var idList = [Int]()
        for sub in childrenIdList ?? [SelectModel]() {
            if sub.isSelect == true {
                idList.append(sub.childrenId)
            }
        }
        
        if idList.count == 0 {
            MBProgressHUD.yxs_showMessage(message: "请选择要点评的学生")
            return
        }
        
        let vc = YXSHomeworkCommentController()
        vc.homeModel = homeModel
        vc.childrenIdList = idList
        vc.commetCallBack = { (list)in
            self.deleteCommetingList(idList: list)
        }
        vc.isPop = true
        //点评成功后 刷新数据
        self.navigationController?.pushViewController(vc)
    }
    
    @objc func yxs_allSelectClick(sender:YXSButton) {//全选
        sender.isSelected = !sender.isSelected
        for sub in childrenIdList ?? [SelectModel]() {
            sub.isSelect = sender.isSelected
        }
        self.tableView.reloadData()
    }

    lazy var lbLine: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedBackgroundColor = MixedColor(normal: 0xE6EAF3, night: 0x20232F)
        return lb
    }()
    
    lazy var tableView: YXSTableView = {
        let tableView = YXSTableView(frame:self.view.frame, style:.plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        return view
    }()
    
    lazy var btnSelect: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("全选", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setMixedTitleColor(MixedColor(normal: 0x000000, night: 0xFFFFFF), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_chose_normal", night: "yxs_chose_normal"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_chose_selected", night: "yxs_chose_selected"), forState: .selected)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(yxs_allSelectClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnComment: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("发送点评", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 114, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20)
        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 114, height: 42), color: UIColor.gray, cornerRadius: 20, offset: CGSize(width: 4, height: 4))
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(yxs_addCommentClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    
    // MARK: - Setter
    var childrenIdList: [SelectModel]!
    
    var homeModel:YXSHomeListModel? {
        didSet {
            
        }
    }
    
    var uncommeListModel: [YXSClassMemberModel]? {
        didSet {
            var selectList:[SelectModel] = [SelectModel]()
            for sub in uncommeListModel ?? [YXSClassMemberModel]() {
                let selectModel = SelectModel()
                selectModel.childrenId = sub.childrenId ?? 0
                selectModel.isSelect = false
                selectList.append(selectModel)
            }
            self.childrenIdList = selectList
        }
    }

    
}
