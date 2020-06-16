//
//  YXSSolitaireCollectorPartentDetialCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/3.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight


class YXSSolitaireCollectorPartentDetialBaseCell : YXSSolitaireQuestionBaseCell {
    var refreshCell: (()->())?
    var changeMedias: ((_ medias: [SLPublishEditMediaModel])->())?
    
    var textViewBeginEdit: (()->())?
    
    var canEdit: Bool = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dealBtn.isHidden = true
        contentView.yxs_addLine(leftMargin: 15)
        
        questionTitleView.rightGap = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: YXSSolitaireQuestionModel!
    ///   - index: 题目下标 从0开始
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
    }
}


class YXSSolitaireCollectorPartentDetialSelectItemsCell : YXSSolitaireCollectorPartentDetialBaseCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for index in 0..<maxQuestionCount{
            let answerControl = YXSSolitaireAnswerControl()
            answerControl.tag = index + labelOrginTag
            answerControl.answerView.titleRightGap = 50
            answerControl.isHidden = true
            answerControl.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
            contentView.addSubview(answerControl)
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
    
    ///   - index: 题目下标 从0开始
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
        
        for index in 0..<maxQuestionCount{
            let answerControl = contentView.viewWithTag(index + labelOrginTag) as? YXSSolitaireAnswerControl
            answerControl?.isHidden = true
            answerControl?.isUserInteractionEnabled = canEdit
            answerControl?.snp_removeConstraints()
        }
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
                        }
                        lastView = answerControl
                    }
                    
                    
                }
            }
            
        }
    }
}

class YXSSolitaireCollectorPartentDetialTextCell : YXSSolitaireCollectorPartentDetialBaseCell , UITextViewDelegate{

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(textView)
        textView.addSubview(textCountlabel)
        textCountlabel.snp.makeConstraints { (make) in
            make.right.equalTo(textView).offset(-14)
            make.bottom.equalTo(textView).offset(-8.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///   - index: 题目下标 从0开始
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
        
        questionTitleView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(17)
        }
        textCountlabel.isHidden = false
        textView.isHidden = false
        textView.snp.remakeConstraints { (make) in
            make.top.equalTo(questionTitleView.snp_bottom).offset(17)
            make.left.equalTo(15)
            make.height.equalTo(135)
            make.right.equalTo(-15)
        }
        textView.isEditable = canEdit
        
        setTextViewText(text: model.answerContent ?? "")
    }
    
    // MARK: - private
    func setTextViewText(text: String){
        textView.text = text
        textCountlabel.text = text.isEmpty ? "200字内" : "\(text.count)/\(200)"
        model.answerContent = text
    }
    
    // MARK: -getter&setter
    lazy var textView : YXSPlaceholderTextView = {
        let textView = YXSPlaceholderTextView()
        textView.limitCount = 200
        textView.font = kTextMainBodyFont
        //        textView.isScrollEnabled = false
        textView.placeholderMixColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"))
        let textColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
        textView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F7F9FD"), night: kNight20232F)
        textView.placeholder = "请输入内容..."
        textView.textContainerInset = UIEdgeInsets.init(top: 15.5, left: 13, bottom: 25, right: 13)
        textView.borderColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        textView.cornerRadius = 2.5
        textView.delegate = self
        textView.borderWidth = 0.5
        textView.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        textView.textDidChangeBlock = {
            [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.setTextViewText(text: text)
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textViewBeginEdit?()
        return true
    }
}



class YXSSolitaireCollectorPartentDetialImageCell : YXSSolitaireCollectorPartentDetialBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(editMediaView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///   - index: 题目下标 从0开始
    override func setCellModel(_ model: YXSSolitaireQuestionModel, index: Int){
        self.model = model
        super.setCellModel(model, index: index)
        questionTitleView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(17)
        }
        editMediaView.isHidden = false
        editMediaView.medias = model.answerMedias
        editMediaView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(questionTitleView.snp_bottom).offset(17)
        }
        editMediaView.isUserInteractionEnabled = canEdit
    }
    
    // MARK: - private
    
    private lazy var editMediaView: YXSEditNineMediaView = {
        let editMediaView = YXSEditNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        editMediaView.edges = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        editMediaView.updateMeida = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.changeMedias?(strongSelf.editMediaView.medias ?? [SLPublishEditMediaModel]())
        }
        return editMediaView
    }()
}
