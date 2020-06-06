//
//  YXSQuestionPublishNewSelectItemsView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

let maxItems: Int = 6

///接龙题目选项view
class YXSQuestionPublishNewSelectItemsView: UIView{
    var updateItemsBlock: ((_ selectModels: [SolitairePublishNewSelectModel]) ->())?
    
    var selectModels: [SolitairePublishNewSelectModel]
    init(selectModels: [SolitairePublishNewSelectModel]?) {
        if let  selectModels = selectModels {
            self.selectModels = selectModels
        }else{
            let model = SolitairePublishNewSelectModel()
            model.index = 0
            self.selectModels = [model]
        }
        super.init(frame: CGRect.zero)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showMoreClick(){
        let model = SolitairePublishNewSelectModel()
        model.index = self.selectModels.count
        self.selectModels.append(model)
        updateUI(true)
    }
    
    func updateUI(_ becomeFirst: Bool = false){
        removeSubviews()
        let showMore:Bool = self.selectModels.count < maxItems
        var last: UIView!
        for (index, model) in self.selectModels.enumerated(){
            let section = YXSQuestionPublishItem.init(selectModel: model, showDelect: index != 0)
            addSubview(section)
            if becomeFirst, index == self.selectModels.count - 1{
                section.contentField.becomeFirstResponder()
            }
            
            section.sectionBlock = {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.selectModels.remove(at: strongSelf.selectModels.firstIndex(of: model) ?? 0)
                strongSelf.updateUI(true)
            }
            section.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                if index == 0{
                    make.top.equalTo(0)
                }else{
                    make.top.equalTo(last.snp_bottom)
                }
                
                if !showMore && index == 3{
                    make.bottom.equalTo(0)
                }
            }
            last = section
        }
        
        if showMore{
            let button = YXSButton.init()
            button.setTitleColor(kBlueColor, for: .normal)
            button.setTitle("增加选项", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            button.setImage(UIImage.init(named: "yxs_solitaire_add"), for: .normal)
            button.addTarget(self, action: #selector(showMoreClick), for: .touchUpInside)
            button.yxs_setIconInLeftWithSpacing(5)
            addSubview(button)
            button.snp.makeConstraints { (make) in
                make.height.equalTo(49)
                make.top.equalTo(last.snp_bottom)
                make.left.right.bottom.equalTo(0)
            }
        }
        
        updateItemsBlock?(selectModels)
    }
}

///接龙题目单个选项view
class YXSQuestionPublishItem: UIView, YXSSelectMediaHelperDelegate{
    var selectModel: SolitairePublishNewSelectModel?
    var showDelect: Bool
    init(selectModel: SolitairePublishNewSelectModel?, showDelect: Bool) {
        self.selectModel = selectModel
        self.showDelect = showDelect
        super.init(frame: CGRect.zero)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        addSubview(leftLabel)
        addSubview(contentField)
        addSubview(selectImageBtn)
        addSubview(meidaItem)
        yxs_addLine(position: .bottom, leftMargin: 15.5, rightMargin: 0.5, lineHeight: 0.5)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(21)
        }
        contentField.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-65)
            make.top.equalTo(18.5)
            make.height.equalTo(25)
        }
        selectImageBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-21.5)
            make.top.equalTo(12)
            make.bottom.equalTo(-24).priorityHigh()
            make.height.equalTo(25)
            make.width.height.equalTo(29)
        }
        if showDelect{
            addSubview(delectButton)
            delectButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.height.equalTo(13)
                make.bottom.equalTo(-8.5)
            }
        }
        
        ///初始化数据
        contentField.text = selectModel?.title
        
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(){
        meidaItem.isHidden = true
        let size = contentField.sizeThatFits(CGSize.init(width: SCREEN_WIDTH - 30 - 65, height: 3000))
        var textHeight = size.height + 8
        if textHeight > 50{
            textHeight = 50
        }
        if textHeight < 25{
            textHeight = 25
        }
        contentField.snp.updateConstraints({ (make) in
            make.height.equalTo(textHeight)
        })
        
        if let mediaModel = selectModel?.mediaModel{
            meidaItem.isHidden = false
            meidaItem.snp.remakeConstraints { (make) in
                make.top.equalTo(contentField.snp_bottom).offset(12.5)
                make.left.equalTo(36.5)
                make.bottom.equalTo(-20).priorityHigh()
                make.size.equalTo(CGSize.init(width: 84, height: 84))
            }
            meidaItem.model = mediaModel
            
            selectImageBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(-21.5)
                make.top.equalTo(12)
                make.height.equalTo(25)
                make.width.height.equalTo(29)
            }
            selectImageBtn.isSelected = true
        }else{
            selectImageBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(-21.5)
                make.top.equalTo(12)
                make.bottom.equalTo(-34).priorityHigh()
                make.height.equalTo(25)
                make.width.height.equalTo(29)
            }
            selectImageBtn.isSelected = false
        }
        
        
    }
    
    // MARK: -action
    var sectionBlock: (() ->())?
    @objc func delectClick(){
        sectionBlock?()
    }
    
    @objc func itemClick(tap : UITapGestureRecognizer){
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
    
    @objc func selectClick(){
        if selectImageBtn.isSelected{
            return
        }
        YXSSelectMediaHelper.shareHelper.showSelectMedia(selectImage: true)
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    // MARK: - ImgSelectDelegate
    func didSelectMedia(asset: YXSMediaModel) {
        let mediaModel = SLPublishMediaModel()
        mediaModel.asset = asset.asset
        selectModel?.mediaModel = mediaModel
        meidaItem.model = mediaModel
        updateUI()
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        let mediaModel = SLPublishMediaModel()
        mediaModel.asset = assets.first?.asset
        selectModel?.mediaModel = mediaModel
        meidaItem.model = mediaModel
        updateUI()
    }
    
    // MARK: - getter&setter
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        label.text = selectModel?.leftText
        return label
    }()
    
    lazy var contentField: YXSPlaceholderTextView = {
        let textView = YXSPlaceholderTextView()
        textView.limitCount = 50
        textView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.placeholderMixColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"))
        textView.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        textView.placeholder = "请输入选项内容"
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        textView.textDidChangeBlock = {
            [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.selectModel?.title = text
            strongSelf.updateUI()
        }
        return textView
    }()
    
    lazy var delectButton: YXSButton = {
        let button = YXSButton.init()
        button.setTitle("删除选项", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        button.addTarget(self, action: #selector(delectClick), for: .touchUpInside)
        button.yxs_touchInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var selectImageBtn: YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_solitaire_image_light"), for: .normal)
        button.setBackgroundImage(UIImage.init(named: "yxs_solitaire_image_gray"), for: .selected)
        button.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        button.yxs_touchInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var meidaItem: YXSQuestionItem = {
        let meidaItem = YXSQuestionItem(frame: CGRect.init(x: 0, y: 0, width: 36, height: 36))
        meidaItem.itemRemoveBlock = {
            [weak self] (model) in
            guard let strongSelf = self else { return }
            strongSelf.selectModel?.mediaModel = nil
            strongSelf.updateUI()
        }
        meidaItem.addTaget(target: self, selctor: #selector(itemClick))
        return meidaItem
    }()
}

///接龙题目选项Model
class SolitairePublishNewSelectModel: NSObject, NSCoding{
    var title: String?
    var index: Int = 0{
        didSet{
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
        }
    }
    var leftText: String?
    
    var mediaModel: SLPublishMediaModel?
    
    var isSelected: Bool = false
    
    ///家长选择人数
    var gatherTopicCount: Int?
    
    ///家长选择百分比
    var ratio: Int?
    
    override init() {
    }
    
    @objc required init(coder aDecoder: NSCoder){
        title = aDecoder.decodeObject(forKey: "title") as? String
        index = aDecoder.decodeInteger(forKey: "index")
        leftText = aDecoder.decodeObject(forKey: "leftText") as? String
        mediaModel = aDecoder.decodeObject(forKey: "mediaModel") as? SLPublishMediaModel
        isSelected = aDecoder.decodeBool(forKey: "isSelected")
        
        ratio = aDecoder.decodeObject(forKey: "ratio") as? Int
        gatherTopicCount = aDecoder.decodeObject(forKey: "gatherTopicCount") as? Int
    }
    @objc func encode(with aCoder: NSCoder)
    {
        if title != nil{
            aCoder.encode(title, forKey: "title")
            
        }
        if leftText != nil{
            aCoder.encode(leftText, forKey: "leftText")
            
        }
        
        if mediaModel != nil{
            aCoder.encode(mediaModel, forKey: "mediaModel")
        }
        
        aCoder.encode(index, forKey: "index")
        aCoder.encode(isSelected, forKey: "isSelected")
        
        if ratio != nil{
            aCoder.encode(ratio, forKey: "ratio")
        }
        if gatherTopicCount != nil{
            aCoder.encode(gatherTopicCount, forKey: "gatherTopicCount")
        }
    }
}
