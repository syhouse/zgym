//
//  SLCommonPublishController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLCommonPublishBaseController: SLBaseViewController{
    
    /// 发布model
    var publishModel = SLPublishModel()
    
    /// 提交完成后的block
    var complete: ((_ requestModel: HMRequestShareModel, _ shareModel: SLShareModel) -> ())?
    
    /// 保存文件夹位置
    var saveDirectory: String = ""
    
    /// 本地缓存文件类型
    var sourceDirectory: SLCacheDirectory = .HomeWork
    
    /// 班级列表
    var classDataSource: [SLClassModel]?
    
    /// 家长提交用来区分不同缓存文件名称使用
    var serviceId: Int?
    
    /// 保存的文件名称
    var fileName: String{
        get{
            return "\(saveDirectory)\(serviceId ?? 0)\(sl_user.id ?? 0)\(sl_user.curruntChild?.id ?? 0)\(sl_user.type ?? "")\(sl_user.stage ?? "")"
        }
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var isExitLocal: Bool{
        get{
            return NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_cachePath(file: fileName, directory: "archive")) as? SLPublishModel == nil ? false : true
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
    
    var rightButton: SLButton!
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initPublish()
        
        rightButton = SLButton(frame: CGRect(x: 0, y: 0, width: 58, height: 25))
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
        
        
        let backButton = sl_setNavLeftTitle(title: "取消")
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backButton.setMixedTitleColor( MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4) , forState: .normal)
        
        self.selectClassView.setViewModel(publishModel.classs)
        if SLPersonDataModel.sharePerson.personRole == .TEACHER && ((sl_user.gradeIds?.count ?? 1) == 1 || singlePublishClassId != nil){
            sl_loadTeachClassData()
        }
        
        scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
    }
    
    // MARK: - override
    
    /// 初始化 publishModel  如果有就从本地解档
    func initPublish(){
        if let publishModel = NSKeyedUnarchiver.unarchiveObject(withFile: NSUtil.sl_cachePath(file: fileName, directory: "archive")) as? SLPublishModel{
            self.publishModel = publishModel
        }else{
            self.publishModel = SLPublishModel()
            publishModel.sourceDirectory = sourceDirectory
        }
    }
    
    /// 请求提交信息数据  子类自己实现
    /// - Parameter mediaInfos: 资源数据
    func sl_loadCommintData(mediaInfos: [[String: Any]]?){}
    
    /// 请求班级信息成功
    func sl_loadClassDataSucess(){
        
    }
    
    /// 保存
    func save(){
        
    }
    
    func loadClassCountData(){
    }
    
    // MARK: -loadData
    func sl_loadTeachClassData(){
        var curruntClassId: Int = 0
        if let classId = singlePublishClassId{
            curruntClassId = classId
            
        }else{
            curruntClassId = sl_user.gradeIds?.first ?? 0
        }
        
        sl_loadPublishClassListData(isFriendSelectClass) { (classes) in
            var selectClasses = [SLClassModel]()
            for classModel in classes{
                if classModel.id == curruntClassId{
                    selectClasses.append(classModel)
                    break
                }
            }
            self.classDataSource = classes
            self.publishModel.classs = selectClasses
            self.selectClassView.setViewModel(self.publishModel.classs)
            self.sl_loadClassDataSucess()
        }
    }
    
    // MARK: -action
    override func sl_onBackClick() {
        self.view.endEditing(true)
        SLCommonAlertView.showAlert(title: "提示", message: "您确定退出吗？", leftTitle: "直接退出", leftTitleColor: UIColor.sl_hexToAdecimalColor(hex:"#797B7E"), leftClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            try? FileManager.default.removeItem(atPath: NSUtil.sl_cachePath(file: strongSelf.fileName, directory: "archive"))
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
        if !sl_cheackCanSetUp(){
            return
        }
        //音频  图片需要分开传 ？？ why
        var mediaInfos = [[String: Any]]()
        
        
        if publishModel.audioModels.count != 0{
            MBProgressHUD.sl_showLoading(inView: self.navigationController!.view)
            SLUploadSourceHelper().uploadAudios(mediaModels: publishModel.audioModels, sucess: { (urls) in
                for url in urls{
                    mediaInfos.append([typeKey: SourceNameType.voice,urlKey:url])
                }
                
                MBProgressHUD.sl_hideHUDInView(view: self.navigationController!.view)
                self.cheakLoadImageData(mediaInfos:mediaInfos)
            }) { (msg, code) in
                MBProgressHUD.sl_hideHUDInView(view: self.navigationController!.view)
                MBProgressHUD.sl_showMessage(message: msg)
            }
            
        }else{
            cheakLoadImageData(mediaInfos:mediaInfos)
        }
    }

    
    func sl_remove(){
        try? FileManager.default.removeItem(atPath: NSUtil.sl_cachePath(file: self.fileName, directory: "archive"))
    }
    
    @objc func cheakLoadImageData(mediaInfos medias: [[String: Any]]){
        var mediaInfos = medias
        var infos = [[String: Any]]()
        if publishModel.publishSource.contains(.video) {
            infos.append([typeKey: SourceNameType.video,modelKey: publishModel.medias.first!])
        }else{
            for model in publishModel.medias{
                infos.append([typeKey: SourceNameType.image,modelKey: model])
            }
        }
        if infos.count > 0{
            MBProgressHUD.sl_showLoading(message: "上传中", inView: self.navigationController!.view)
            SLUploadSourceHelper().uploadMedia(mediaInfos: infos, sucess: { (infos) in
                SLLog(infos)
                MBProgressHUD.sl_hideHUDInView(view: self.navigationController!.view)
                mediaInfos.append(contentsOf: infos)
                self.sl_loadCommintData(mediaInfos: mediaInfos)
            }) { (msg, code) in
                MBProgressHUD.sl_hideHUDInView(view: self.navigationController!.view)
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
        else{
            sl_loadCommintData(mediaInfos: mediaInfos)
        }
    }
    
    
    @objc func sl_selectClassClick(){
        let vc = SLSelectClassController.init(publishModel.classs,dataSource: self.classDataSource)
        vc.selectBlock = {[weak self](selectClasss: [SLClassModel]) in
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
    func sl_cheackCanSetUp() -> Bool{
        //主题不能为空
        let publishText: String = publishModel.publishText?.removeSpace() ?? ""
        if publishText.count == 0{
            sl_showAlert(title: "正文不能为空")
            return false
        }
        if publishModel.classs == nil && (SLPersonDataModel.sharePerson.personRole == .TEACHER || publishModel.isFriendCiclePublish){
            sl_showAlert(title: "接收班级不能为空")
            return false
        }
        return true
    }

    // MARK: - getter&setter
    
    lazy var selectClassView : SLSelectClassView = {
        let selectClassView = SLSelectClassView()
        selectClassView.addTaget(target: self, selctor: #selector(sl_selectClassClick))
        return selectClassView
    }()
    
    lazy var publishView: SLCommonPublishView = {
        let publishView = SLCommonPublishView.init(publishModel: publishModel, audioMaxCount: audioMaxCount)
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
