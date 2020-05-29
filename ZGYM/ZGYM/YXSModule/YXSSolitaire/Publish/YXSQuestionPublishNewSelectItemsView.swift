//
//  YXSQuestionPublishNewSelectItemsView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import NightNight

let maxItems: Int = 6

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
                make.height.equalTo(75)
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
        addSubview(meidaItem)
        yxs_addLine(position: .bottom, leftMargin: 15.5, rightMargin: 0.5, lineHeight: 0.5)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.centerY.equalTo(self)
        }
        contentField.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.bottom.equalTo(0)
            make.right.equalTo(-65)
        }
        meidaItem.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-22.5)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
        }
        if showDelect{
            addSubview(delectButton)
            delectButton.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.height.equalTo(13)
                make.top.equalTo(meidaItem.snp_bottom).offset(8)
            }
        }
        
        ///初始化数据
        contentField.text = selectModel?.title
        meidaItem.model = selectModel?.mediaModel
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.greetingTextFieldChanged),
                                               name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
                                               object: self.contentField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: -action
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, length: 50)
        selectModel?.title = contentField.text
    }
    
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
        }else{
            YXSSelectMediaHelper.shareHelper.showSelectMedia(selectImage: true)
            YXSSelectMediaHelper.shareHelper.delegate = self
        }
    }
    
    // MARK: - ImgSelectDelegate
    func didSelectMedia(asset: YXSMediaModel) {
        let mediaModel = SLPublishMediaModel()
        mediaModel.asset = asset.asset
        selectModel?.mediaModel = mediaModel
        meidaItem.model = mediaModel
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        let mediaModel = SLPublishMediaModel()
        mediaModel.asset = assets.first?.asset
        selectModel?.mediaModel = mediaModel
        meidaItem.model = mediaModel
    }
    
    // MARK: - getter&setter
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        label.text = selectModel?.leftText
        return label
    }()
    
    lazy var contentField: YXSQSTextField = {
        let contentField = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0), placeholder: "请输入选项内容", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: kNightBCC6D4))
        return contentField
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
    
    lazy var meidaItem: YXSQuestionItem = {
        let meidaItem = YXSQuestionItem(frame: CGRect.init(x: 0, y: 0, width: 36, height: 36))
        meidaItem.itemRemoveBlock = {
            [weak self] (model) in
            guard let strongSelf = self else { return }
            strongSelf.selectModel?.mediaModel = nil
            strongSelf.meidaItem.image = strongSelf.meidaItem.defultImage
        }
        meidaItem.addTaget(target: self, selctor: #selector(itemClick))
        return meidaItem
    }()
}


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
    
    override init() {
    }
    
    @objc required init(coder aDecoder: NSCoder){
        title = aDecoder.decodeObject(forKey: "title") as? String
        index = aDecoder.decodeInteger(forKey: "index")
        leftText = aDecoder.decodeObject(forKey: "leftText") as? String
        mediaModel = aDecoder.decodeObject(forKey: "mediaModel") as? SLPublishMediaModel
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
        
    }
}
