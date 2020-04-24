//
//  YXSExcellentEducationVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSExcellentEducationVC: YXSBaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    let dataSource: [String] = ["yxs_synclass_background","yxs_childcontent_background","yxs_babyhear_background","yxs_periodical_background"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.remakeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSExcellentEducationCell") as! YXSExcellentEducationCell
        cell.selectionStyle = .none
        cell.backgroundImageV.image = UIImage.init(named: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //同步课堂
            let vc = YXSSynClassHomeListVC()
            navigationController?.pushViewController(vc)
        } else if indexPath.row == 1 {
            let vc = YXSChildContentHomeListVC()
            navigationController?.pushViewController(vc)
            //育儿好文
        } else if indexPath.row == 2 {
            //宝宝听
            let vc = YXSContentHomeController()
            vc.title = "宝宝听"
            navigationController?.pushViewController(vc)
        } else {
            //优期刊
        }
    }
    
    // MARK: - getter&setter
    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
       tableView.dataSource = self
       tableView.delegate = self
       tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
       tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
       tableView.emptyDataSetDelegate = self
       tableView.emptyDataSetSource = self
       if #available(iOS 11.0, *){
           tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
       }
       tableView.estimatedSectionHeaderHeight = 0
       //去除group空白
       tableView.estimatedSectionFooterHeight = 0.0
       tableView.rowHeight = 125
       tableView.register(YXSExcellentEducationCell.self, forCellReuseIdentifier: "YXSExcellentEducationCell")
       return tableView
   }()
}
