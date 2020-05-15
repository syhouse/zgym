//
//  YXSPeriodicalListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/7.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class YXSPeriodicalListController: YXSBaseTableViewController{
    var dataSource: [YXSPeriodicalListModel] = [YXSPeriodicalListModel]()
    // MARK: -leftCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "优期刊"
        
        tableView.register(YXSPeriodicalCell.self, forCellReuseIdentifier: "YXSPeriodicalCell")
    }
    
    override func yxs_refreshData() {
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    func loadData(){
        YXSEducationPeriodicalPageRequest.init(currentPage: currentPage).request({ (json) in
            self.yxs_endingRefresh()
            let list = Mapper<YXSPeriodicalListModel>().mapArray(JSONObject: json["records"].object) ?? [YXSPeriodicalListModel]()
            
            if self.currentPage == 1{
                self.dataSource.removeAll()
            }
            self.dataSource += list
            self.loadMore = json["total"].intValue > self.dataSource.count
            self.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func yxs_initUI(){
        view.addSubview(yxs_scheduleImage)
        view.addSubview(yxs_scheduleLabel)
        
        view.addSubview(yxs_imageView)
        yxs_scheduleImage.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        yxs_imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.right.equalTo(view).offset(-100)
            make.size.equalTo(CGSize.init(width: 271, height: 188.5))
        }
        yxs_scheduleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(yxs_imageView.snp_bottom).offset(15.5)
        }
    }
    
    lazy var yxs_scheduleImage: UIImageView = {
        let yxs_imageView = UIImageView()
        yxs_imageView.contentMode = .scaleAspectFit
        return yxs_imageView
    }()
    
    lazy var yxs_scheduleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        label.text = "暂无优期刊"
        return label
    }()
    
    lazy var yxs_imageView: UIImageView = {
        let yxs_imageView = UIImageView()
        yxs_imageView.mixedImage = MixedImage(normal: "yxs_empty_classScheduleCard", night: "yxs_empty_classScheduleCard_night")
        return yxs_imageView
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSPeriodicalCell", for: indexPath) as! YXSPeriodicalCell
        cell.yxs_setCellModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YXSPeriodicalListDetialController.init(listModel: dataSource[indexPath.row])
        self.navigationController?.pushViewController(vc)
    }
    
    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSource
    }
}
