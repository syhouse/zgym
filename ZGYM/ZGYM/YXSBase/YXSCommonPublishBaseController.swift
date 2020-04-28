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
            return "\(saveDirectory)\(serviceId ?? 0)\(yxs_user.id ?? 0)\(yxs_user.curruntChild?.id ?? 0)\(yxs_user.type ?? "")\(yxs_user.stage ?? "")"
        }
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var isExitLocal: Bool{
        get{
            return NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.yxs_cachePath(file: fileName, directory: "archive")) as? YXSPublishModel == nil ? false : true
        }
    }
    
    /// 朋友圈选择班级
    var isFriendSelectClass: Bool = false
    
    /// 只能选择单个班级
    var isSelectSingleClass: Bool = false
    
    /// 最大选择音频数
    var audioMaxCount = 1
    
    /// 单个班级详情页发布
    var singlePublishClassId: Int?
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
        var curruntClassId: Int = 0
        if let classId = singlePublishClassId{
            curruntClassId = classId
            
        }else{
            curruntClassId = yxs_user.gradeIds?.first ?? 0
        }
        
        yxs_loadPublishClassListData(isFriendSelectClass) { (classes) in
            var selectClasses = [YXSClassModel]()
            for classModel in classes{
                if classModel.id == curruntClassId{
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
        
        //音频  图片需要分开传 ？？ why
        var mediaInfos = [[String: Any]]()
        //需要上传
        var localAudio = [SLAudioModel]()
        for model in publishModel.audioModels{
            if let servicePath = model.servicePath{
                mediaInfos.append([typeKey: SourceNameType.voice,urlKey: servicePath,modelKey: model])
            }else{
                localAudio.append(model)
            }
        }
        
        //本地图片视频资源
        var localMeidaInfos = [[String: Any]]()
        for model in publishModel.medias{
            if !model.isService{//本地资源 需要先上传获取url
                if model.type == .video{
                    localMeidaInfos.append([typeKey: SourceNameType.video,modelKey: model])
                }else{
                    localMeidaInfos.append([typeKey: SourceNameType.image,modelKey: model])
                }
            }else{//修改的服务器资源
                if model.type == .video{
                    mediaInfos.append([typeKey: SourceNameType.video,urlKey: model.serviceUrl ?? ""])
                    mediaInfos.append([typeKey: SourceNameType.firstVideo,urlKey: model.showImageUrl ?? ""])
                }else{
                    mediaInfos.append([typeKey: SourceNameType.image,urlKey: model.serviceUrl ?? ""])
                }
            }
        }
        //有本地资源上传
        if localAudio.count != 0 || localMeidaInfos.count != 0{
            self.uploadHud = getUploadHud()
            self.uploadHud.label.text = "上传中(0%)"
            uploadHud.show(animated: true)
        }
        
        if localAudio.count != 0{
            YXSUploadSourceHelper().uploadAudios(mediaModels: publishModel.audioModels, progress: {
                (progress)in
                DispatchQueue.main.async {
                    self.uploadHud.label.text = "上传中(\(String.init(format: "%d", Int(progress * 100 * CGFloat(localAudio.count)/CGFloat(localAudio.count + localMeidaInfos.count))))%)"
                }
            }, sucess: { (urls) in
                var i = 0
                for url in urls{
                    let model = self.publishModel.audioModels[i]
                    mediaInfos.append([typeKey: SourceNameType.voice,urlKey:url,modelKey: model])
                    i += 1
                }
                self.cheakLoadImageData(mediaInfos:mediaInfos,localMeidaInfos: localMeidaInfos, residueProgess: 1 - CGFloat(localAudio.count)/CGFloat(localAudio.count + localMeidaInfos.count))
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        }else{
            cheakLoadImageData(mediaInfos:mediaInfos,localMeidaInfos: localMeidaInfos, residueProgess: 1.0)
        }
    }
    
    
    func yxs_remove(){
        try? FileManager.default.removeItem(atPath: NSUtil.yxs_cachePath(file: self.fileName, directory: "archive"))
    }
    
    @objc func cheakLoadImageData(mediaInfos medias: [[String: Any]], localMeidaInfos: [[String: Any]], residueProgess: CGFloat){
        var mediaInfos = medias
        if localMeidaInfos.count > 0{
            YXSUploadSourceHelper().uploadMedia(mediaInfos: localMeidaInfos, progress: {
                (progress)in
                DispatchQueue.main.async {
                    self.uploadHud.label.text = "上传中(\(String.init(format: "%d", Int((residueProgess*progress + (1.0 - residueProgess)) * 100)))%)"
                }
            }, sucess: { (infos) in
                SLLog(infos)
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                mediaInfos.append(contentsOf: infos)
                self.yxs_loadCommintData(mediaInfos: mediaInfos)
            }) { (msg, code) in 
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        else{
            MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
            self.yxs_loadCommintData(mediaInfos: mediaInfos)
        }
    }
    
    
    @objc func yxs_selectClassClick(){
        let vc = YXSSelectClassController.init(publishModel.classs,dataSource: self.classDataSource)
        vc.selectBlock = {[weak self](selectClasss: [YXSClassModel]) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.classs = selectClasss
            strongSelf.selectClassView.setViewModel(selectClasss)
            strongSelf.loadClassCountData()
        }
        vc.isFriendSelectClass = isFriendSelectClass
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
    ///上传进度
    var uploadHud: MBProgressHUD!
    
    func getUploadHud() -> MBProgressHUD{
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        hud.mode = .indeterminate
        return hud
    }
}
