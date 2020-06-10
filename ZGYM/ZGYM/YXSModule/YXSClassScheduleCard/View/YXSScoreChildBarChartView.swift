//
//  YXSScoreChildBarChartView.swift
//  ZGYM
//
//  Created by yihao on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//  孩子成绩柱状图

import Foundation

class YXSScoreChildBarChartView: UIView {
    var lookOneSubjectsBlock:(()->())?
    /// 是否包含评语
    var isHaveComment: Bool = false
    /// 是否显示查看单科成绩按钮
    var isShowLookSubjects: Bool = false
    
    var detailsModel: YXSScoreDetailsModel?
    // MARK: - leftCycle
    init(isHaveComment: Bool = false,isShowLookSubjects: Bool = false) {
        super.init(frame: CGRect.zero)
        self.isHaveComment = isHaveComment
        self.isShowLookSubjects = isShowLookSubjects
        createUI()
        
    }
    
    func setIsShowLookSubjects(isHaveComment:Bool, isShow: Bool) {
        self.isShowLookSubjects = isShow
        self.isHaveComment = isHaveComment
        if isHaveComment {
            commentLbl.isHidden = false
            echelonLbl.isHidden = false
            if isShow {
                self.formHeaderTitle.text = "总分分布情况"
                lookSubjectsControl.isHidden = false
                lookSubjectsControl.snp.remakeConstraints { (make) in
                    make.height.equalTo(15)
                    make.centerX.equalTo(contentView.snp_centerX)
                    make.bottom.equalTo(-30)
                    make.width.equalTo(150)
                }
                commentLbl.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(15)
                    make.bottom.equalTo(lookSubjectsControl.snp_top).offset(-20)
                }
                echelonLbl.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(15)
                    make.bottom.equalTo(commentLbl.snp_top).offset(-8)
                }
                barChartView.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.bottom.equalTo(echelonLbl.snp_top).offset(-20)
                    make.right.equalTo(-15)
                    make.top.equalTo(90)
                    make.height.equalTo(220)
                }
            } else {
                lookSubjectsControl.isHidden = true
                lookSubjectsControl.snp.removeConstraints()
                commentLbl.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(15)
                    make.bottom.equalTo(-30)
                }
                echelonLbl.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(15)
                    make.bottom.equalTo(commentLbl.snp_top).offset(-8)
                }
                barChartView.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.bottom.equalTo(echelonLbl.snp_top).offset(-20)
                    make.right.equalTo(-15)
                    make.top.equalTo(90)
                    make.height.equalTo(220)
                }
            }
        } else {
            commentLbl.isHidden = true
            echelonLbl.isHidden = true
            lookSubjectsControl.isHidden = true
            lookSubjectsControl.snp.removeConstraints()
            commentLbl.snp.removeConstraints()
            echelonLbl.snp.removeConstraints()
            barChartView.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(-30)
                make.right.equalTo(-15)
                make.top.equalTo(90)
                make.height.equalTo(220)
            }
        }
    }
    
    func createUI() {
        addSubview(contentView)
        addSubview(formHeaderView)
        
        contentView.addSubview(barChartView)
        contentView.addSubview(echelonLbl)
        contentView.addSubview(commentLbl)
        contentView.addSubview(lookSubjectsControl)
        
        formHeaderView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(205*SCREEN_SCALE)
            make.height.equalTo(40)
            make.top.equalTo(0)
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(6)
        }
        if isHaveComment {
            commentLbl.isHidden = false
            echelonLbl.isHidden = false
            if isShowLookSubjects {
                lookSubjectsControl.isHidden = false
                lookSubjectsControl.snp.makeConstraints { (make) in
                    make.height.equalTo(15)
                    make.centerX.equalTo(contentView.snp_centerX)
                    make.bottom.equalTo(-30)
                    make.width.equalTo(150)
                }
                commentLbl.snp.makeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(15)
                    make.bottom.equalTo(lookSubjectsControl.snp_top).offset(-20)
                }
            } else {
                commentLbl.snp.makeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(15)
                    make.bottom.equalTo(-30)
                }
            }
            
            
            echelonLbl.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(15)
                make.bottom.equalTo(commentLbl.snp_top).offset(-8)
            }
            barChartView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(echelonLbl.snp_top).offset(-20)
                make.right.equalTo(-15)
                make.top.equalTo(90)
                make.height.equalTo(220)
            }
        } else {
            commentLbl.isHidden = true
            echelonLbl.isHidden = true
            lookSubjectsControl.isHidden = true
            barChartView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(-30)
                make.right.equalTo(-15)
                make.top.equalTo(90)
                make.height.equalTo(220)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: YXSScoreDetailsModel) {
        self.detailsModel = model
        self.layoutIfNeeded()
        self.setBarChartData(list: model.totalStatement ?? [YXSScoreTotalStatementModel]())
    }
    
    
    func setBarChartData(list: [YXSScoreTotalStatementModel]) {
        if list.count <= 0 {
            return
        }
        let xArr: NSMutableArray = NSMutableArray.init()
        let yArr: NSMutableArray = NSMutableArray.init()
        var maxY: Int = 0
        var currentChildechelon = 0
        var currentChildIndex = 0
        var i = 0
        for model in list {
            xArr.add(model.branch ?? "")
            yArr.add("\(String(model.quantity ?? 0))人")
            if let quantity = model.quantity, quantity > maxY {
                maxY = quantity
            }
            if self.detailsModel?.currentBranch == model.branch {
                currentChildIndex = i
                currentChildechelon = i
            }
            i += 1
        }
        if currentChildechelon != 3 {
            var hasIndex = 0
            for index in (currentChildechelon + 1)...3 {
                if list.count > index {
                    let model = list[index]
                    if let quantity = model.quantity, quantity > 0 {
                        hasIndex += 1
                    }
                }
            }
            currentChildechelon = 3 - hasIndex
        }
        var childName = ""
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            childName.append("您的孩子")
        }
        childName.append(self.detailsModel?.childrenName ?? "")
        
        switch currentChildechelon {
        case 0:
            echelonLbl.text = "\(childName)本次得分位于班级第四梯队"
            commentLbl.text = "鼓励孩子继续加油哦！"
        case 1:
            echelonLbl.text = "\(childName)本次得分位于班级第三梯队"
            commentLbl.text = "鼓励孩子继续加油哦！"
        case 2:
            echelonLbl.text = "\(childName)本次得分位于班级第二梯队"
            commentLbl.text = "鼓励孩子继续加油哦！"
        case 3:
            echelonLbl.text = "\(childName)本次得分位于班级第一梯队"
            commentLbl.text = "鼓励孩子继续保持哦！"
        default:
            break
        }
        
        barChartView.signIndexY = Int32(currentChildIndex)
        barChartView.signIndexCorlor = UIColor.yxs_hexToAdecimalColor(hex: "#96DADE")
        if YXSPersonDataModel.sharePerson.personRole == .PARENT {
            barChartView.signDescribe = "您的孩子"
        } else {
            barChartView.signDescribe = self.detailsModel?.childrenName
        }
        barChartView.signValues = "\(String(self.detailsModel?.achievementChildrenSubjectsResponseSum?.score ?? 0))分"
        
        barChartView.xValuesArr = xArr
        barChartView.yValuesArr = yArr
        if maxY < 4 {
            barChartView.yScaleValue = CGFloat(1)
        } else {
            barChartView.yScaleValue = CGFloat(maxY / 4)
        }
        
        let count: Int = xArr.count
        let gapWidth = ((Int(SCREEN_WIDTH) - 90 - 15) - 35 * count) / (count+1)
        barChartView.gapWidth = CGFloat(gapWidth)
        barChartView.reloadData()
        
    }
    
    // MARK: - Action
    @objc func lookSubjectsClick() {
        lookOneSubjectsBlock?()
    }
    
    // MARK: - getter&stter
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var barChartView: SSWBarChartView = {
        let chartView = SSWBarChartView.init(chartType: SSWChartsType.bar)
//        chartView?.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        chartView?.barCorlor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        chartView?.yAxisCount = 5
        chartView?.yScaleValue = 4
        chartView?.gapWidth = 25*SCREEN_SCALE
        chartView?.barWidth = 35
        return chartView!
    }()
    
    lazy var formHeaderView: UIView = {
        let view = UIView()
        view.addSubview(self.formHeaderImgV)
        self.formHeaderImgV.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        view.addSubview(formHeaderTitle)
        formHeaderTitle.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(20)
            make.centerY.equalTo(view.snp_centerY)
        }
        return view
    }()
    
    lazy var formHeaderImgV: UIImageView = {
        let bgImgV = UIImageView()
        bgImgV.image = UIImage.init(named: "yxs_score_formHeader_all")
        bgImgV.contentMode = .scaleAspectFit
        return bgImgV
    }()
    
    lazy var formHeaderTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = NSTextAlignment.center
        lbl.text = "得分分布情况"
        return lbl
    }()
    
    lazy var echelonLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.text = ""
        lbl.isHidden = true
        return lbl
    }()
    
    lazy var commentLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.text = ""
        lbl.isHidden = true
        return lbl
    }()
    
    lazy var lookSubjectsControl: YXSCustomImageControl = {
        let button = YXSCustomImageControl.init(imageSize: CGSize.init(width: 10, height: 15), position: .right, padding: 3.5, insets: UIEdgeInsets.init(top: 0, left: 6.5, bottom: 0, right: 7))
        button.cornerRadius = 13
        button.setTitle("查看单科成绩情况", for: .normal)
        button.locailImage = "yxs_score_rightArrow"
        button.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        button.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(lookSubjectsClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
}
