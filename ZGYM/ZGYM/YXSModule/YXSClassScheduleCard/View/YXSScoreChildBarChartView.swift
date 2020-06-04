//
//  YXSScoreChildBarChartView.swift
//  ZGYM
//
//  Created by yihao on 2020/6/2.
//  Copyright © 2020 zgym. All rights reserved.
//  孩子成绩柱状图

import Foundation

class YXSScoreChildBarChartView: UIView {
    /// 是否包含评语
    var isHaveComment: Bool = false
    /// 是否显示查看单科成绩按钮
    var isShowLookSubjects: Bool = false
    // MARK: - leftCycle
    init(isHaveComment: Bool = false,isShowLookSubjects: Bool = false) {
        super.init(frame: CGRect.zero)
        self.isHaveComment = isHaveComment
        self.isShowLookSubjects = isShowLookSubjects
        createUI()
        
    }
    
    func createUI() {
        addSubview(contentView)
        addSubview(formHeaderView)
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
        contentView.addSubview(barChartView)
        if isHaveComment {
            contentView.addSubview(echelonLbl)
            contentView.addSubview(commentLbl)
            if isShowLookSubjects {
                contentView.addSubview(lookSubjectsControl)
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
                make.top.equalTo(60)
                make.height.equalTo(180)
            }
        } else {
            barChartView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(-30)
                make.right.equalTo(-15)
                make.top.equalTo(60)
                make.height.equalTo(180)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc func lookSubjectsClick() {
        
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
        chartView?.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        chartView?.barCorlor = UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7")
        chartView?.xValuesArr = ["0-60","61-70","71-80","81-90","91-100"]
        chartView?.yValuesArr = ["3人","10人","15人","9人","4人"]
        chartView?.yAxisCount = 5
        chartView?.yScaleValue = 4
        chartView?.gapWidth = 30*SCREEN_SCALE
        return chartView!
    }()
    
    lazy var formHeaderView: UIView = {
        let view = UIView()
        let bgImgV = UIImageView()
        bgImgV.image = UIImage.init(named: "yxs_score_formHeader_all")
        bgImgV.contentMode = .scaleAspectFit
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { (make) in
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
    
    lazy var formHeaderTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = NSTextAlignment.center
        return lbl
    }()
    
    lazy var echelonLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.text = "张小飞本次得分位于班级第一梯队"
        return lbl
    }()
    
    lazy var commentLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = NSTextAlignment.center
        lbl.text = "鼓励孩子继续保持哦！"
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
        return button
    }()
}
