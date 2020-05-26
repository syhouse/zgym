//
//  YXSPublishTemplateSection.swift
//  
//
//  Created by sy_mac on 2020/5/26.
//

import NightNight

private let publishTemplateButtonOrginTag: Int = 2003
class YXSPublishTemplateSection: UIView{
    public var pushTemplateListBlock: (() ->())?
    public var didSelectTemplateBlock:((_ item: YXSTemplateListModel) ->())?
    private var items:[YXSTemplateListModel] = [YXSTemplateListModel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topControl)
        addSubview(scrollView)
        topControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(2)
            make.height.equalTo(44)
        }
        topControl.arrowImage.snp.remakeConstraints { (make) in
            make.right.equalTo(-14)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(topControl)
        }
        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topControl.snp_bottom)
            make.height.equalTo(45.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public func setTemplates(items: [YXSTemplateListModel]){
        scrollView.removeSubviews()
        let containerView = UIView()
        scrollView.addSubview(containerView)
        
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.items = items
        var last: UIView?
        for (index, model) in items.enumerated(){
            let button = UIButton()
            button.borderWidth = 1
            button.setBackgroundImage(UIImage.yxs_image(with: UIColor.white), for: .selected)
            button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")), for: .normal)
            button.setTitleColor(kBlueColor, for: .selected)
            button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), for: .normal)
            button.setTitle(model.title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.tag = publishTemplateButtonOrginTag + index
            button.cornerRadius = 14.5
            
            let width = (model.title ?? "").yxs_getTextRectSize(font: UIFont.systemFont(ofSize: 14), size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width + 24
            if index == 0{
                button.isSelected = true
            }else{
                button.isSelected = false
            }
            updateButtonUI(button)
            containerView.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.height.equalTo(29)
                make.top.equalTo(0)
                make.width.equalTo(width)
                if let last = last{
                    make.left.equalTo(last.snp_right).offset(6)
                }else{
                    make.left.equalTo(15)
                }
                if index == items.count - 1{
                    make.right.equalTo(-15)
                }
                
            }
            
            last = button
        }
    }
    
    private func updateButtonUI(_ button: UIButton){
        if button.isSelected{
            button.borderColor = kBlueColor
            
        }else{
            button.borderColor = UIColor.clear
        }
    }
    
     @objc private func topControlClick(button: UIButton){
        if button.isSelected{
            return
        }
        let index = button.tag - publishTemplateButtonOrginTag
        for(index, _) in items.enumerated(){
            let subButton = scrollView.viewWithTag(publishTemplateButtonOrginTag + index) as? UIButton
            subButton?.isSelected = false
        }
        button.isSelected = true
        updateButtonUI(button)
        didSelectTemplateBlock?(items[index])
    }
    
    lazy var topControl: SLTipsBaseSection = {
        let topControl = SLTipsBaseSection()
        topControl.leftlabel.text = "打卡模版"
        topControl.addTarget(self, action: #selector(topControlClick), for: .touchUpInside)
        return topControl
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
}
