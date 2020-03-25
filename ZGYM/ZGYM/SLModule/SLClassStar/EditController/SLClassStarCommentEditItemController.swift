//
//  SLClassStarCommentEditItemController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/6.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLClassStarCommentEditItemController: SLBaseViewController {
    var compeletBlock: (() -> ())?
    var itemModel: SLClassStarCommentItemModel?
    var index: Int
    var classId: Int
    var dataSource: [SLClassStarTypeModel]!
    var stage: StageType
    var selectTypeModel: SLClassStarTypeModel{
        get{
            for model in self.dataSource{
                if model.isSelected{
                    return model
                }
            }
            return dataSource.first!
        }
    }
    init(classId: Int,itemModel: SLClassStarCommentItemModel?, index:Int,stage: StageType) {
        self.stage = stage
        self.classId = classId
        self.itemModel = itemModel
        self.index = index
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
            buttonView.selectIndex = (itemModel.score ?? 1) - 1
            allSwitch.swt.isSelected = (itemModel.type ?? "") == "20"
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
        
        logoImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.top.equalTo(41)
            make.centerX.equalTo(view)
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
        var newUrl = ""
        if let itemModel = itemModel{
            for model in dataSource{
                if Int(itemModel.evaluationType ?? "") == model.code{
                    model.isSelected = true
                    typeSection.rightLabel.text = model.name
                    typeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
                     newUrl = (model.iconUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    
                    break
                }
            }
        }else{
            if dataSource.count > 0{
                typeSection.rightLabel.text = dataSource[0].name
                typeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
                newUrl = (dataSource[0].iconUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            
        }
        logoImageView.sd_setImage(with: URL.init(string: newUrl),placeholderImage: kImageDefualtImage, completed: nil)
        
    }
    // MARK: -loadData
    func loadData(){
        SLEducationFEvaluationListTypeListRequest(stage: stage).requestCollection({ (list:[SLClassStarTypeModel]) in
            self.dataSource = list
            self.initUI()
        }) { (msg, code) in
            MBProgressHUD.sl_showMessage(message: msg, inView: self.view)
        }
    }
    // MARK: -action
    @objc func createClick(){
        if nameFieldLabel.contentField.text?.count == 0{
            MBProgressHUD.sl_showMessage(message: "请输入名称")
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        SLEducationFEvaluationListSaveOrUpdateRequest.init(id: itemModel?.id,classId: classId, category: index == 0 ? 10 : 20, evaluationItem: nameFieldLabel.contentField.text!, evaluationType: selectTypeModel.code ?? 0, score: buttonView.score, type: allSwitch.isSelect ? 30 : 20,stage: stage).request({ (item: SLClassStarCommentItemModel) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //新增item 插入到第一条
            let isUpdate =  self.itemModel == nil ? false : true
            for vc in self.navigationController!.viewControllers{
                if vc is SLClassStarCommentEditItemListController{
                    let listVc = vc as! SLClassStarCommentEditItemListController
                    listVc.updateItems(item: item, defultIndex: self.index, isUpdate: isUpdate)
                }
                if vc is SLClassStarTeacherPublishCommentController{
                    let publishVc = vc as! SLClassStarTeacherPublishCommentController
                    publishVc.updateItems(item: item, defultIndex: self.index, isUpdate: isUpdate)
                }
                if vc is SLClassStarSignleClassStudentDetialController{
                    let publishVc = vc as! SLClassStarSignleClassStudentDetialController
                    publishVc.updateItems(item: item, defultIndex: self.index, isUpdate: isUpdate)
                }
                
            }
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
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
        SLSolitaireSelectReasonView.init(items: titles, selectedIndex: selectIndex,title: "所属类型", inTarget: self.navigationController!.view) {[weak self] (view, selectIndex) in
            guard let strongSelf = self else { return }
            strongSelf.typeSection.rightLabel.text = strongSelf.dataSource[selectIndex].name
            strongSelf.typeSection.rightLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
            strongSelf.logoImageView.sd_setImage(with: URL.init(string: NSUtil.sl_urlAllowedCharacters(url:strongSelf.dataSource[selectIndex].iconUrl ?? "")) ,placeholderImage: kImageDefualtImage, completed: nil)
            for (index,model) in strongSelf.dataSource.enumerated(){
                if index == selectIndex{
                    model.isSelected = true
                }else{
                    model.isSelected = false
                }
            }
            view.cancelClick(sender: nil)
        }
        
    }
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView.init(image: kImageDefualtImage)
        logoImageView.cornerRadius = 35
        return logoImageView
    }()
    lazy var nameFieldLabel: HMRightTextFieldLabel = {
        let nameFieldLabel = HMRightTextFieldLabel()
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
        typeSection.sl_addLine(position: .bottom, rightMargin: 20)
        typeSection.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return typeSection
    }()
    
    lazy var allSwitch: SLPublishSwitchLabel = {
        let allSwitch = SLPublishSwitchLabel()
        allSwitch.titleLabel.text = "应用到我所有班级"
        allSwitch.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return allSwitch
    }()
    
    
    lazy var createButton: SLButton = {
        let btn = SLButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.cornerRadius = 24.5
        btn.setTitle("创建", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        btn.addShadow(ofColor: UIColor.sl_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
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
                let buttonView = viewWithTag(buttonTag + index) as! SLButton
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
        sl_addLine(position: .bottom, leftMargin: 15.5)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15.5)
            make.right.equalTo(60)
            make.centerY.equalTo(self)
        }
        let count = dataSource.count
        for index in 0..<count{
            let button = SLButton.init()
            button.setTitleColor(UIColor.white, for: .selected)
            button.setTitleColor(UIColor.sl_hexToAdecimalColor(hex: "#575A60"), for: .normal)
            button.setTitle("\(dataSource[index].score)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setBackgroundImage(UIImage.sl_image(with: kBlueColor), for: .selected)
            button.setBackgroundImage(UIImage.sl_image(with: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9")), for: .normal)
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
    
    @objc func buttonClick(_ button: SLButton){
        if button.isSelected{
            return
        }
        let count = dataSource.count
        for index in 0..<count{
            let buttonView = viewWithTag(buttonTag + index) as! SLButton
            buttonView.isSelected = false
            
            if buttonView == button{
                buttonView.isSelected = true
            }
            
            dataSource[index].isSelect = buttonView.isSelected
        }
    }
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "分值"
        return label
    }()
    
}
