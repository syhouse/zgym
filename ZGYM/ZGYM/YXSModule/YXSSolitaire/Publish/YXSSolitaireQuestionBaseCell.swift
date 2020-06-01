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


class YXSSolitaireQuestionItemsCell : YXSSolitaireQuestionBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for index in 0..<maxLabel{
            let labelImageView = YXSSolitaireLabelImageView()
            labelImageView.tag = index + labelOrginTag
            labelImageView.isHidden = true
            contentView.addSubview(labelImageView)
        }
    }
    
    override func layout() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        super.setCellModel(model, index: index)
        
        for index in 0..<maxLabel{
            let labelImageView = contentView.viewWithTag(index + labelOrginTag) as? YXSSolitaireLabelImageView
            labelImageView?.isHidden = true
            labelImageView?.snp_removeConstraints()
        }
        
        if let solitaireSelects = model.solitaireSelects, solitaireSelects.count != 0{
            questionTitleView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(17)
            }
            var lastView: UIView = questionTitleView
            for (index, model) in solitaireSelects.enumerated(){
                let labelImageView = contentView.viewWithTag(index + labelOrginTag) as? YXSSolitaireLabelImageView
                if let labelImageView = labelImageView{
                    labelImageView.isHidden = false
                    labelImageView.setModel(model, index: index)
                    labelImageView.snp.remakeConstraints { (make) in
                        make.top.equalTo(lastView.snp_bottom).offset(17)
                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        if index == solitaireSelects.count - 1{
                            make.bottom.equalTo(-17).priorityHigh()
                        }
                    }
                    lastView = labelImageView
                }
                
                
            }
        }else{
            questionTitleView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(17)
                make.bottom.equalTo(-17)
            }
        }
        
    }
    
    // MARK: -getter&setter
    
}



class YXSSolitaireQuestionBaseCell : UITableViewCell {
    var questionDealBlock: (()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(questionTitleView)
        contentView.addSubview(dealBtn)
        layout()
        
        dealBtn.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.right.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 30, height: 16))
        }
    }
    
    func layout(){
        questionTitleView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(17)
            make.bottom.equalTo(-17)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        questionTitleView.setModel(model, index: index)
    }
    
    @objc func dealBtnClick(){
        questionDealBlock?()
    }
    
    // MARK: -getter&setter
    
    lazy var questionTitleView: YXSSolitaireQuestionTitleView = {
        let questionTitleView = YXSSolitaireQuestionTitleView()
        return questionTitleView
    }()
    
    lazy var dealBtn: YXSButton = {
        let dealBtn = YXSButton.init()
        dealBtn.setImage(UIImage.init(named: "yxs_punchCard_list_down"), for: .normal)
        dealBtn.addTarget(self, action: #selector(dealBtnClick), for: .touchUpInside)
        dealBtn.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return dealBtn
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
            make.right.equalTo(-50)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(16.5)
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        isNecessaryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipsLabel.snp_right).offset(9.5)
            make.size.equalTo(CGSize(width: 35, height: 18))
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
        titleLabel.text = "\(index + 1)、\(model.questionStemText ?? "")"
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
        label.text = "必答"
        label.textAlignment = .center
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#CC3333"), night: UIColor.yxs_hexToAdecimalColor(hex: "#CC3333"))
        return label
    }()
}


class YXSSolitaireLabelImageView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(meidaItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: SolitairePublishNewSelectModel, index: Int){
        var leftText = ""
        switch index {
        case 0:
            leftText = "A"
        case 1:
            leftText = "B"
        case 2:
            leftText = "C"
        case 3:
            leftText = "D"
        case 4:
            leftText = "E"
        case 5:
            leftText = "F"
        default:
            leftText = "H"
        }
        titleLabel.text = "\(leftText)、\(model.title ?? "")"
        meidaItem.isHidden = true
        if let mediaModel = model.mediaModel{
            meidaItem.model = mediaModel
            titleLabel.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(0)
            }
            
            meidaItem.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp_bottom).offset(12.5)
                make.left.equalTo(titleLabel)
                make.size.equalTo(CGSize(width: 84, height: 84))
                make.bottom.equalTo(0).priorityHigh()
            }
            meidaItem.isHidden = false
        }else{
            titleLabel.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(0)
                make.bottom.equalTo(0).priorityHigh()
            }
        }
    }
    
    @objc func itemClick(){
        if let model = meidaItem.model{
            var urls = [URL]()
            var assets = [PHAsset]()
            if model.isService{
                if let  url = URL.init(string: model.serviceUrl ?? ""){
                    urls = [url]
                }
            }else{
                assets = [model.asset]
            }
            YXSShowBrowserHelper.showImage(urls: urls,assets: assets, currentIndex: 0)
        }
    }
    
    // MARK: -getter&setter
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        return label
    }()
    
    lazy var meidaItem: YXSSinglImage = {
        let meidaItem = YXSSinglImage(frame: CGRect.init(x: 0, y: 0, width: 84, height: 84))
        meidaItem.addTaget(target: self, selctor: #selector(itemClick))
        return meidaItem
    }()
}
