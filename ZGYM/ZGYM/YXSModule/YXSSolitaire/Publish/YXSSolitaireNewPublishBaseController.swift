//
//  YXSSolitaireNewPublishBaseController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
import IQKeyboardManager


class YXSSolitaireNewPublishBaseController: YXSCommonPublishBaseController {
    // MARK: -leftCycle
    
    var classId: Int? {
        return publishModel.classs?.first?.id
    }

    init(){
        super.init(nil)
        saveDirectory = "Solitaire"
        sourceDirectory = .solitaire
        isSelectSingleClass = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "接龙"
        self.publishType = .solitaire
        
        setTeacherUI()
        
        if classId != nil{
            loadClassCountData()
        }
        
        scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 45
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 0
    }
    
    // MARK: -UI
    func setTeacherUI(){
        view.addSubview(scrollView)
        view.addSubview(footerSettingView)
        footerSettingView.snp.makeConstraints { (make) in
            make.height.equalTo(60 + kSafeBottomHeight)
            make.bottom.left.right.equalTo(0)
        }
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(-60 - kSafeBottomHeight)
        }
        // 添加容器视图
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view) // 确定的宽度，因为垂直滚动
        }
        contentView.addSubview(publishView)
        contentView.addSubview(selectClassView)
        
        let lineView = UIView()
        lineView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        selectClassView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        let lineView1 = UIView()
        lineView1.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "F2F5F9"), night: kNightBackgroundColor)
        contentView.addSubview(lineView1)
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(selectClassView.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        publishView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(selectClassView.snp_bottom).offset(10)
            make.bottom.equalTo(0)
        }
        publishView.yxs_addLine()

    }
    
    // MARK: -loadData
    override func yxs_loadClassDataSucess(){
        loadClassCountData()
    }
    /// 请求班级人数
    override func loadClassCountData(){
        YXSEducationGradeFindNumberOfStudentsRequest.init(gradeId: classId ?? 0).request({ (result) in
            self.publishModel.totalCommitUpperLimit = result.intValue
        }) { (msg, code) in
        }
    }
    
    // MARK: -action
    
    override func yxs_loadCommintData(mediaInfos: [[String: Any]]?){
        var classIdList = [Int]()
        var picture: String = ""
        var video: String = ""
        var audioUrl: String = ""
        var pictures = [String]()
        var bgUrl: String = ""
        var options = [String]()
        
        if let classs = publishModel.classs{
            for model in classs{
                classIdList.append(model.id ?? 0)
            }
        }
        
        for model in selectView.selectModels{
            options.append(model.title ?? "")
        }
        
        if let mediaInfos = mediaInfos{
            for model in mediaInfos{
                if let type = model[typeKey] as? SourceNameType{
                    if type == .video{
                        video = model[urlKey] as? String ?? ""
                    }else if type == .image{
                        pictures.append(model[urlKey] as? String ?? "")
                    }else if type == .voice{
                        audioUrl = model[urlKey] as? String ?? ""
                    }else if type == .firstVideo{
                        bgUrl = model[urlKey] as? String ?? ""
                    }
                }
            }
            
        }
        if pictures.count > 0{
            picture = pictures.joined(separator: ",")
        }
        MBProgressHUD.yxs_showLoading(message: "发布中", inView: self.navigationController?.view)
        YXSEducationCensusTeacherPublishRequest.init(classIdList: classIdList, content: publishView.getTextContent(), audioUrl: audioUrl, audioDuration: publishModel.audioModels.first?.time ?? 0, videoUrl: video, bgUrl: bgUrl, imageUrl: picture, link: publishModel.publishLink ?? "",commitUpperLimit: publishModel.commitUpperLimit ?? 0, optionList: options, endTime: publishModel.solitaireDate!.toString(format: DateFormatType.custom("yyyy-MM-dd HH:mm:ss")), isTop: publishModel.isTop ? 1 : 0).request({ (result) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: "发布成功", inView: self.navigationController?.view)
            self.yxs_remove()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherPublishSucessNotification), object: nil)
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    // MARK: -pivate
    override func yxs_cheackCanSetUp() -> Bool {
        if publishModel.solitaireDate == nil {
            yxs_showAlert(title: "请选择截止日期")
            return false
        }
        if self.publishModel.commitUpperLimit == nil{
            yxs_showAlert(title: "请选择最高接龙人数")
            return false
        }
        return super.yxs_cheackCanSetUp()
    }
    
    
    override func save(){
        NSKeyedArchiver.archiveRootObject(publishModel, toFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive"))
    }
    
    // MARK: - private
    func showSettingTool(){
        YXSSolitaireToolWindow.showToolWindow(publishModel: publishModel)
    }
    
    // MARK: - getter&setter
    
    lazy var footerSettingView: YXSSolitaireSettingBar = {
        let footerSettingView = YXSSolitaireSettingBar()
        footerSettingView.settingClickBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showSettingTool()
        }
        return footerSettingView
    }()
    
    lazy var selectView: SolitairePublishSelectView = {
        let selectView = SolitairePublishSelectView(selectModels: publishModel.solitaireSelects)
        return selectView
    }()
}

class YXSSolitaireApplyPublishController: YXSSolitaireNewPublishBaseController {
    override init(){
        super.init()
        saveDirectory = "Solitaire_apply"
        sourceDirectory = .solitaire
        isSelectSingleClass = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "报名接龙"
    }

    
    // MARK: -UI
    
    
    // MARK: -loadData
    override func yxs_loadClassDataSucess(){
        loadClassCountData()
    }
}

