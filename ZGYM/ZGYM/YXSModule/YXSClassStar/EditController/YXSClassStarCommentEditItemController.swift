//
//  YXSClassStarCommentEditItemController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/6.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSClassStarCommentEditItemController: YXSBaseViewController {
    var compeletBlock: (() -> ())?
    var itemModel: YXSClassStarCommentItemModel?
    var index: Int
    var classId: Int
    var dataSource: [YXSClassStarTypeModel]!
    var stage: StageType
    var selectTypeModel: YXSClassStarTypeModel{
        get{
            for model in self.dataSource{
                if model.isSelected{
                    return model
                }
            }
            return dataSource.first!
        }
    }
    ///当前item的图标地址   为空的话默认使用当前所属类型的item图标
    var curruntItemUrl: String?
    init(classId: Int,itemModel: YXSClassStarCommentItemModel?, index:Int,stage: StageType) {
        self.stage = stage
        self.classId = classId
        self.itemModel = itemModel
        self.index = index
        
        self.curruntItemUrl = itemModel?.evaluationUrl
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let topText = itemModel == nil ? "创建" : "编辑"
        let midText = index == 0 ? "表扬" : "批评"
        title = topText + midText + "类型"
        createButton.setTitle(itemModel == nil ? "创建" : "更新", for: .normal)
        
        if let itemModel = itemModel{
            nameFieldLabel.contentField.text = itemModel.evaluationItem
            buttonView.selectIndex = (Int(abs(itemModel.score ?? 1)) ) - 1
            allSwitch.swt.isOn = (itemModel.type ?? "") == "20"
            logoImageView.sd_setImage(with: URL.init(string: (curruntItemUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),placeholderImage: kImageDefualtImage, completed: nil)
        }
        
        loadData()
    }
    
    // MARK: -UI
    func initUI(){
        view.addSubview(logoImageView)
        view.addSubview(nameFieldLabel)
        view.addSubview(buttonView)
        view.addSubview(typeSection)
        view.addSubview(allSwitch)
        view.addSubview(createButton)
        view.addSubview(editButton)
        
        logoImageView.snp.makeConstraints { (make) in
                        make.width.height.equalTo(70)
            make.top.equalTo(41)
            make.centerX.equalTo(view)
        }
        editButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(23)
            make.bottom.equalTo(logoImageView)
            make.right.equalTo(logoImageView).offset(-2)
        }
        nameFieldLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-35)
            make.top.equalTo(logoImageView.snp_bottom).offset(60)
            make.height.equalTo(64)
        }
        buttonView.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameFieldLabel)
            make.top.equalTo(nameFieldLabel.snp_bottom)
            make.height.equalTo(64)
        }
        typeSection.snp.makeConstraints { (make) in
            make.left.equalTo(nameFieldLabel)
            make.right.equalTo(-15)
            make.top.equalTo(buttonView.snp_bottom)
            make.height.equalTo(64)
        }
        allSwitch.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameFieldLabel)
            make.top.equalTo(typeSection.snp_bottom)
            make.height.equalTo(64)
        }
        
        createButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize.init(width: 318, height: 49))
            make.bottom.equalTo(-kSafeBottomHeight - 15)
        }
        if let itemModel = itemModel{
            for model in dataSource{
                if Int(itemModel.evaluationType ?? "") == model.code{
                    model.isSelected = true
                    typeSection.rightLabel.text = model.name
                    typeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
                    break
                }
            }
        }else{
            if dataSource.count > 0{
                typeSection.rightLabel.text = dataSource[0].name
                typeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            }
        }
        
        changeItemImageLogo()
    }
    
    
    // MARK: -loadData
    func loadData(){
        YXSEducationFEvaluationListTypeListRequest(stage: stage).requestCollection({ (list:[YXSClassStarTypeModel]) in
            self.dataSource = list
            self.initUI()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg, inView: self.view)
        }
    }
    // MARK: -action
    @objc func createClick(){
        if nameFieldLabel.contentField.text?.count == 0{
            MBProgressHUD.yxs_showMessage(message: "请输入名称")
            return
        }
        
        var evaluationUrl = ""
        if let curruntItemUrl = curruntItemUrl{
            evaluationUrl = curruntItemUrl
        }else{
            evaluationUrl = selectTypeModel.iconUrl ?? ""
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        YXSEducationFEvaluationListSaveOrUpdateRequest.init(id: itemModel?.id,classId: classId, category: index == 0 ? 10 : 20, evaluationItem: nameFieldLabel.contentField.text!, evaluationUrl: evaluationUrl, evaluationType: selectTypeModel.code ?? 0, score: buttonView.score, type: allSwitch.swt.isOn ? 20 : 30,stage: stage).request({ (item: YXSClassStarCommentItemModel) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //新增item 插入到第一条
            let isUpdate =  self.itemModel == nil ? false : true
            item.evaluationType = "\(self.selectTypeModel.code ?? 0)"
            for vc in self.navigationController!.viewControllers{
                if vc is YXSClassStarCommentEditItemListController{
                    let listVc = vc as! YXSClassStarCommentEditItemListController
                    listVc.updateItems(item: item, defultIndex: self.index, isUpdate: isUpdate)
                }
                if vc is YXSClassStarTeacherPublishCommentController{
                    let publishVc = vc as! YXSClassStarTeacherPublishCommentController
                    publishVc.updateItems(item: item, defultIndex: self.index, isUpdate: isUpdate)
                }
                if vc is YXSClassStarSignleClassStudentDetialController{
                    let publishVc = vc as! YXSClassStarSignleClassStudentDetialController
                    publishVc.updateItems(item: item, defultIndex: self.index, isUpdate: isUpdate)
                }
                
            }
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
        changeItemImageLogo()
    }
    
    @objc func typeSectionClick(){
        var titles = [String]()
        var selectIndex = 0
        for (index,model) in self.dataSource.enumerated(){
            titles.append(model.name ?? "")
            if model.isSelected{
                selectIndex = index
            }
        }
        YXSSolitaireSelectReasonView.init(items: titles, selectedIndex: selectIndex,title: "所属类型", inTarget: self.navigationController!.view) {[weak self] (view, selectIndex) in
            guard let strongSelf = self else { return }
            strongSelf.typeSection.rightLabel.text = strongSelf.dataSource[selectIndex].name
            strongSelf.typeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            
            for (index,model) in strongSelf.dataSource.enumerated(){
                if index == selectIndex{
                    model.isSelected = true
                }else{
                    model.isSelected = false
                }
            }
            strongSelf.changeItemImageLogo()
            view.cancelClick(sender: nil)
        }
        
    }
    
    @objc func editImageClick(){
        let vc = YXSClassStarEvaluationItemLogoViewController()
        vc.complete = {
            [weak self] (imageUrl) in
            guard let strongSelf = self else { return }
            strongSelf.curruntItemUrl = imageUrl
            strongSelf.changeItemImageLogo()
        }
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: -private
    ///修改item url
    func changeItemImageLogo(){
        var newUrl = ""
        //当前有curruntItemUrl  (修改item 或者编辑选择了)
        if let curruntItemUrl = curruntItemUrl{
            newUrl = curruntItemUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }else{
            newUrl = (selectTypeModel.iconUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        logoImageView.sd_setImage(with: URL.init(string: newUrl),placeholderImage: kImageDefualtImage, completed: nil)
    }
    
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView.init(image: kImageDefualtImage)
        logoImageView.cornerRadius = 35
        return logoImageView
    }()
    
    lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.setBackgroundImage(UIImage.init(named: "yxs_classstar_edit_image"), for: .normal)
        editButton.yxs_touchInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        editButton.addTarget(self, action: #selector(editImageClick), for:  .touchUpInside)
        return editButton
    }()
    
    
    lazy var nameFieldLabel: HMRightTextFieldLabel = {
        let nameFieldLabel = HMRightTextFieldLabel()
        nameFieldLabel.contentField.placeholder = "请输入名称(10个字符内)"
        nameFieldLabel.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return nameFieldLabel
    }()
    lazy var buttonView: ClassStarCommentButtonView = {
        let buttonView = ClassStarCommentButtonView.init(dataSource: [ClassStarCommentButtonModel.init(score: 1, isSelect: true),ClassStarCommentButtonModel.init(score: 2, isSelect: false),ClassStarCommentButtonModel.init(score: 3, isSelect: false),ClassStarCommentButtonModel.init(score: 4, isSelect: false),ClassStarCommentButtonModel.init(score: 5, isSelect: false)])
        buttonView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return buttonView
    }()
    lazy var typeSection: SLTipsRightLabelSection = {
        let typeSection = SLTipsRightLabelSection()
        typeSection.leftlabel.text = "所属类型"
        typeSection.rightLabel.text = "请选择"
        typeSection.addTarget(self, action: #selector(typeSectionClick), for: .touchUpInside)
        typeSection.yxs_addLine(position: .bottom, rightMargin: 20)
        typeSection.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return typeSection
    }()
    
    lazy var allSwitch: YXSPublishSwitchLabel = {
        let allSwitch = YXSPublishSwitchLabel()
        allSwitch.titleLabel.text = "应用到我所有班级"
        allSwitch.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return allSwitch
    }()
    
    
    lazy var createButton: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.cornerRadius = 24.5
        btn.setTitle("创建", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.addShadow(ofColor: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        btn.addTarget(self, action: #selector(createClick), for: .touchUpInside)
        return btn
    }()
}


class ClassStarCommentButtonModel: NSObject{
    var score: Int
    var isSelect: Bool
    init(score: Int, isSelect: Bool){
        self.score = score
        self.isSelect = isSelect
        super.init()
        
    }
}
private let buttonTag = 101
class ClassStarCommentButtonView: UIView {
    public var score: Int{
        get{
            for model in dataSource{
                if model.isSelect{
                    return Int(model.score)
                }
            }
            return 0
        }
    }
    
    public var selectIndex: Int = 0{
        didSet{
            for index in 0..<dataSource.count{
                let buttonView = viewWithTag(buttonTag + index) as! YXSButton
                buttonView.isSelected = false
                
                if index == selectIndex{
                    buttonView.isSelected = true
                }
                dataSource[index].isSelect = buttonView.isSelected
            }
        }
    }
    
    var dataSource: [ClassStarCommentButtonModel]
    init(dataSource: [ClassStarCommentButtonModel]) {
        self.dataSource = dataSource
        super.init(frame: CGRect.zero)
        addSubview(titleLabel)
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        yxs_addLine(position: .bottom, leftMargin: 15.5)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15.5)
            make.right.equalTo(60)
            make.centerY.equalTo(self)
        }
        let count = dataSource.count
        for index in 0..<count{
            let button = YXSButton.init()
            button.setTitleColor(UIColor.white, for: .selected)
            button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
            button.setTitle("\(dataSource[index].score)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setBackgroundImage(UIImage.yxs_image(with: kBlueColor), for: .selected)
            button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")), for: .normal)
            button.cornerRadius = 11
            button.tag = buttonTag + index
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            addSubview(button)
            
            button.snp.makeConstraints { (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(CGFloat(-(count - index - 1))*SCREEN_SCALE*21.5 + CGFloat(-(count - index - 1))*22)
                make.width.height.equalTo(22)
            }
            button.isSelected = dataSource[index].isSelect
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClick(_ button: YXSButton){
        if button.isSelected{
            return
        }
        let count = dataSource.count
        for index in 0..<count{
            let buttonView = viewWithTag(buttonTag + index) as! YXSButton
            buttonView.isSelected = false
            
            if buttonView == button{
                buttonView.isSelected = true
            }
            
            dataSource[index].isSelect = buttonView.isSelected
        }
    }
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "分值"
        return label
    }()
    
}
