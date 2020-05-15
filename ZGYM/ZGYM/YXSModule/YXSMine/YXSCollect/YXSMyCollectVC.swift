//
//  YXSMyCollectVC.swift
//  
//
//  Created by yihao on 2020/4/14.
//

import Foundation
import NightNight

class YXSMyCollectVC: YXSBaseTableViewController {
    
    let dataSouer = [["title":"宝宝听", "imgName":"yxs_babyhear_icon"],["title":"文章", "imgName":"yxs_childcontent_icon"]]
//    ,["title":"同步课堂", "imgName":"yxs_synclass_icon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        tableView.register(YXSBaseTableViewCell.self, forCellReuseIdentifier: "YXSMyCollectVCCell")
        
    }
    
    override func yxs_refreshData() {
        yxs_endingRefresh()
    }
    
    // MARK: - UITableViewDataSource，UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouer.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YXSBaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSMyCollectVCCell") as! YXSBaseTableViewCell
        cell.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        cell.imageView?.image = UIImage.init(named: dataSouer[indexPath.row]["imgName"] ?? "")
        cell.textLabel?.text = dataSouer[indexPath.row]["title"]
        cell.textLabel?.mixedTextColor = MixedColor(normal: 0x575A60, night: 0x575A60)
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        }
        cell.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = YXSCollectBabyhearListVC()
            self.navigationController?.pushViewController(vc)
        case 1:
            let vc = YXSCollectArticleListVC()
            self.navigationController?.pushViewController(vc)
        case 2:
            MBProgressHUD.yxs_showMessage(message: "努力开发中，敬请期待...")
        default:
            break
        }
    }
    
}
