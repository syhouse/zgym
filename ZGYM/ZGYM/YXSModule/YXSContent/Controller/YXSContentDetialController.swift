//
//  YXSContentDetialController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit


import UIKit
import NightNight

class YXSContentDetialController: YXSBaseTableViewController {
    // MARK: - property
    ///专辑id
    let id: Int
    var albumsModel: YXSAlbumsBrowseModel?{
        didSet{
            if let track = albumsModel?.tracks{
                listSource = track
            }
        }
    }
    var listSource: [YXSTrackModel] = [YXSTrackModel]()
    // MARK: - init
    init(id: Int) {
        self.id = id
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var title: String?{
        didSet{
            customNav.title = title
        }
    }
    // MARK: - leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customNav)
        customNav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        self.fd_prefersNavigationBarHidden = true
        
        tableView.register(YXSContentDetialCell.self, forCellReuseIdentifier: "YXSContentDetialCell")
        tableView.yxs_addRoundedCorners(corners: [UIRectCorner.topLeft,.topRight], radii: CGSize.init(width: 15, height: 15), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.rowHeight = 62.5
        
        loadData()
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    
    func loadData(){
        YXSEducationXMLYAlbumsBrowseDetialRequest.init(album_id: id).request({ (result: YXSAlbumsBrowseModel) in
            self.albumsModel = result
            self.customNav.title = result.albumTitle
            self.yxs_tableHeaderView.yxs_setHeaderModel(result)
            self.yxs_tableHeaderView.layoutIfNeeded()
            let height = self.yxs_tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.yxs_tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height > (241 + kSafeTopHeight) ? height : 241 + kSafeTopHeight )
            self.tableView.tableHeaderView = self.yxs_tableHeaderView
            self.tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#745683"), night: UIColor.yxs_hexToAdecimalColor(hex: "#745683"))
            self.tableView.reloadData()
        }) { (msg, code) in
            
        }
    }
    ///当前是否收藏专辑
    var isCollection: Bool = false
    ///请求是否收藏接口
    func loadIsCollectionData(){
        rightButton.isSelected = isCollection
    }
    
    /// 收藏 取消收藏
    @objc func loadCollectionData(){
        
    }
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSContentDetialCell") as! YXSContentDetialCell
        cell.yxs_setCellModel(model, row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curruntTrack = listSource[indexPath.row]
        let vc = YXSPlayingViewController()
        let track = XMTrack.init(dictionary: curruntTrack.toJSON())
        vc.track = track
        var trackList = [XMTrack]()
        for model in listSource{
            trackList.append(XMTrack.init(dictionary: model.toJSON()))
        }
        vc.trackList = trackList
        navigationController?.pushViewController(vc)

//
//        let curruntTrack = listSource[indexPath.row]
//        let playerVc = PlayingViewController()
//        let track = XMTrack.init(dictionary: curruntTrack.toJSON())
//        playerVc.track = track
//        var trackList = [XMTrack]()
//        for model in listSource{
//            trackList.append(XMTrack.init(dictionary: model.toJSON()))
//        }
//        playerVc.trackList = trackList
//        self.navigationController?.pushViewController(playerVc)
    }
    
    
    // MARK: - getter&setter
    lazy var yxs_tableHeaderView: YXSContentDetialHeaderView = {
        let tableHeaderView = YXSContentDetialHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 241 + kSafeTopHeight))
        return tableHeaderView
    }()
    var rightButton: UIButton!
    lazy var customNav: YXSCustomNav = {
        let customNav = YXSCustomNav.init(.backAndTitle)
        customNav.backImageButton.setMixedImage(MixedImage(normal: "yxs_back_white", night: "yxs_back_white"), forState: .normal)
        customNav.titleLabel.textColor = UIColor.white
        
        rightButton = UIButton()
        rightButton.addTarget(self, action: #selector(loadCollectionData), for: .touchUpInside)
        rightButton.setImage(UIImage(named: "yxs_xmly_no_fav"), for: .normal)
        rightButton.setImage(UIImage(named: "yxs_xmly_has_fav"), for: .selected)
        customNav.addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8.5)
            make.centerY.equalTo(customNav.backImageButton)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
        }
        return customNav
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 241 - 64 + kSafeTopHeight {//64 + kSafeTopHeight{
            customNav.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#745683")
        }else{
            customNav.backgroundColor = UIColor.clear
        }
    }
}

extension YXSContentDetialController: YXSRouterEventProtocol{
    func yxs_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kYXSCustomNavBackEvent:
            yxs_onBackClick()
        default:
            break
        }
    }
}


class YXSContentDetialCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(timeIcon)
        contentView.addSubview(yxs_nameLabel)
        contentView.addSubview(yxs_timeLabel)
        contentView.addSubview(yxs_numberLabel)
        
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 15,rightMargin: 0)
        yxs_numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(16)
        }
        yxs_nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(46)
            make.top.equalTo(14)
            make.right.equalTo(-16)
        }
        timeIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 11, height: 11))
            make.left.equalTo(yxs_nameLabel).offset(5)
            make.top.equalTo(yxs_nameLabel.snp_bottom).offset(8)
        }
        
        yxs_timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeIcon.snp_right).offset(5)
            make.centerY.equalTo(timeIcon)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:YXSTrackModel!
    
    func yxs_setCellModel(_ model: YXSTrackModel, row: Int){
        yxs_nameLabel.text = model.trackTitle
        yxs_timeLabel.text = String.init(format: "%02d:%02d", ((model.duration ?? 0)/60),((model.duration ?? 0)%60))
        
        yxs_numberLabel.text = "\(row + 1)"
    }
    // MARK: -getter&setter
    lazy var timeIcon: UIImageView = {
        let timeIcon = UIImageView.init(image: UIImage.init(named: "yxs_xmly_time"))
        return timeIcon
    }()
    
    lazy var yxs_nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        return label
    }()
    
    lazy var yxs_numberLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
    
    lazy var yxs_timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
    
}

class YXSContentDetialHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// 背景图
        addSubview(imgBgView)
        imgBgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        /// 毛玻璃
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.insertSubview(blurEffectView, aboveSubview: imgBgView)
        blurEffectView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        addSubview(imageView)
        addSubview(xmlyImageView)
        addSubview(titleLabel)
        
        
        self.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#745683"), night: UIColor.yxs_hexToAdecimalColor(hex: "#745683"))
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp_right).offset(16.5)
            make.right.equalTo(-16)
            make.top.equalTo(imageView).offset(7.5)
        }
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 104*SCREEN_SCALE, height: 104*SCREEN_SCALE))
            make.left.equalTo(15)
            make.top.equalTo(95.5 + kSafeTopHeight)
        }
        xmlyImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 62, height: 10))
            make.right.equalTo(-15)
            make.top.equalTo(titleLabel.snp_bottom).offset(31)
            make.bottom.equalTo(-34.5).priorityHigh()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:YXSAlbum!
    
    func yxs_setHeaderModel(_ model: YXSAlbumsBrowseModel){
        if  model.albumIntro?.isEmpty ?? true{
            titleLabel.text = "暂无简介"
        }else{
            titleLabel.text = model.albumIntro
        }
        imageView.sd_setImage(with: URL.init(string: model.coverUrlMiddle ?? ""), placeholderImage: kImageDefualtImage)
        imgBgView.sd_setImage(with: URL.init(string: model.coverUrlMiddle ?? ""), placeholderImage: kImageDefualtImage)
    }
    // MARK: -getter&setter
    lazy var imageView: UIImageView = {
        let timeIcon = UIImageView.init(image: UIImage.init(named: "yxs_xmly_time"))
        return timeIcon
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#ffffff"), night: UIColor.yxs_hexToAdecimalColor(hex: "#ffffff"))
        label.numberOfLines = 5
        return label
    }()
    
    lazy var xmlyImageView: UIImageView = {
        let timeIcon = UIImageView.init(image: UIImage.init(named: "yxs_xmly_logo"))
        return timeIcon
    }()
    
    /// 背景图
    lazy var imgBgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#745683")
        return imgView
    }()
}
