//
//  YXSClassStarEvaluationItemLogoViewController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit

import NightNight

class YXSClassStarEvaluationItemLogoViewController: YXSBaseCollectionViewController{
    
    /// 提交完成后的block
    var complete: ((_ imageUrl: String) -> ())?
    var currentIconUrl: String?{
        didSet{
            if let currentIconUrl = currentIconUrl{
                logoImageView.sd_setImage(with: URL.init(string: currentIconUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage:
                    kImageDefualtImage)
            }
            
        }
    }
    
    var items: [String] = [String]()
    
    var currentSelectIndex: Int?
    var classId: Int
    
    init(classId: Int) {
        self.classId = classId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rightButton: YXSButton!
    // MARK: -leftCicle
    
    override func viewDidLoad() {
        
        let layout = UICollectionViewFlowLayout()
        let space:CGFloat = (self.view.frame.size.width - CGFloat(68.0*4.0) - CGFloat(15.0*2.0))/3.0
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = 28
        layout.sectionInset = UIEdgeInsets.init(top: 30, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize.init(width: 68, height: 68)
        layout.scrollDirection = .vertical
        self.layout =  layout
        
        hasRefreshHeader = false
        
        super.viewDidLoad()
        
        rightButton = YXSButton(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        rightButton.setTitleColor(kBlueColor, for: .normal)
        rightButton.setTitle("保存", for: .normal)
        rightButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -20)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightButton)
        navigationItem.rightBarButtonItem = rightItem
        
        let backButton = yxs_setNavLeftTitle(title: "取消")
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        backButton.setMixedTitleColor( MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4) , forState: .normal)
        loadData()
        
        collectionView.register(YXSItemUrlCell.self, forCellWithReuseIdentifier: "YXSItemUrlCell")
        initUI()
    }
    
    func initUI(){
        view.addSubview(logoImageView)
        view.addSubview(customImageSection)
        view.addSubview(tipsLabel)
        
        logoImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.top.equalTo(41)
            make.centerX.equalTo(view)
        }
        customImageSection.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(logoImageView.snp_bottom).offset(49)
            make.height.equalTo(64)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(customImageSection.snp_bottom).offset(28.5)
        }
        collectionView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
            make.top.equalTo(tipsLabel.snp_bottom)
        }
    }
    
    // MARK: - loadData
    func loadData(){
        YXSEducationClassStarEvaluationListListImageRequest().request({ (result) in
            self.items = result.arrayObject as? [String] ?? [String]()
            self.currentIconUrl = self.items.first
            self.currentSelectIndex = 0
            self.collectionView.reloadData()
            self.tipsLabel.text = "系统图标（\(self.items.count)）"
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    override func yxs_onBackClick() {
        self.navigationController?.popViewController()
    }
    
    @objc func rightClick(){
        if let currentIconUrl = currentIconUrl{
            complete?(currentIconUrl)
            self.navigationController?.popViewController()
        }else{
            MBProgressHUD.yxs_showMessage(message: "请选择点评图标")
        }
    }
    
    @objc func selectCustomIcon(){
        //        YXSSelectMediaHelper.shareHelper.showSelectMedia(selectImage: true, selectVedio: false, selectAll: false, customVideo: false, maxCount: 1, customVideoFinish: nil)
        YXSSelectMediaHelper.shareHelper.pushImageAllCropPickerController()
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    // MARK: - UICol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentSelectIndex == indexPath.row{
            return
        }
        currentSelectIndex = indexPath.row
        collectionView.reloadData()
        currentIconUrl = items[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSItemUrlCell", for: indexPath) as! YXSItemUrlCell
        cell.isItemSelect = currentSelectIndex == indexPath.row
        cell.imageUrl = items[indexPath.row]
        return cell
    }
    
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView.init(image: kImageDefualtImage)
        logoImageView.cornerRadius = 35
        logoImageView.image = kImageDefualtImage
        return logoImageView
    }()
    
    lazy var customImageSection: SLTipsRightLabelSection = {
        let customImageSection = SLTipsRightLabelSection()
        customImageSection.leftlabel.text = "自定义点评图标"
        customImageSection.addTarget(self, action: #selector(selectCustomIcon), for: .touchUpInside)
        customImageSection.yxs_addLine(position: .bottom, rightMargin: 20)
        customImageSection.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        return customImageSection
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = kTextMainBodyColor
        label.text = "系统图标（0）"
        return label
    }()
}

extension YXSClassStarEvaluationItemLogoViewController: YXSSelectMediaHelperDelegate{
    func didSelectImages(images: [UIImage]) {
        if let image = images.first{
            if let data = YXSCompressionImageHelper.yxs_compressImage(image: image, maxLength: imageMax){
                MBProgressHUD.yxs_showLoading()
                YXSUploadDataHepler.shareHelper.uploadData(uploadModel: SLUploadDataSourceModel.init(data: data, path: YXSFileUploadHelper.sharedInstance.getStarUrl(fullName: Date().toString().MD5() + ".jpg", classId: classId), type: .image, fileName: Date().toString().MD5()), sucess: { (url) in
                    self.currentIconUrl = url
                    self.currentSelectIndex = nil
                    self.collectionView.reloadData()
                    self.logoImageView.image = image
                    MBProgressHUD.yxs_hideHUD()
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
        }
    }
}

class YXSItemUrlCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(borderView)
        contentView.addSubview(imageView)
        borderView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.width.height.equalTo(68)
        }
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.width.height.equalTo(64)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var isItemSelect:Bool = false {
        didSet{
            borderView.borderColor = isItemSelect ? kBlueColor : UIColor.white
        }
    }
    
    var imageUrl: String = ""{
        didSet{
            imageView.sd_setImage(with: URL.init(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: kImageDefualtImage)
        }
    }
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: kImageDefualtImage)
        imageView.cornerRadius = 32
        imageView.image = kImageDefualtImage
        return imageView
    }()
    
    lazy var borderView: UIView = {
        let borderView = UIView()
        borderView.cornerRadius = 34
        borderView.backgroundColor = UIColor.white
        borderView.borderWidth = 1
        borderView.borderColor = UIColor.white
        return borderView
    }()
}
