//
//  YXSComplaintDetailViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/2/24.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import YBImageBrowser
import TZImagePickerController

class YXSComplaintDetailViewController: YXSBaseViewController {

    private var respondentId: Int!
    private var respondentType: String!
    private var type: String!
    
    private var screenshots: String?
    
    init(respondentId:Int, respondentType:String, type:String) {
        super.init()
        self.respondentId = respondentId
        self.respondentType = respondentType
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户投诉"
        // Do any additional setup after loading the view.
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(contentView)
        
        contentView.addSubview(firstView)
        contentView.addSubview(secondView)
        contentView.addSubview(btnDone)
        
        yxs_layout()
    }
    
    func yxs_layout() {
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }

        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        firstView.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.height.equalTo(186*SCREEN_SCALE)
        })
        
        secondView.snp.makeConstraints({ (make) in
            make.top.equalTo(firstView.snp_bottom).offset(10)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.height.equalTo(176*SCREEN_SCALE)
        })
        
        btnDone.snp.makeConstraints({ (make) in
            make.top.equalTo(secondView.snp_bottom).offset(32)
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
            make.bottom.equalTo(0)
        })
    }
    
    // MARK: - Request
    @objc func uploadImagesRequest(completionHandler:((_ result:String)->())?) {
        var infos = [[String: Any]]()
        if var medias = secondView.publishModel.medias {
            for model in medias{
                infos.append([typeKey: SourceNameType.image,modelKey: model])
            }
        }

        if infos.count > 0{
            MBProgressHUD.yxs_showLoading(message: "上传中", inView: self.navigationController!.view)
            YXSUploadSourceHelper().uploadMedia(mediaInfos: infos, sucess: { [weak self](list) in
                guard let weakSelf = self else {return}
                SLLog(infos)
                MBProgressHUD.yxs_hideHUDInView(view: weakSelf.navigationController!.view)
                var result = weakSelf.processMedia(list: list)
                completionHandler?(result)
                
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUDInView(view: self.navigationController!.view)
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }else{
            completionHandler?("")
        }
    }
    
    @objc func processMedia(list:[[String: Any]]?)->String {
        var pictures = [String]()
        
        if let mediaInfos = list{
            for model in mediaInfos{
                if let type = model[typeKey] as? SourceNameType{
                    if type == .video{
//                        video = model[urlKey] as? String ?? ""
                    }else if type == .image{
                        pictures.append(model[urlKey] as? String ?? "")
                    }else if type == .voice{
//                        audioUrl = model[urlKey] as? String ?? ""
                    }else if type == .firstVideo{
//                        bgUrl = model[urlKey] as? String ?? ""
                    }
                }
            }
        }
        return pictures.joined(separator: ",")
    }
    
    // MARK: - Action
    @objc func doneClick(sender: YXSButton) {
        self.view.endEditing(true)
        
        if self.firstView.textView.text.count < 1 {
            MBProgressHUD.yxs_showMessage(message: "描述内容不能为空")
            return
        }
        
        uploadImagesRequest { [weak self](screenshots) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showLoading()
            YXSEducationComplaintSubmitRequest(respondentId: weakSelf.respondentId, respondentType: weakSelf.respondentType, type: weakSelf.type, content: weakSelf.firstView.textView.text ?? "", screenshots: screenshots).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "提交成功")
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    weakSelf.navigationController?.yxs_existViewController(existClass: SLFriendsCircleInfoController(userId: 0, childId: 0, type: ""), complete: { (isContain, resultVC) in
                        weakSelf.navigationController?.popToViewController(resultVC, animated: true)
                    })
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        
    }
    
    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.mixedBackgroundColor = MixedColor(normal: 0xF2F5F9, night: 0x181A23)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var firstView: SLComplaintInputView = {
        let view = SLComplaintInputView()
        return view
    }()
    
    lazy var secondView: SLComplaintImagesView = {
        let view = SLComplaintImagesView()
        return view
    }()
    
    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.gray, cornerRadius: 24, offset: CGSize(width: 4, height: 4))
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return btn
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: -
class SLComplaintInputView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        
        self.addSubview(lbTitle)
        self.addSubview(textView)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(18)
            make.left.equalTo(15)
        })
        
        textView.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(13)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-18)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "对违规行为描述："
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        return lb
    }()
    
    lazy var textView: YXSPlaceholderTextView = {
        let tv = YXSPlaceholderTextView()
        tv.limitCount = 200
        tv.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNight2C3144)
        tv.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: -17, right: 17)
        tv.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)
        tv.placeholderColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        tv.placeholder = "请输入您想说的..."
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
}


// MARK: -
class SLComplaintImagesView: UIView,YXSSelectMediaHelperDelegate {
    /// 是添加图片点击
    private let maxcount = 3
    private var isShowMedia: Bool = false
    private var isAdd: Bool = false
    var publishModel: YXSPublishModel = YXSPublishModel()
    /// 是否已选择发布视频
    private var isVedio: Bool{
        var isVedio = false
        for media in publishModel.medias{
            if media.type == PHAssetMediaType.video{
                isVedio = true
                break
            }
        }
        return isVedio
    }
    /// 用来预览展示选择
    private var assets: [TZAssetModel] {
        get{
            var assets = [TZAssetModel]()
            for media in publishModel.medias{
                if let tzModel: TZAssetModel = TZAssetModel.init(asset: media.asset, type: TZAssetModelMediaTypePhoto){
                    assets.append(tzModel)
                }
            }
            return assets
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        
        //初始化媒体库
        if publishModel.medias == nil{
            publishModel.medias = [SLPublishMediaModel]()
        }
        
        self.addSubview(lbTitle)
        self.addSubview(listView)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(18)
            make.left.equalTo(15)
        })
        
        listView.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(13)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-18)
        })
        
        listView.addItem(getItem(nil, isAdd: true))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    func showSelectMedia(_ isAdd: Bool){
        let count = maxcount - assets.count

        if isAdd{
            YXSSelectMediaHelper.shareHelper.pushImagePickerController(mediaStyle: .onlyImage,maxCount: 3)
        }else{
            YXSSelectMediaHelper.shareHelper.pushImagePickerController(assets,mediaStyle: .onlyImage,maxCount: maxcount)
        }

        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    // MARK: - ImagePicker
    /// 拍照完成/选中视频
    /// - Parameter asset: model
    func didSelectMedia(asset: YXSMediaModel) {
        if !isAdd{
            listView.removeAll()
        }
        
        listView.addItem(getItem(asset))
        changeModel()
        updateUI()
    }
    
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        if !isAdd{
            listView.removeAll()
        }
        
        for media in assets{
            listView.addItem(getItem(media))
        }
        changeModel()
        updateUI()
    }
    
    // MARK: - Other
    func getItem(_ model: YXSMediaModel? = nil, isAdd: Bool = false) -> SLFriendDragItem{
        var publishMedia = SLPublishMediaModel()
        publishMedia.asset = model?.asset
        
        let item = SLFriendDragItem.init(frame: CGRect.zero)
        item.contentMode = .scaleAspectFill
        item.clipsToBounds = true
        if isAdd{
            item.isAdd = isAdd
        }else{
            item.model = publishMedia
        }
        item.itemRemoveBlock =  {
            [weak self](model: SLPublishMediaModel) in
            guard let strongSelf = self else { return }
            strongSelf.publishModel.medias.remove(at:  strongSelf.publishModel.medias.firstIndex(of: model) ?? 0)
            
            for item in strongSelf.listView.itemArray(){
                if item.model == model{
                    strongSelf.listView.delete(item)
                    break
                }
            }
            strongSelf.updateUI()
        }
        return item
    }
    
    /// 刷新数据model
    func changeModel(){
        publishModel.medias.removeAll()
        for item in listView.itemArray(){
            if !item.isAdd{
                publishModel.medias.append(item.model!)
            }
        }
    }
    
    func updateUI(){
        if publishModel.medias.count < listView.maxItem {
            for sub in listView.itemArray() {
                if sub.isAdd {
                    return
                }
            }
            listView.addItem(getItem(nil, isAdd: true))
        }
//        if isShowMedia{
//            //图片 音频绑定
//            if publishModel.audioModel != nil {
//                self.publishModel.publishSource = .image
//            }
//
//            if isVedio {
//                self.publishModel.publishSource = .vedio
//            }else if publishModel.medias.count != 0 {
//                self.publishModel.publishSource = .image
//            }
//
//            if assets.count == maxcount{
//                publishModel.publishSource = .imageMax
//            }
//
//            if publishModel.audioModel == nil && assets.count == 0{
//                publishModel.publishSource = .none
//            }
//        }else{
//            listView.isHidden = true
//        }
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "违规截图："
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: kNightFFFFFF)
        return lb
    }()
    
    lazy var listView:SLFriendDragListView = {
        let listView = SLFriendDragListView.init(frame: CGRect.init(x: 0, y: 170, width: SCREEN_WIDTH - 30, height: 0))
        listView.scaleItemInSort = 1.3
        listView.isSort = false
        listView.maxItem = 3
        listView.isFitItemListH = true
        listView.clickItemBlock = {[weak self](item) in
            guard let strongSelf = self else { return }
            strongSelf.isAdd = false
//            if !strongSelf.isVedio{
                strongSelf.showSelectMedia(false)
//            }else{
//                let browser = YBImageBrowser()
//                let vedioData = YBIBVideoData()
//                vedioData.videoPHAsset = item.model?.asset
//                vedioData.autoPlayCount = 1
//                browser.dataSourceArray.append(vedioData)
//                browser.show()
//            }
        }
        return listView
    }()
}
