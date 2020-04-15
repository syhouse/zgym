//
//  YXSContentListViewController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//


import UIKit
import NightNight
import ObjectMapper
import JXCategoryView

class YXSContentListViewController: YXSBaseCollectionViewController {
    ///听单id
    var id: Int
    var dataSource: [YXSColumnContentModel] = [YXSColumnContentModel]()
    ///是否有顶部header
    var showHeader: Bool
    var cycleSource: [YXSBannerModel] = [YXSBannerModel](){
        didSet{
            var array = [String]()
            for model in cycleSource{
                array.append(model.bannerCoverUrl ?? "")
            }
            headerView.cycleScrollView.serverImgArray = array
        }
    }
    init(id: Int, showHeader: Bool = false) {
        self.id = id
        self.showHeader = showHeader
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 16.5
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 15, bottom: 0, right: 15)
        let itemW = (SCREEN_WIDTH - CGFloat(15*2) - 2*16.5)/3
        layout.itemSize = CGSize.init(width: itemW, height: itemW + 28)
        
        self.layout = layout
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    var rightButton: UIButton!
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if showHeader{
            self.view.addSubview(headerView)
        }
        collectionView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(showHeader ? headerView.height : 0)
            make.bottom.equalTo(-kTabBottomHeight)
        }
        collectionView.register(YXSContentListCell.self, forCellWithReuseIdentifier: "YXSContentListCell")
        loadBannerData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func yxs_refreshData() {
        self.curruntPage = 1
        yxs_loadData()
    }
    
    override func yxs_loadNextPage() {
        yxs_loadData()
    }
    
    func yxs_loadData() {
        YXSEducationXMLYOperationColumnsListRequest.init(page: 1, id: id).requestCollection({ (list:[YXSColumnContentModel], pageCount) in
            if self.curruntPage == 1{
                self.dataSource.removeAll()
            }
            self.dataSource += list
            self.loadMore = pageCount != self.dataSource.count
            self.yxs_endingRefresh()
            self.collectionView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
            self.yxs_endingRefresh()
        }
    }
    
    func loadBannerData(){
        YXSEducationXMLYOperationBannersRequest.init(page: 1).requestCollection({ (list:[YXSBannerModel], pageCount) in
            self.cycleSource = list
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -UI
    
    // MARK: -action
    
    
    
    // MARK: -private
    
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSContentListCell", for: indexPath) as! YXSContentListCell
        cell.setCellModel(self.dataSource[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        let vc = YXSContentDetialController.init(id: model.id ?? 0)
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: - getter&setter
    lazy var headerView: YXSContentListHeaderView = {
        let headerView = YXSContentListHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 175*SCREEN_SCALE + 55))
        headerView.cycleScrollView.delegate = self
        return headerView
    }()
}

extension YXSContentListViewController: WRCycleScrollViewDelegate{
    func cycleScrollViewDidSelect(at index: Int, cycleScrollView: WRCycleScrollView) {
        let model = self.cycleSource[index]
        let vc = YXSContentDetialController.init(id: model.bannerContentId ?? 0)
        self.navigationController?.pushViewController(vc)
    }
}

extension YXSContentListViewController:JXCategoryListContentViewDelegate{
    func listView() -> UIView! {
        return self.view
    }
}

class YXSContentListHeaderView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cycleScrollView)
        addSubview(titleLabel)
        addSubview(desLabel)
        cycleScrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(175*SCREEN_SCALE)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(cycleScrollView.snp_bottom).offset(19)
        }
        desLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-17)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        lazy var cycleScrollView: WRCycleScrollView = {
        let frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 175*SCREEN_SCALE)
        let view = WRCycleScrollView(frame: frame)
        view.pageControlAliment = .CenterBottom
        view.defaultPageDotImage = UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "f5f5f5"),size: CGSize.init(width: 5, height: 5))
            view.currentPageDotImage = UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#EA6959"),size: CGSize.init(width: 5, height: 5))
            view.pageControlPointSpace = 2.5
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = kTextMainBodyColor
        label.text = "小优推荐"
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#ABB2BE")
        label.text = "以下内容来自喜马拉雅"
        return label
    }()
}




import UIKit

class YXSContentListCell: UICollectionViewCell {
    var isEdit: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(title)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        let itemW = (SCREEN_WIDTH - CGFloat(15*2) - 2*16.5)/3
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(itemW)
        }
        title.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(imageView.snp_bottom).offset(12)
        }
    
    }
    
    func setCellModel(_ model: YXSColumnContentModel){
        imageView.sd_setImage(with: URL.init(string: model.coverUrlMiddle ?? ""), placeholderImage: UIImage.init(named: "yxs_photo_nocover"))
        title.text = model.albumTitle
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = kTextMainBodyColor
        return label
    }()
}
