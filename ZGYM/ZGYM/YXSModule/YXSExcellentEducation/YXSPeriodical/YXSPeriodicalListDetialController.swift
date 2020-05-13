//
//  YXSPeriodicalListDetialController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/8.
//  Copyright © 2020 zgym. All rights reserved.
//


import UIKit
import NightNight

class YXSPeriodicalListDetialController: YXSBaseTableViewController{
    var dataSource: [Any] = [Any]()
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(YXSPeriodicalDetialCell.self, forCellReuseIdentifier: "YXSPeriodicalDetialCell")
    }
    
    override func yxs_refreshData() {
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        dataSource = [1,1,1,1,1]
        yxs_endingRefresh()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSPeriodicalDetialCell", for: indexPath) as! YXSPeriodicalDetialCell
        cell.yxs_setCellModel(dataSource[indexPath.row] as? XMTrack)
        return cell
    }
    
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
}


class YXSPeriodicalDetialCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(rightImageView)
        contentView.addSubview(yxs_nameLabel)
        contentView.addSubview(timeLabel)
        
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 15)

        yxs_nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(24)
            make.right.equalTo(rightImageView.snp_left).offset(-20)
            make.height.greaterThanOrEqualTo(40)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(yxs_nameLabel.snp_bottom).offset(24.5)
            make.left.equalTo(yxs_nameLabel)
            make.bottom.equalTo(-27.5).priorityHigh()
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.height.equalTo(86)
            make.top.equalTo(yxs_nameLabel).offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yxs_setCellModel(_ model: XMTrack?){
        yxs_nameLabel.text = "培养孩子自信心，从理解“毛遂自培养孩子自信心，从理解“毛遂自培养孩子自信心，从理解“毛遂自培养孩子自信心，从理解“毛遂自"
        timeLabel.text = "03.29 14:30"
        rightImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: kImageDefualtImage)
    }
    
    // MARK: -getter&setter
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.layer.cornerRadius = 2.5
        return rightImageView
    }()
    
    lazy var yxs_nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        return label
    }()
    
    lazy var timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"))
        return label
    }()
}
