//
//  YXSSolitaireQuestionBaseCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

let maxLabel: Int = 6
let labelOrginTag = 1001



class YXSSolitaireQuestionBaseCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(questionTitleView)
        
        questionTitleView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(17)
        }
        
        for index in 0..<maxLabel{
            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 15)
            label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
            label.tag = index + labelOrginTag
            label.isHidden = true
            contentView.addSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        questionTitleView.setModel(model, index: index)
        
        for index in 0..<maxLabel{
            
        }
        
        if let solitaireSelects = model.solitaireSelects{
            for (index, model) in solitaireSelects.enumerated(){
                
            }
        }
        
    }

    // MARK: -getter&setter
    
    lazy var questionTitleView: YXSSolitaireQuestionTitleView = {
        let questionTitleView = YXSSolitaireQuestionTitleView()
        return questionTitleView
    }()
}


class YXSSolitaireQuestionTitleView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(tipsLabel)
        self.addSubview(isNecessaryLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.right.equalTo(50)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(16.5)
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        isNecessaryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipsLabel.snp_right).offset(9.5)
            make.centerY.equalTo(tipsLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: YXSSolitaireQuestionModel, index: Int){
        var typeStr = ""
        switch model.type {
        case .single:
            typeStr = "单选题"
        case .checkbox:
        typeStr = "多选题"
            case .gap:
            typeStr = "填空题"
            case .image:
            typeStr = "图片题"
        }
        titleLabel.text = "\(index)、\(model.questionStemText ?? "")"
        tipsLabel.text = "【\(typeStr)】"
        isNecessaryLabel.isHidden = model.isNecessary ? false : true
    }

    // MARK: -getter&setter
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        return label
    }()
    
    lazy var tipsLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
    
    lazy var isNecessaryLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.cornerRadius = 9
        label.borderColor = UIColor.yxs_hexToAdecimalColor(hex: "#CC3333")
        label.borderWidth = 0.5
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#CC3333"), night: UIColor.yxs_hexToAdecimalColor(hex: "#CC3333"))
        return label
    }()
}


//class YXSSolitaireLabelImageView : UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(titleLabel)
//        self.addSubview(tipsLabel)
//        self.addSubview(isNecessaryLabel)
//        
//        titleLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.top.equalTo(0)
//            make.right.equalTo(50)
//        }
//        
//        tipsLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(titleLabel.snp_bottom).offset(16.5)
//            make.left.equalTo(titleLabel)
//            make.bottom.equalTo(0).priorityHigh()
//        }
//        
//        isNecessaryLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(tipsLabel.snp_right).offset(9.5)
//            make.centerY.equalTo(tipsLabel)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setModel(_ model: YXSSolitaireQuestionModel, index: Int){
//
//    }
//    
//    @objc func itemClick(){
//        
//    }
//
//    // MARK: -getter&setter
//    
//    lazy var titleLabel: YXSLabel = {
//        let label = YXSLabel()
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 15)
//        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
//        return label
//    }()
//    
//    lazy var meidaItem: YXSQuestionItem = {
//        let meidaItem = YXSQuestionItem(frame: CGRect.init(x: 0, y: 0, width: 84, height: 84))
//        meidaItem.addTaget(target: self, selctor: #selector(itemClick))
//        return meidaItem
//    }()
//}
