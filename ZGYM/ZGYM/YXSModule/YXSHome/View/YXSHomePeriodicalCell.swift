//
//  YXSHomePeriodicalCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/18.
//  Copyright © 2020 zgym. All rights reserved.
//
import UIKit
import NightNight

private let maxHomePeriodicalLine = 6
private let kLineCellOrginTag = 33301

class YXSHomePeriodicalCell: YXSHomeBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func longTap(_ longTap: UILongPressGestureRecognizer){
        
    }
    public var headerBlock: ((FriendsCircleHeaderBlockType) -> ())?
    override func yxs_setCellModel(_ model: YXSHomeListModel) {
        self.model = model
        if let periodicalListModel = model.periodicalListModel{
            titleLabel.text = periodicalListModel.articles?.first?.title
            UIUtil.yxs_setLabelAttributed(periodicalNumbleLabel, text: [" | ", "\(periodicalListModel.numPeriods ?? 0)期"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#B6C9FD"), night: UIColor.yxs_hexToAdecimalColor(hex: "#B6C9FD")), MixedColor(normal: kBlueColor, night: kBlueColor)])
            nameTimeLabel.text = periodicalListModel.articles?.first?.uploadTime?.yxs_Time()
            rightImageView.sd_setImage(with: URL.init(string: periodicalListModel.articles?.first?.cover?.yxs_getImageThumbnail() ?? ""), placeholderImage: kImageDefualtImage)
            for index in 0..<maxHomePeriodicalLine{
                let lineCell = bgContainView.viewWithTag(index + kLineCellOrginTag)
                lineCell?.isHidden = true
            }
            if let articles = periodicalListModel.articles{
                for (index, article) in articles.enumerated(){
                    if index == 0{
                        continue
                    }
                    let lineCell = bgContainView.viewWithTag(index - 1 + kLineCellOrginTag) as? LineCell
                    lineCell?.titleLabel.text = article.title
                    lineCell?.isHidden = false
                }
            }
        }
    }
    
    private func initUI(){
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(nameTimeLabel)
        bgContainView.addSubview(leftImageView)
        bgContainView.addSubview(titleLabel)
        bgContainView.addSubview(periodicalNumbleLabel)
        bgContainView.addSubview(lookLastControl)
        bgContainView.addSubview(rightImageView)
        
        for index in 0..<maxHomePeriodicalLine{
            let lineCell = LineCell()
            lineCell.tag = kLineCellOrginTag + index
            lineCell.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
            bgContainView.addSubview(lineCell)
        }
    }
    
    func layout(){
        bgContainView.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0).priorityHigh()
        }
        
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(22)
            make.size.equalTo(CGSize.init(width: 48, height: 16))
        }
        periodicalNumbleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp_right).offset(9)
            make.centerY.equalTo(leftImageView)
        }
        lookLastControl.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.right.equalTo(-13)
            make.centerY.equalTo(leftImageView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(leftImageView.snp_bottom).offset(14)
            make.right.equalTo(-107)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-13.5)
            make.top.equalTo(leftImageView.snp_bottom).offset(14)
            make.size.equalTo(CGSize.init(width: 65, height: 65))
        }
        nameTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14.5)
            make.top.equalTo(titleLabel.snp_bottom).offset(16)
        }
        var last: UIView?
        for index in 0..<maxHomePeriodicalLine{
            let lineCell = bgContainView.viewWithTag(index + kLineCellOrginTag)
            lineCell?.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.height.equalTo(43)
                if let last = last{
                    make.top.equalTo(last.snp_bottom)
                }else{
                    make.top.equalTo(nameTimeLabel.snp_bottom).offset(14.5)
                }
            }
            last = lineCell
        }
    }
    
    @objc func controlClick(control: UIControl){
        let index: Int = control.tag - kLineCellOrginTag
        if let articles = model.periodicalListModel?.articles{
            UIUtil.TopViewController().yxs_pushPeriodicalHtml(id: articles[index + 1].id ?? 0)
        }
    }
    @objc func pushPeriodicalListVc(){
        let vc = YXSPeriodicalListController()
        UIUtil.currentNav().pushViewController(vc)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var periodicalNumbleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var leftImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_home_periodical_logo"))
        return imageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 2.5
        return imageView
    }()
    
    lazy var lookLastControl: YXSCustomImageControl = {
        let remaidControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 13.4, height: 13.4), position: YXSImagePositionType.right, padding: 9.5)
        remaidControl.font = UIFont.boldSystemFont(ofSize: 14)
        remaidControl.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        remaidControl.locailImage = "arrow_gray"
        remaidControl.title = "查看往期"
        remaidControl.yxs_touchInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        remaidControl.addTarget(self, action: #selector(pushPeriodicalListVc), for: .touchUpInside)
        return remaidControl
    }()
}

class LineCell: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(rightImageView)
        yxs_addLine(position: .top, color: kLineColor, leftMargin: 14.5, rightMargin: 14.5)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-35)
            make.centerY.equalTo(self)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 8.25, height: 13.5))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#9196A1"), night: UIColor.yxs_hexToAdecimalColor(hex: "#9196A1"))
        return label
    }()
    
    lazy var rightImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_punch_right"))
        return imageView
    }()
}
