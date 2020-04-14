//
//  SLClassStarCommentItemController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/5.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import JXCategoryView
import NightNight

class SLClassStarCommentItemController: YXSBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,JXCategoryListContentViewDelegate {
    var dataSource: [SLClassStarCommentItemModel]{
        didSet{
            collectionView.reloadData()
        }
    }
    init(dataSource: [SLClassStarCommentItemModel]) {
        self.dataSource = dataSource
        super.init()
    }
    
    lazy var collectionWidth: CGFloat = self.view.frame.size.width

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    var didSelectItems:((_ item: SLClassStarCommentItemModel) -> ())?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets.init(top: 21.5, left: 27.5, bottom: 0, right: 27.5)
        layout.itemSize = CGSize.init(width: (collectionWidth - CGFloat(27.5*2) - CGFloat(2*20))/3, height: 94)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ClassStarCommentItemCell.self, forCellWithReuseIdentifier: "ClassStarCommentItemCell")
        return collectionView
    }()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItems?(dataSource[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassStarCommentItemCell", for: indexPath) as! ClassStarCommentItemCell
        cell.yxs_setCellModel(dataSource[indexPath.row])
        return cell
    }
    func listView() -> UIView! {
        return self.view
    }
}

class ClassStarCommentItemCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreLabel)

        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(51)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp_bottom).offset(7)
            make.centerX.equalTo(contentView)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(iconImageView).offset(1)
            make.bottom.equalTo(iconImageView).offset(1)
            make.width.height.equalTo(18)
        }
    }

    func yxs_setCellModel(_ model: SLClassStarCommentItemModel){
        titleLabel.text = model.evaluationItem
        scoreLabel.isHidden = true
        if model.itemType == .Service{
            let newUrl = (model.evaluationUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            iconImageView.sd_setImage(with: URL.init(string: newUrl),placeholderImage: kImageDefualtImage, completed: nil)
            scoreLabel.isHidden = false
            scoreLabel.text = "\(model.score ?? 0)"
        }else if model.itemType == .Edit{
            iconImageView.image = UIImage.init(named: "yxs_classstar_edit")
            
        }else if model.itemType == .Add{
            iconImageView.image = UIImage.init(named: "yxs_classstar_add")
            
        }else{
            iconImageView.image = UIImage.init(named: "yxs_classstar_delect")
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_classstar_total_class"))
        imageView.cornerRadius = 25.5
        return imageView
    }()

    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNight898F9A)
        return label
    }()
    
    lazy var scoreLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.cornerRadius = 9
        label.borderWidth = 1
        label.textColor = UIColor.white
        label.borderColor = UIColor.white
        label.backgroundColor = kBlueColor
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
}
