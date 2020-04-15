//
//  SLComplaintViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/2/24.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSComplaintOptionsViewController: YXSBaseTableViewController {
    private var respondentId: Int = 0
    private var respondentType: String = ""
    
    init(respondentId:Int, respondentType:String) {
        super.init()
        self.respondentId = respondentId
        self.respondentType = respondentType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户投诉"
        // Do any additional setup after loading the view.
        self.tableView.register(YXSProfileTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSProfileTableViewCell")
    }
    
    // MARK: - Action
    
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource().count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = dataSource()[section] as! Array<Any>
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:YXSProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSProfileTableViewCell") as! YXSProfileTableViewCell
        let sectionArr = dataSource()[indexPath.section] as! Array<Any>
        let dic = sectionArr[indexPath.row] as! [String:String]
        cell.lbTitle.text = dic["title"]
        cell.lbSubTitle.text = dic["subTitle"]
        cell.cellStyle = .SubTitle
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor.init(normal: kTableViewBackgroundColor, night: UIColor.clear)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var type: String = "CONTENT_VIOLATION"
        switch indexPath.row {
            case 0:
                type = "CONTENT_VIOLATION"
            case 1:
                type = "SUSPECTED_FRAUD"
            case 2:
                type = "PUBLISH_ADVERTISEMENTS"
            default:
                type = "OTHER"
        }
        let vc = YXSComplaintDetailViewController(respondentId: respondentId, respondentType: respondentType, type: type)
        self.navigationController?.pushViewController(vc)
        
    }
    
    // MARK: - LazyLoad
    @objc func dataSource()-> Array<Any>{
        var arr = Array<Any>()
        let section1 = [["title":"内容违规", "subTitle": "", "action":""],["title":"涉嫌欺诈", "subTitle":"", "action":""],["title":"发布广告", "subTitle":"", "action":""],["title":"其它", "subTitle":"", "action":""]]
        arr.append(section1)
        return arr
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
