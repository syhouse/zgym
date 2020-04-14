//
//  YXSPlayListViewController.swift
//  HNYMEducation
//
//  Created by Liu Jie on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSPlayListViewController: YXSBaseTableViewController {

    var trackList:[XMTrack] = [XMTrack]()
    
    init(trackList:[XMTrack] = [XMTrack](),completionHandler:(()->())? = nil) {
        super.init()
        self.trackList = trackList
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // 是否有下拉刷新
        hasRefreshHeader = false
        //是否一创建就刷新
        showBegainRefresh = false
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50.0)
        headerView.btnClose.addTarget(self, action: #selector(closeClick(sender:)), for: .touchUpInside)
        tableView.tableHeaderView = headerView
        
        tableView.register(YXSPlayListCell.classForCoder(), forCellReuseIdentifier: "YXSPlayListCell")

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = trackList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSPlayListCell") as! YXSPlayListCell
        cell.yxs_setCellModel(model, row: indexPath.row)
        return cell
    }
    
    // MARK: - Action
    @objc func closeClick(sender: YXSButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - LazyLoad
    lazy var headerView: YXSPlayListHeaderView = {
        let view = YXSPlayListHeaderView()
        return view
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

class YXSPlayListHeaderView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        addSubview(lbTitle)
        addSubview(btnClose)
        
        lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.left.equalTo(15)
        })
        
        btnClose.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.right.equalTo(-15)
            make.width.height.equalTo(15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "播放列表"
        lb.mixedTextColor = MixedColor(normal: k222222Color, night: k222222Color)
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        return lb
    }()
    
    lazy var btnClose: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "close", night: "close"), forState: .normal)
        return btn
    }()
}


class YXSPlayListCell : YXSContentDetialCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(timeIcon)
        contentView.addSubview(yxs_nameLabel)
        contentView.addSubview(yxs_timeLabel)
//        contentView.addSubview(yxs_numberLabel)
        
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        contentView.yxs_addLine(position: .bottom, mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor), leftMargin: 15,rightMargin: 0)
//        yxs_numberLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(16)
//            make.top.equalTo(16)
//        }
        yxs_nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        timeIcon.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 11, height: 11))
            make.left.equalTo(yxs_nameLabel.snp_right).offset(10)
//            make.right.equalTo(yxs_timeLabel.snp_left).offset(-5)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        yxs_timeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(timeIcon.snp_right).offset(5)
            make.right.equalTo(contentView.snp_right).offset(-15)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        yxs_nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        yxs_nameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        yxs_timeLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        yxs_timeLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yxs_setCellModel(_ model: XMTrack, row: Int){
        yxs_nameLabel.text = model.trackTitle
        yxs_timeLabel.text = String.init(format: "%02d:%02d", (model.duration/60),(model.duration%60))
    }
}
