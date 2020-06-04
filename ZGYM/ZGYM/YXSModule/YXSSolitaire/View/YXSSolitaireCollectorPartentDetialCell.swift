//
//  YXSSolitaireCollectorPartentDetialCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/3.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight


class YXSSolitaireCollectorPartentDetialCell : YXSSolitaireQuestionBaseCell {
    var refreshCell: (()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for index in 0..<maxLabel{
            let answerControl = YXSSolitaireAnswerControl()
            answerControl.tag = index + labelOrginTag
            answerControl.isHidden = true
            answerControl.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
            contentView.addSubview(answerControl)
        }
        
        dealBtn.isHidden = true
        
        addSubview(textView)
        textView.addSubview(textCountlabel)
        textCountlabel.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.bottom.equalTo(-8.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSelect(control: YXSSolitaireAnswerControl){
        let index = control.tag - labelOrginTag
        if let solitaireSelects = model.solitaireSelects{
            let curruntSelect = solitaireSelects[index]
            if model.type == .single{
                //单选 其他选项直为为选中
                for select in solitaireSelects{
                    if select == curruntSelect{
                        select.isSelected = !select.isSelected
                    }else{
                        select.isSelected = false
                    }
                }
            }else{
                curruntSelect.isSelected = !curruntSelect.isSelected
            }
            
            refreshCell?()
        }
    }

    
    var model: YXSSolitaireQuestionModel!
    ///   - index: 题目下标 从0开始
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
        
        for index in 0..<maxLabel{
            let answerControl = contentView.viewWithTag(index + labelOrginTag) as? YXSSolitaireAnswerControl
            answerControl?.isHidden = true
            answerControl?.snp_removeConstraints()
        }
        textView.snp_removeConstraints()
        textView.isHidden = true
        
        if model.type == .single || model.type == .checkbox{
            if let solitaireSelects = model.solitaireSelects, solitaireSelects.count != 0{
                questionTitleView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(0)
                    make.top.equalTo(17)
                }
                var lastView: UIView = questionTitleView
                for (index, model) in solitaireSelects.enumerated(){
                    let answerControl = contentView.viewWithTag(index + labelOrginTag) as? YXSSolitaireAnswerControl
                    if let answerControl = answerControl{
                        answerControl.isHidden = false
                        answerControl.setModel(model, index: index)
                        answerControl.snp.remakeConstraints { (make) in
                            make.top.equalTo(lastView.snp_bottom).offset(index == 0 ? 17 : 10)
                            make.left.equalTo(15)
                            make.right.equalTo(-15)
                            if index == solitaireSelects.count - 1{
                                make.bottom.equalTo(-17).priorityHigh()
                            }
                        }
                        lastView = answerControl
                    }
                    
                    
                }
            }else{
                questionTitleView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(0)
                    make.top.equalTo(17)
                    make.bottom.equalTo(-17)
                }
            }
        }else if model.type == .gap{
            questionTitleView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(17)
            }
            textView.isHidden = false
            textView.snp.remakeConstraints { (make) in
                make.top.equalTo(questionTitleView.snp_bottom).offset(17)
                make.bottom.equalTo(-17).priorityHigh()
                make.left.equalTo(15)
                make.height.equalTo(135)
                make.right.equalTo(-15)
            }
        }else{
            
        }
        
    }
    
    // MARK: -getter&setter
    lazy var textView : YXSPlaceholderTextView = {
        let textView = YXSPlaceholderTextView()
        textView.limitCount = 200
        textView.font = kTextMainBodyFont
        textView.isScrollEnabled = false
        textView.placeholderMixColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"))
        let textColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
        textView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F7F9FD"), night: kNight20232F)
        textView.placeholder = "请输入内容..."
        textView.textContainerInset = UIEdgeInsets.init(top: 15.5, left: 13, bottom: 25, right: 13)
        textView.textDidChangeBlock = {
            [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.textCountlabel.text = text.isEmpty ? "200字内" : "\(text.count)/\(200)"
            strongSelf.model.answerContent = text
        }
        
        return textView
    }()
    
    lazy var textCountlabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        label.text = "200字内"
        return label
    }()
}
