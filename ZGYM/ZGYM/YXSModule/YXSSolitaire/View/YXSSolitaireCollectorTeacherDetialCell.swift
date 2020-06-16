//
//  YXSSolitaireCollectorTeacherDetialCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

class YXSSolitaireCollectorTeacherDetialBaseCell : YXSSolitaireQuestionBaseCell {
    var lookDetialBlock: ((_ gatherTopicId: Int, _ selectModel: SolitairePublishNewSelectModel?) -> ())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dealBtn.isHidden = true
        contentView.yxs_addLine(leftMargin: 15)
        questionTitleView.rightGap = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout(){
        questionTitleView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(17)
        }
    }
    
    var model: YXSSolitaireQuestionModel!
    ///   - index: 题目下标 从0开始
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
    }
    
    lazy var progressView : UIProgressView = {
        let progressView = UIProgressView()
        progressView.mixedProgressTintColor = MixedColor(normal: kBlueColor, night: kBlueColor)
        progressView.mixedTrackTintColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
        progressView.cornerRadius = 2.5
        return progressView
    }()
    
    lazy var lookDetial: YXSCustomImageControl = {
        let lookDetial = YXSCustomImageControl.init(imageSize: CGSize.init(width: 5.5, height: 10.4), position: YXSImagePositionType.right, padding: 9.5)
        lookDetial.font = UIFont.systemFont(ofSize: 13)
        lookDetial.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        lookDetial.locailImage = "yxs_solitaire_arrow"
        lookDetial.yxs_touchInsets = UIEdgeInsets(top: 15, left: 5, bottom: 10, right: 20)
        return lookDetial
    }()
}


class YXSSolitaireCollectorTeacherDetialNoSelectCell : YXSSolitaireCollectorTeacherDetialBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(progressView)
        contentView.addSubview(lookDetial)
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(questionTitleView.snp_bottom).offset(17)
            make.height.equalTo(5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        lookDetial.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp_bottom).offset(10)
            make.height.equalTo(15)
            make.left.equalTo(15)
        }
        
        lookDetial.addTarget(self, action: #selector(lookDetialClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func lookDetialClick(){
        lookDetialBlock?(model.gatherTopicId ?? 0, nil)
    }
    
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
        progressView.progress = Float(model.ratio ?? 0)/100.0
        
        lookDetial.title = "\(model.gatherTopicCount ?? 0)人提交，占比\(model.ratio ?? 0)%"
    }
}


class YXSSolitaireCollectorTeacherDetiaSelectItemsCell : YXSSolitaireCollectorTeacherDetialBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for index in 0..<maxQuestionCount{
            let answerStatisticsView = YXSSolitaireAnswerStatisticsView()
            answerStatisticsView.tag = index + labelOrginTag
            answerStatisticsView.isHidden = true
            answerStatisticsView.lookDetial.addTarget(self, action: #selector(lookDetialClick), for: .touchUpInside)
            contentView.addSubview(answerStatisticsView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func lookDetialClick(control: UIControl){
        let index = (control.superview?.tag ?? labelOrginTag) - labelOrginTag
        if let solitaireSelects = model.solitaireSelects, solitaireSelects.count > index{
            let curruntOption = solitaireSelects[index]
            lookDetialBlock?(model.gatherTopicId ?? 0, curruntOption)
        }
    }
    
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
        
        for index in 0..<maxQuestionCount{
            let answerStatisticsView = contentView.viewWithTag(index + labelOrginTag) as? YXSSolitaireAnswerStatisticsView
            answerStatisticsView?.isHidden = true
            answerStatisticsView?.snp_removeConstraints()
        }
        if model.type == .single || model.type == .checkbox{
            if let solitaireSelects = model.solitaireSelects, solitaireSelects.count != 0{
                questionTitleView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(0)
                    make.top.equalTo(17)
                }
                var lastView: UIView = questionTitleView
                for (index, model) in solitaireSelects.enumerated(){
                    let answerStatisticsView = contentView.viewWithTag(index + labelOrginTag) as? YXSSolitaireAnswerStatisticsView
                    if let answerStatisticsView = answerStatisticsView{
                        answerStatisticsView.isHidden = false
                        answerStatisticsView.setModel(model, index: index)
                        answerStatisticsView.snp.remakeConstraints { (make) in
                            make.top.equalTo(lastView.snp_bottom).offset(17)
                            make.left.equalTo(15)
                            make.right.equalTo(-15)
                        }
                        lastView = answerStatisticsView
                        
                        answerStatisticsView.progressView.progress = Float(model.ratio ?? 0)/100.0
                        answerStatisticsView.lookDetial.title = "\(model.gatherTopicCount ?? 0)人选择，占比\(model.ratio ?? 0)%"
                    }
                }
            }
            
        }
    }
}


class YXSSolitaireAnswerStatisticsView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(answerView)
        
        addSubview(progressView)
        addSubview(lookDetial)
        
        answerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(answerView.snp_bottom).offset(17)
            make.height.equalTo(5)
            make.left.right.equalTo(0)
        }
        
        lookDetial.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp_bottom).offset(10)
            make.height.equalTo(15)
            make.left.equalTo(0)
            make.bottom.equalTo(0).priorityHigh()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: SolitairePublishNewSelectModel!
    func setModel(_ model: SolitairePublishNewSelectModel, index: Int){
        self.model = model
        answerView.setModel(model, index: index)
    }
    
    
    // MARK: -getter&setter
    lazy var answerView: YXSSolitaireLabelImageView = {
        let answerView = YXSSolitaireLabelImageView()
        return answerView
    }()
    
    lazy var progressView : UIProgressView = {
        let progressView = UIProgressView()
        progressView.cornerRadius = 2.5
        progressView.mixedProgressTintColor = MixedColor(normal: kBlueColor, night: kBlueColor)
        progressView.mixedTrackTintColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
        return progressView
    }()
    
    lazy var lookDetial: YXSCustomImageControl = {
        let lookDetial = YXSCustomImageControl.init(imageSize: CGSize.init(width: 5.5, height: 10.4), position: YXSImagePositionType.right, padding: 9.5)
        lookDetial.font = UIFont.systemFont(ofSize: 13)
        lookDetial.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        lookDetial.locailImage = "yxs_solitaire_arrow"
        lookDetial.yxs_touchInsets = UIEdgeInsets(top: 15, left: 5, bottom: 10, right: 20)
        return lookDetial
    }()
}
