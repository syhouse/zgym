//
//  SLPunchCardDetialTableFooterView.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/3/27.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSPunchCardDetialTableFooterView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier:reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        contentView.addSubview(showMoreView)
        showMoreView.addSubview(showAllControl)
        showMoreView.snp.makeConstraints { (make) in
            make.left.equalTo(15).priorityHigh()
            make.height.equalTo(30)
            make.top.equalTo(0)
            make.right.equalTo(-15).priorityHigh()
        }
        showAllControl.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.height.equalTo(21)
            make.top.equalTo(0)
        }
        
        contentView.addSubview(lastLineView)
        lastLineView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///打卡提交列表model
    var model: YXSPunchCardCommintListModel!
    func setFooterModel(_ model: YXSPunchCardCommintListModel){
        self.model = model
        if model.isNeeedShowCommentAllButton{
            showMoreView.isHidden = false
            showAllControl.isSelected = model.isShowCommentAll
        }else{
            showMoreView.isHidden = true
        }
    }
    
    var hmModel: YXSHomeworkDetailModel!
    func setFooterHomeworkModel(_ model: YXSHomeworkDetailModel){
        self.hmModel = model
        if model.isNeeedShowCommentAllButton{
            showMoreView.isHidden = false
            showAllControl.isSelected = model.isShowCommentAll
        }else{
            showMoreView.isHidden = true
        }
    }
    
    var footerBlock: (()->())?
    
    public var isLastSection: Bool = false{
        didSet{
            lastLineView.isHidden = !isLastSection
        }
    }
    
    @objc func showAllClick(){
        if self.model != nil {
            model.isShowCommentAll = !model.isShowCommentAll
        } else {
            hmModel.isShowCommentAll = !hmModel.isShowCommentAll
        }
        footerBlock?()

    }
    
    lazy var showMoreView: UIView = {
        let showMoreView = UIView()
        showMoreView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#292B3A"))
        return showMoreView
    }()
    
    lazy var lastLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        return lineView
    }()
    
    lazy var showAllControl: YXSCustomImageControl = {
        let showAllControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 14, height: 14), position: YXSImagePositionType.right, padding: 5.5)
        showAllControl.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), night: UIColor.yxs_hexToAdecimalColor(hex: "#696C73"))
        showAllControl.setTitle("展开全部", for: .normal)
        showAllControl.setTitle("收起", for: .selected)
        showAllControl.font = UIFont.boldSystemFont(ofSize: 14)
        showAllControl.setImage(UIImage.init(named: "down_gray"), for: .normal)
        showAllControl.setImage(UIImage.init(named: "up_gray"), for: .selected)
        showAllControl.addTarget(self, action: #selector(showAllClick), for: .touchUpInside)
        showAllControl.isSelected = false
        return showAllControl
    }()
}
