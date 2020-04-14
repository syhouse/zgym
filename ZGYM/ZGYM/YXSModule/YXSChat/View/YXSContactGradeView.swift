//
//  YXSContactGradeView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSContactGradeView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{

    var cellSelectedBlock:((_ index:Int)->())?
    var currentIndex: Int = 0
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        self.dataSource = self
        self.delegate = self
        self.register(HMContactGradeItem.classForCoder(), forCellWithReuseIdentifier: "HMContactGradeItem")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setter
    var model: [SLClassModel]? {
        didSet {
            self.reloadData()
        }
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = model?[indexPath.row].name
        let width = (title?.yxs_getTextWidth(font: UIFont.systemFont(ofSize: 15), height: 34) ?? 0)+30
        return CGSize(width: width, height: 34)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HMContactGradeItem = collectionView.dequeueReusableCell(withReuseIdentifier: "HMContactGradeItem", for: indexPath) as! HMContactGradeItem
        cell.btnTitle.setTitle(self.model?[indexPath.row].name, for: .normal)
        if indexPath.row == currentIndex {
            cell.yxs_isSelected = true
        } else {
            cell.yxs_isSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != currentIndex {
            currentIndex = indexPath.row
            cellSelectedBlock?(currentIndex)
            collectionView.reloadData()
        }
    }
}

class HMContactGradeItem: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(btnTitle)
        btnTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var yxs_isSelected: Bool? {
        didSet {
            btnTitle.isSelected = self.yxs_isSelected ?? false

            if self.yxs_isSelected  == true {
                btnTitle.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#DEEBFF"), night: kNight282C3B)
            } else {
                btnTitle.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNight282C3B)
            }
        }
    }
    
    lazy var btnTitle: YXSButton = {
        let btn = YXSButton()
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBBC5D3), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), night: kNight5E88F7), forState: .selected)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 17
        return btn
    }()
}
