//
//  ClassStarTeacherDetialHeaderItemView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

/// 中间排名视图
class YXSClassStarTeacherDetialHeaderMidView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgImageView)
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(remaidControl)
        addSubview(leftRankView)
        addSubview(rightRankView)
        addSubview(bottomLabelImageView)
        
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(228)
            make.bottom.equalTo(-30)
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
        }
        bottomLabelImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp_bottom)
            make.left.right.equalTo(bgImageView)
            make.height.equalTo(15.5)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(41.5)
            make.centerX.equalTo(leftRankView)
        }
        leftRankView.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp_bottom).offset(8)
            make.centerX.equalTo(self).offset(-70)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(41.5)
            make.centerX.equalTo(rightRankView)
        }
        rightRankView.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp_bottom).offset(8)
            make.centerX.equalTo(self).offset(70)
        }
        remaidControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(20)
            make.bottom.equalTo(-42.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detailControlClick(){
        next?.yxs_routerEventWithName(eventName: kYXSClassStarTeacherDetialHeaderViewLookDetialEvent)
    }
    
    func setHeaderModel(_ model: YXSClassStartClassModel){
        if model.hasComment{
            remaidControl.isHidden = false
            leftRankView.noData = false
            rightRankView.noData = false
            rightRankView.showLabelImage = false
            leftRankView.showLabelImage = true
            
            leftRankView.title = model.topStudent?.childrenName
            leftRankView.midImageView.sd_setImage(with: URL.init(string: model.topStudent?.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
            rightRankView.title = model.topStudent?.evaluationItem
            let newUrl = (model.topStudent?.evaluationUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            rightRankView.midImageView.sd_setImage(with: URL.init(string: newUrl),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        }else{
            remaidControl.isHidden = true
            leftRankView.noData = true
            rightRankView.noData = true
            rightRankView.midImageView.image = UIImage.init(named: "yxs_classstar_crown_gray")
            leftRankView.midImageView.image = UIImage.init(named: "yxs_classstar_student_gray")
        }
    }
    
    lazy var bgImageView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = UIColor.white
        imageView.addShadow(ofColor: UIColor.yxs_hexToAdecimalColor(hex: "#D5DFFB"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        return imageView
    }()
    
    lazy var bottomLabelImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_teacher_class_single_detial_mid_bg"))
        return imageView
    }()
    
    lazy var leftLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "最佳学生"
        return label
    }()
    
    lazy var rightLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "最突出项"
        return label
    }()
    
    lazy var remaidControl: YXSCustomImageControl = {
        let remaidControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: YXSImagePositionType.right, padding: 9.5)
        remaidControl.font = UIFont.boldSystemFont(ofSize: 15)
        remaidControl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        remaidControl.locailImage = "arrow_gray"
        remaidControl.title = "详细榜单"
        remaidControl.addTarget(self, action: #selector(detailControlClick), for: .touchUpInside)
        return remaidControl
    }()
    
    lazy var leftRankView: SLRankView = {
        let leftRankView = SLRankView()
        return leftRankView
    }()
    lazy var rightRankView: SLRankView = {
        let rightRankView = SLRankView()
        return rightRankView
    }()
}


class SLRankView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bottomImageView)
        addSubview(midImageView)
        addSubview(labelImageView)
        addSubview(titleLabel)
        addSubview(noDataView)
        
        bottomImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 99, height: 47))
            make.left.right.bottom.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(bottomImageView)
            make.bottom.equalTo(-8)
        }
        
        midImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 60))
            make.bottom.equalTo(bottomImageView.snp_top).offset(10)
            make.centerX.equalTo(bottomImageView)
        }
        labelImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 24.5, height: 24.5))
            make.bottom.equalTo(midImageView.snp_top).offset(13)
            make.left.equalTo(midImageView)
            make.top.equalTo(0)
        }
        
        noDataView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 67, height: 24))
            make.bottom.equalTo(0)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var showLabelImage: Bool = false{
        didSet{
            labelImageView.isHidden = !showLabelImage
        }
    }
    public var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    
    public var noData: Bool  = false {
        didSet{
            if noData == true{
                labelImageView.isHidden = true
                bottomImageView.isHidden = true
                titleLabel.isHidden = true
                noDataView.isHidden = false
            }else{
                noDataView.isHidden = true
                bottomImageView.isHidden = false
                titleLabel.isHidden = false
            }
        }
    }
    
    public var midImageUrl: String = "" {
        didSet{
            midImageView.sd_setImage(with: URL.init(string: midImageUrl),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        }
    }
    
    lazy var bottomImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_platform"))
        return imageView
    }()
    
    lazy var midImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_teacher_class_single_detial_mid_bg"))
        imageView.cornerRadius = 30
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var labelImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_crown"))
        return imageView
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "最突出项"
        label.textAlignment = .center
        return label
    }()
    
    lazy var noDataView: YXSButton = {
        let noDataView = YXSButton()
        noDataView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        noDataView.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), for: .normal)
        noDataView.setTitle("暂无", for: .normal)
        noDataView.cornerRadius = 12
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E9E9E9")
        return noDataView
    }()
}


class ClassStarProgressView: YXSButton {
    
    // MARK: -设置属性
    //设置绘图线宽
    public var excircleLineWith :CGFloat = 10
    
    /// 前景颜色
    public var foregroundColor: UIColor = UIColor.yxs_hexToAdecimalColor(hex: "#FFCA28")
    
    /// 剩余进度颜色
    public var  restColor: UIColor = UIColor.white
    
    private var progress :CGFloat = 0.0
    
    var praiseScore: Int = 0
    var improveScore: Int = 0
    public func setProgress(_ praiseScore: Int, _ improveScore: Int){
        self.praiseScore = praiseScore
        self.improveScore = improveScore
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        //        arcCenter 圆心坐标
        //         radius　　　半径
        //         startAngle　起始角度
        //         endAngle　　　结束角度
        //         clockwise　　　true:顺时针/false：逆时针
        let size = rect.size
        
        let arcCenter = CGPoint(x: size.width*0.5, y: size.height*0.5)
        var radius = min(size.width, size.height)*0.5
        let startAngle = CGFloat(-(Double.pi / 2))
        
        radius -= self.excircleLineWith
        if  praiseScore == 0 && improveScore == 0{
            let restPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: startAngle + CGFloat((Double.pi * 2)), clockwise: true)
            
            restPath.lineWidth = excircleLineWith//设置线宽
            restPath.lineCapStyle = CGLineCap.square//设置线样式
            
            UIColor.yxs_hexToAdecimalColor(hex: "#DAE4FC").set()
            restPath.stroke()
        }else{
            let progress = CGFloat(abs(improveScore))/CGFloat(praiseScore + abs(improveScore))
            var endAngle = progress*2*CGFloat(Double.pi) + startAngle
            
            if improveScore != 0{
                let restPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle + (praiseScore == 0 ? 0 : 0.02) , endAngle: endAngle - (praiseScore == 0 ? 0 : 0.02), clockwise: true)
                
                restPath.lineWidth = excircleLineWith//设置线宽
                restPath.lineCapStyle = CGLineCap.butt//设置线样式
                
                restColor.set()
                //绘制路径
                //镂空型
                restPath.stroke()
            }else{
                endAngle = -2*CGFloat(Double.pi) + startAngle
            }
            
            
            
            if praiseScore != 0{
                let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle - (improveScore == 0 ? 0 : 0.02), endAngle: endAngle + (improveScore == 0 ? 0 : 0.02), clockwise: false)
                
                path.lineWidth = excircleLineWith//设置线宽
                path.lineCapStyle = CGLineCap.butt//设置线样式
                
                foregroundColor.set()
                //绘制路径
                //镂空型
                path.stroke()
            }
            
        }
    }
    
}
