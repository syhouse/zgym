//
//  YXSEditAlbumBaseController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/6.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSEditAlbumBaseController: YXSBaseViewController {
    var changeAlbumBlock: (() -> ())?
    var classId: Int
    init(classId: Int) {
        self.classId = classId
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        title = "新建相册"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.greetingTextFieldChanged),
                                               name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
                                               object: self.nameField)
        
        initUI()
    }
    
    func initUI(){
        self.view.addSubview(nameField)
        nameField.yxs_addLine(position: .bottom, color: kLineColor)
        self.view.addSubview(photoSection)
        
        nameField.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(10)
            make.height.equalTo(49)
        }
        
        photoSection.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(nameField.snp_bottom)
            make.height.equalTo(49)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, length: 10)
    }
    
    // MARK: -loadData
    
    /// 上传照片完成请求
    func loadUploadFinishData(){
        MBProgressHUD.yxs_showLoading(inView: self.view)
        YXSEducationAlbumCreateRequest.init(classId: classId, albumName: nameField.text!, coverUrl: coverUrl).request({ (json) in
            MBProgressHUD.yxs_hideHUDInView(view: self.view)
            MBProgressHUD.yxs_showMessage(message: "创建成功")
            self.changeAlbumBlock?()
            self.navigationController?.popViewController()
        }) { (msg, code) in
            MBProgressHUD.yxs_hideHUDInView(view: self.view)
            self.view.makeToast("\(msg)")
        }
    }
    
    /// 上传照片请求
    func loadUploadImageData(){
        MBProgressHUD.yxs_showLoading(inView: self.view)
        if selectMediaModel != nil{
            YXSUploadSourceHelper().uploadImage(mediaModel: selectMediaModel, storageType: .album, classId: classId, albumId: 0, sucess: { (successUrl) in
                self.coverUrl = successUrl
                MBProgressHUD.yxs_hideHUDInView(view: self.view)
                self.loadUploadFinishData()
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        else{
            self.loadUploadFinishData()
        }
    }
    
    var coverUrl: String?
    var selectMediaModel :YXSMediaModel!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.photoSection.setImages(images: [self.selectMediaModel.thumbnailImage])
            }
        }
    }
    
    @objc func selectCover(){
        YXSSelectMediaHelper.shareHelper.showSelectMedia(selectImage: true)
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    lazy var nameField: YXSQSTextField = {
        let nameFiled = UIUtil.yxs_getTextField(UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0), placeholder: "添加相册名称（7个字以内）", placeholderColor: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), mixedTextColor:MixedColor(normal: kTextMainBodyColor, night: UIColor.white))
        nameFiled.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        //        classField.addTarget(self, action: #selector(classChange), for: .editingChanged)
        return nameFiled
    }()
    
    lazy var photoSection: FriendCircleImagesView = {
        let section = FriendCircleImagesView()
        section.leftlabel.text = "相册封面"
        section.imageWidth = 34
        section.setImages(images: [UIImage.init(named: "yxs_photo_nocover")])
        section.addTarget(self, action: #selector(selectCover), for: .touchUpInside)
        return section
    }()
    
}

extension YXSEditAlbumBaseController: YXSSelectMediaHelperDelegate{
    func didSelectMedia(asset: YXSMediaModel) {
        self.selectMediaModel = asset
    }
    
    /// 选中多个图片资源
    /// - Parameter assets: models
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        self.selectMediaModel = assets.first ?? YXSMediaModel()
    }
}
