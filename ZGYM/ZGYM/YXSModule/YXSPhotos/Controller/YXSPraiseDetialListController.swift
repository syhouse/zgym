//
//  YXSPraiseDetialListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/19.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
import MBProgressHUD

class YXSPraiseDetialListController: YXSBaseTableViewController {
    var dataSource: [YXSFriendsPraiseModel] = [YXSFriendsPraiseModel]()
    var classId: Int
    var resourceId: Int
    var albumId: Int
    init(classId: Int, resourceId: Int, albumId: Int) {
        self.classId = classId
        self.resourceId = resourceId
        self.albumId = albumId
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "点赞详情"
        
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        tableView.register(YXSPraiseDetialListListCell.self, forCellReuseIdentifier: "YXSPraiseDetialListListCell")
        tableView.rowHeight = 69.5
        tableView.sectionHeaderHeight = 10
        yxs_loadData()
    }
    
    public func yxs_loadData() {
        YXSEducationAlbumQueryPraiseListRequest(classId: classId, resourceId: resourceId, albumId: albumId).requestCollection({ [weak self](list: [YXSFriendsPraiseModel]) in
            guard let weakSelf = self else {return}
            weakSelf.dataSource = list
            weakSelf.tableView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSPraiseDetialListListCell") as! YXSPraiseDetialListListCell
        cell.selectionStyle = .none
        cell.model = dataSource[indexPath.row]
        return cell
    }

}


// 班级相册班级Cell
class YXSPraiseDetialListListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        contentView.addSubview(avarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        
        avarView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 41, height: 41))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avarView.snp_right).offset(14.5)
            make.top.equalTo(17)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(8)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var model: YXSFriendsPraiseModel? {
        didSet {
            nameLabel.text = model?.userName
            timeLabel.text = Date.yxs_Time(date: Date(timeIntervalSince1970: TimeInterval(model?.createTime ?? 0)))
            avarView.sd_setImage(with: URL.init(string: model?.avatar ?? ""), placeholderImage: model?.userType == PersonRole.TEACHER.rawValue ? kImageUserIconTeacherDefualtImage : kImageUserIconPartentDefualtImage)
        }
    }
    
    
    lazy var avarView: UIImageView = {
        let avarView = UIImageView()
        avarView.cornerRadius = 20.5
        return avarView
    }()
    
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        return label
    }()
}
