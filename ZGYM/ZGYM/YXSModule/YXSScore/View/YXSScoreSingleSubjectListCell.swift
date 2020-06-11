//
//  YXSScoreSingleSubjectListCell.swift
//  ZGYM
//
//  Created by yihao on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

class YXSScoreSingleSubjectListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        contentView.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
    }
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    var index: Int = 0
    var listModel: YXSScoreChildListModel?
    var model: YXSScoreChildSingleReportModel?
    var detailsModel: YXSScoreDetailsModel?
    func setModel(model:YXSScoreChildSingleReportModel) {
        self.layoutIfNeeded()
        self.model = model
        self.detailsModel = YXSScoreDetailsModel.init(JSON: ["":""])
        self.detailsModel?.totalStatement = model.statisticsBranchSubjectsScoreNumberEntities
        self.detailsModel?.currentBranch = model.currentBranch
        self.detailsModel?.childrenName = listModel?.childrenName
        let subModel = YXSScoreChildrenSubjectsModel.init(JSON: ["":""])
        subModel?.score = model.currentScore
        self.detailsModel?.achievementChildrenSubjectsResponseSum = subModel
        chartView.formHeaderTitle.text = "\(model.subjectsName ?? "")成绩"
        let i = index % 3
        switch i {
        case 0:
            chartView.formHeaderImgV.image = UIImage.init(named: "yxs_score_formHeader_red")
        case 1:
            chartView.formHeaderImgV.image = UIImage.init(named: "yxs_score_formHeader_blue")
        case 2:
            chartView.formHeaderImgV.image = UIImage.init(named: "yxs_score_formHeader_purple")
        default:
            break
        }
        chartView.setModel(model: self.detailsModel ?? YXSScoreDetailsModel.init(JSON: ["":""])!)
    }
    
    // MARK: - getter&setter
    lazy var chartView: YXSScoreChildBarChartView = {
        let chartView = YXSScoreChildBarChartView.init(isHaveComment: false,isShowLookSubjects: false)
//        chartView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 30, height: 300)
        return chartView
    }()
}
