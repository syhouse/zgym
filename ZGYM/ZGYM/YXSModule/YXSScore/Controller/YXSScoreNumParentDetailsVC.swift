//
//  YXSScoreNumParentDetailsVC.swift
//  ZGYM
//
//  Created by yihao on 2020/6/1.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight
import FDFullscreenPopGesture_Bell
import ObjectMapper

/// 家长成绩学科 （单/多）
enum ParentScoreDisciplinaryType: String {
    case Multitude_Disciplinary//多科成绩
    case Singular_Disciplinary//单科成绩
}

class YXSScoreNumParentDetailsVC: YXSScoreBaseDetailsVC {

    var detailsModel: YXSScoreDetailsModel?
    var childModel: YXSScoreChildListModel?
    var listModel: YXSScoreListModel?
    init(model:YXSScoreListModel) {
        super.init()
        self.listModel = model
    }
    
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
        self.scrollView.addSubview(chartView)
        self.scrollView.addSubview(commentView)
        
        commentView.contactClickBlock = {
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
//                UIUtil.yxs_chatImRequest(childrenId: weakSelf.homeModel.childrenId ?? 0, classId: weakSelf.model?.classId ?? 0)
                self.yxs_pushChatVC(imId: self.detailsModel?.teacherImId ?? "")
            }
        }
        headerView.contactClickBlock = {
            if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
                UIUtil.yxs_chatImRequest(childrenId: self.detailsModel?.childrenId ?? 0, classId: self.classId)
            }
        }
        
        chartView.lookOneSubjectsBlock = {
            let vc = YXSScoreSingleSubjectListVC.init(examId: self.detailsModel?.examId ?? 0, childId: self.detailsModel?.childrenId ?? 0)
            self.navigationController?.pushViewController(vc)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.top.equalTo(64)
        }
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            chartView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(headerView.snp_bottom).offset(15)
                make.bottom.equalTo(-30)
            }
        } else {
            chartView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(headerView.snp_bottom).offset(15)
            }
            commentView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(SCREEN_WIDTH - 30)
                make.top.equalTo(chartView.snp_bottom).offset(15)
                make.bottom.equalTo(-30)
            }
        }
    }
    
    // MARK: -loadData
    override func loadData(){
        YXSEducationScoreParentDetailsRequest.init(examId: examId, childrenId: childrenId).request({ (json) in
            let model = Mapper<YXSScoreDetailsModel>().map(JSONObject:json.object) ?? YXSScoreDetailsModel.init(JSON: ["": ""])!
            self.detailsModel = model
            
            self.headerView.isHidden = false
            self.chartView.isHidden = false
            if YXSPersonDataModel.sharePerson.personRole == .PARENT {
                self.customNav.title = model.examName
                self.commentView.isHidden = false
                if model.achievementChildrenSubjectsResponseList?.count ?? 0 > 1 {
                    self.chartView.setIsShowLookSubjects(isHaveComment: true, isShow: true)
                } else {
                    self.chartView.setIsShowLookSubjects(isHaveComment: true, isShow: false)
                }
                if let comment = model.comment,comment.count > 0 {
                    UIUtil.yxs_setLabelParagraphText(self.commentView.contentLbl, text: model.comment, font: UIFont.systemFont(ofSize: 16), lineSpacing: 8, removeSpace: false)
//                    self.commentView.contentLbl.text = model.comment
                } else {
                    self.commentView.contentLbl.text = "暂无评语"
                }
            } else {
                self.commentView.isHidden = true
                self.chartView.setIsShowLookSubjects(isHaveComment: true, isShow: false)
            }
            if model.achievementChildrenSubjectsResponseList?.count ?? 0 > 1 {
                self.chartView.formHeaderTitle.text = "总分分布情况"
            } else {
                self.chartView.formHeaderTitle.text = "得分分布情况"
            }
            
            self.chartView.setModel(model: model)
            self.headerView.setModel(model: model)
        }) { (msg, code) in
             MBProgressHUD.yxs_showMessage(message: msg)
        }
    
    }
    
    // MARK: - getter&stter
    lazy var headerView: YXSScoreParentHeaderView = {
        let view = YXSScoreParentHeaderView.init()
        view.isHidden = true
        return view
    }()
    
    lazy var chartView: YXSScoreChildBarChartView = {
        let chartView = YXSScoreChildBarChartView.init(isHaveComment: true,isShowLookSubjects: true)
        chartView.isHidden = true
        return chartView
    }()
    
    lazy var commentView: YXSScoreTeacherCommentView = {
        let view = YXSScoreTeacherCommentView.init()
        view.isHidden = true
        return view
    }()
    
}
