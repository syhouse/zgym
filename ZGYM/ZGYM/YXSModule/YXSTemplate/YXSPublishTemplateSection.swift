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
    public var type: YXSTemplateType = .punchcard
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
            make.height.equalTo(scrollView)
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
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            let width = (model.title ?? "").yxs_getTextRectSize(font: UIFont.systemFont(ofSize: 14), size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width + 24
            button.isSelected = model.isSelected
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
    
    @objc private func buttonClick(button: UIButton){
        if button.isSelected{
            return
        }
        let index = button.tag - publishTemplateButtonOrginTag
        let item = items[index]
        updateButtonUI(item: item)
        didSelectTemplateBlock?(item)
    }
    
    private func updateButtonUI(item: YXSTemplateListModel){
        var selectIndex = 0
        for (index, model) in items.enumerated(){
            if model.id == item.id{
                selectIndex = index
                break
            }
        }
        for(index, model) in items.enumerated(){
            let subButton = scrollView.viewWithTag(publishTemplateButtonOrginTag + index) as? UIButton
            if let subButton = subButton{
                if index == selectIndex{
                    subButton.isSelected = true
                    model.isSelected = true
                }else{
                    subButton.isSelected = false
                    model.isSelected = false
                }
                subButton.setTitle(model.title, for: .normal)
                updateButtonUI(subButton)
            }
        }
    }
    
     @objc private func topControlClick(){
        let vc = YXSTemplateListController(type: type, templateItems: items)
        vc.didSelectTemplateModel = {[weak self] (item)
            in
            guard let strongSelf = self else { return }
            ///通知模版
            if strongSelf.type == .notice{
                var isCotainItem = false
                var containIndex = 0
                for (index, model) in strongSelf.items.enumerated(){
                    if model.id == item.id{
                        containIndex = index
                        isCotainItem = true
                        break
                    }
                }
                if isCotainItem{
                    strongSelf.items.remove(at: containIndex)
                }else{
                    strongSelf.items.removeLast()
                }
                strongSelf.items.insert(item, at: 0)
                
            }
            strongSelf.updateButtonUI(item: item)
            strongSelf.didSelectTemplateBlock?(item)
        }
        UIUtil.currentNav().pushViewController(vc)
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
