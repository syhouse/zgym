//
//  SLCommonPublishController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSCommonPublishBaseController: YXSBaseViewController{
    
    /// 发布model
    var publishModel = YXSPublishModel()
    
    /// 提交完成后的block
    var complete: ((_ requestModel: HMRequestShareModel, _ shareModel: YXSShareModel) -> ())?
    
    
    /// 保存文件夹位置
    var saveDirectory: String = ""
    
    /// 本地缓存文件类型
    var sourceDirectory: YXSCacheDirectory = .HomeWork
    
    var publishType: YXSHomeType = .homework
    /// 班级列表
    var classDataSource: [YXSClassModel]?
    
    /// 家长提交用来区分不同缓存文件名称使用
    var serviceId: Int?
    
    /// 保存的文件名称
    var fileName: String{
        get{
            return "\(saveDirectory)\(serviceId ?? 0)\(yxs_user.id ?? 0)\(yxs_user.currentChild?.id ?? 0)\(yxs_user.type ?? "")\(yxs_user.stage ?? "")"
        }
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var isExitLocal: Bool{
        get{
            return NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? YXSPublishModel == nil ? false : true
        }
    }
    
    /// 朋友圈发布
    var isFriendCircle: Bool = false
    
    /// 只能选择单个班级
    var isSelectSingleClass: Bool = false
    
    /// 最大选择音频数
    var audioMaxCount = 1
    
    /// 单个班级详情页发布
    var singlePublishClassId: Int?
    
    ///模版列表
    var templateLists = [YXSTemplateListModel]()
    
    init(_ serviceId: Int?) {
        self.serviceId = serviceId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rightButton: YXSButton!
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_interactivePopDisabled = true
        
        initPublish()
        
        rightButton = YXSButton(frame: CGRect(x: 0, y: 0, width: 58, height: 25))
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitle("发布", for: .normal)
        rightButton.cornerRadius = 12.5
        rightButton.backgroundColor = kBlueColor
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        rightButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        let rightItem = UIBarButtonItem.init(customView: rightButton)
        navigationItem.rightBarButtonItem = rightItem
        
        
        let backButton = yxs_setNavLeftTitle(title: "取消")
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backButton.setMixedTitleColor( MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4) , forState: .normal)
        
        self.selectClassView.setViewModel(publishModel.classs)
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER && ((yxs_user.gradeIds?.count ?? 1) == 1 || singlePublishClassId != nil){
            yxs_loadTeachClassData()
        }
        
        scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
    }
    
    // MARK: - override
    
    /// 初始化 publishModel  如果有就从本地解档
    func initPublish(){
        if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? YXSPublishModel{
            self.publishModel = publishModel
        }else{
            initEmptyModel()
        }
    }
    
    
    /// 子类可继承自己配置未保存model的参数
    func initEmptyModel(){
        self.publishModel = YXSPublishModel()
        publishModel.sourceDirectory = sourceDirectory
    }
    
    /// 请求提交信息数据  子类自己实现
    /// - Parameter mediaInfos: 资源数据
    func yxs_loadCommintData(mediaInfos: [[String: Any]]?){}
    
    /// 请求班级信息成功
    func yxs_loadClassDataSucess(){
        
    }
    
    /// 保存
    func save(){
        
    }
    
    func loadClassCountData(){
    }
    
    // MARK: -loadData
    func yxs_loadTeachClassData(){
        var currentClassId: Int = 0
        if let classId = singlePublishClassId{
            currentClassId = classId
            
        }else{
            currentClassId = yxs_user.gradeIds?.first ?? 0
        }
        
        yxs_loadPublishClassListData(isFriendCircle) { (classes) in
            var selectClasses = [YXSClassModel]()
            for classModel in classes{
                if classModel.id == currentClassId{
                    selectClasses.append(classModel)
                    break
                }
            }
            self.classDataSource = classes
            self.publishModel.classs = selectClasses
            self.selectClassView.setViewModel(self.publishModel.classs)
            self.yxs_loadClassDataSucess()
        }
    }
    
    // MARK: -action
    override func yxs_onBackClick() {
        self.view.endEditing(true)
        YXSCommonAlertView.showAlert(title: "提示", message: "您确定退出吗？", leftTitle: "直接退出", leftTitleColor: UIColor.yxs_hexToAdecimalColor(hex:"#797B7E"), leftClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            try? FileManager.default.removeItem(atPath: NSUtil.yxs_cachePath(file: strongSelf.fileName, directory: "archive"))
            strongSelf.navigationController?.popViewController()
            }, rightTitle: "保存后退出", rightClick: {
                [weak self] in
                guard let strongSelf = self else { return }
                //do  save
                strongSelf.save()
                strongSelf.navigationController?.popViewController()
        })
    }
    
    @objc func rightClick(){
        self.view.endEditing(true)
        
        if !yxs_cheackCanSetUp(){
            return
        }
        
        var commintMediaInfos = [[String: Any]]()
        //需要上传
        var localMedias = [SLUploadSourceModel]()

        for model in publishModel.audioModels{
            if let servicePath = model.servicePath{
                commintMediaInfos.append([typeKey: SourceNameType.voice,urlKey: servicePath,modelKey: model])
            }else{
                localMedias.append(SLUploadSourceModel.init(model: model, type: .voice, storageType: isFriendCircle ? YXSStorageType.circle : .temporary, fileName: model.fileName ?? ""))
            }
        }
        
        for model in publishModel.medias{
            if !model.isService{//本地资源 需要先上传获取url
                if model.type == .video{
                   localMedias.append(SLUploadSourceModel.init(model: model, type: .video, storageType: isFriendCircle ? YXSStorageType.circle : .temporary, fileName: model.fileName))
                }else{
                    localMedias.append(SLUploadSourceModel.init(model: model, type: .image, storageType: isFriendCircle ? YXSStorageType.circle : .temporary, fileName: model.fileName))
                }
            }else{//修改的服务器资源
                if model.type == .video{
                    commintMediaInfos.append([typeKey: SourceNameType.video,urlKey: model.serviceUrl ?? ""])
                    
                    commintMediaInfos.append([typeKey: SourceNameType.firstVideo,urlKey: model.showImageUrl ?? ""])
                }else{
                    commintMediaInfos.append([typeKey: SourceNameType.image,urlKey: model.serviceUrl ?? ""])
                }
            }
        }
        //有本地资源上传
        if localMedias.count != 0{
            MBProgressHUD.yxs_showUpload(inView: self.navigationController!.view)
        }
        

        YXSUploadSourceHelper().uploadMedia(mediaInfos: localMedias, progress: {
            (progress)in
            DispatchQueue.main.async {
                 MBProgressHUD.yxs_updateUploadProgess(progess: progress, inView: self.navigationController!.view)
            }
        }, sucess: { (listModels) in
            SLLog(listModels)
            MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
            for model in listModels{
                commintMediaInfos.append([typeKey: model.type,urlKey: model.aliYunUploadBackUrl ?? ""])
            }
            
            self.yxs_loadCommintData(mediaInfos: commintMediaInfos)
        }) { (msg, code) in
            MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    
    func yxs_remove(){
        try? FileManager.default.removeItem(atPath: NSUtil.yxs_cachePath(file: self.fileName, directory: "archive"))
    }
    
    @objc func yxs_selectClassClick(){
        let vc = YXSSelectClassController.init(publishModel.classs,dataSource: self.classDataSource)
        vc.selectBlock = {[weak self](selectClasss: [YXSClassModel]) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.classs = selectClasss
            strongSelf.selectClassView.setViewModel(selectClasss)
            strongSelf.loadClassCountData()
        }
        vc.isFriendSelectClass = isFriendCircle
        vc.isSelectSingleClass = isSelectSingleClass
        navigationController?.pushViewController(vc)
    }
    
    // MARK: -tool
    func yxs_cheackCanSetUp() -> Bool{
        //主题不能为空
        let publishText: String = publishModel.publishText?.removeSpace() ?? ""
        if publishText.count == 0{
            yxs_showAlert(title: "正文不能为空")
            return false
        }
        if publishModel.classs == nil && (YXSPersonDataModel.sharePerson.personRole == .TEACHER || publishModel.isFriendCiclePublish){
            yxs_showAlert(title: "接收班级不能为空")
            return false
        }
        return true
    }
    
    // MARK: - getter&setter
    
    lazy var selectClassView : YXSSelectClassView = {
        let selectClassView = YXSSelectClassView()
        selectClassView.addTaget(target: self, selctor: #selector(yxs_selectClassClick))
        return selectClassView
    }()
    
    lazy var publishView: YXSCommonPublishView = {
        let publishView = YXSCommonPublishView.init(publishModel: publishModel, audioMaxCount: audioMaxCount,type: self.publishType)
        publishView.updateContentOffSet = {
            [weak self](offsetY) in
            guard let strongSelf = self else { return }
            var offset = strongSelf.scrollView.contentOffset
            offset.y += offsetY
            strongSelf.scrollView.contentOffset = offset
        }
        return publishView
    }()
}
