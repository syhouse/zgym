//
//  YXSScoreLevelParentDetailsVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/8.
//  Copyright © 2020 zgym. All rights reserved.
//  等级制孩子成绩详情

import Foundation
import ObjectMapper

class YXSScoreLevelParentDetailsVC: YXSScoreBaseDetailsVC {
    var detailsModel: YXSScoreDetailsModel?
    
    var listModel: YXSScoreListModel?
    init(model:YXSScoreListModel) {
        super.init()
        self.listModel = model
    }
    
    var childModel: YXSScoreChildListModel?
    init(childModel: YXSScoreChildListModel) {
        super.init()
        self.childModel = childModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            customNav.title = "\(childModel?.childrenName ?? "")成绩详情"
        } else {
            customNav.title = listModel?.examName
        }
    }
    
    override func initUI() {
        super.initUI()
        self.scrollView.addSubview(headerView)
        self.scrollView.addSubview(commentView)
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.top.equalTo(64)
        }
        commentView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.top.equalTo(headerView.snp_bottom).offset(15)
            make.bottom.equalTo(-30)
        }
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            commentView.contactBtn.isHidden = true
        } else {
            commentView.contactBtn.isHidden = false
        }
        headerView.contactClickBlock = {
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                UIUtil.yxs_chatImRequest(childrenId: self.detailsModel?.childrenId ?? 0, classId: self.detailsModel?.classId ?? 0)
//                self.yxs_pushChatVC(imId: self.detailsModel?.teacherImId ?? "")
            }
        }
        
        commentView.contactClickBlock = {
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                self.yxs_pushChatVC(imId: self.detailsModel?.teacherImId ?? "")
            }
        }
    }
    
    // MARK: -loadData
    override func loadData(){
        YXSEducationScoreLevelSingleChildDetailsRequset.init(examId: examId, childrenId: childrenId).request({ (json) in
            let model = Mapper<YXSScoreDetailsModel>().map(JSONObject:json.object) ?? YXSScoreDetailsModel.init(JSON: ["": ""])!
            self.detailsModel = model
            self.headerView.setModel(model: model)
            if let comment = model.comment,comment.count > 0 {
                self.commentView.contentLbl.text = model.comment
            } else {
                self.commentView.contentLbl.text = "暂无评语"
            }
//            YXSScoreDetailsModel
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - getter&stter
    lazy var headerView: YXSScoreLevelChildHeaderView = {
        let view = YXSScoreLevelChildHeaderView.init()
        return view
    }()
    
    lazy var commentView: YXSScoreTeacherCommentView = {
        let view = YXSScoreTeacherCommentView.init()
        return view
    }()
}
