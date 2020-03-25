//
//  SLAgendaListController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/21.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

private let images = [kPunchCardKey,kHomeworkKey,kSolitaireKey,kNoticeKey]
private let titles = ["打卡任务","作业","接龙","通知"]
private let serviceIds = [2,1,3,0]
private let events = [HomeType.punchCard,.homework,HomeType.solitaire,HomeType.notice]
class SLAgendaListController: SLBaseTableViewController {
    var dataSource: [SLAgendaListModel] = [SLAgendaListModel]()
    override init() {
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
        
        title = "待办事项"
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: kNightBackgroundColor)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }
        tableView.register(AgendaListCell.self, forCellReuseIdentifier: "AgendaListCell")
        tableView.rowHeight = 87
        
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAgenda), name: NSNotification.Name.init(rawValue: kHomeAgendaReducNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -UI
    @objc func updateAgenda(_ notification:Notification){
        let userInfo = notification.object as? [String: Any]
        if let userInfo = userInfo{
            if let type =  userInfo[kEventKey] as? HomeType{
                for model in dataSource{
                    if model.eventType == type{
                        if type == .punchCard{
                            model.count -= 1
                            if let hasFinish = userInfo[kValueKey] as? Bool{
                                if hasFinish{
                                    model.allCount -= 1
                                }
                            }
                        }else{
                            model.count -= 1
                            model.allCount -= 1
                        }
                        break
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: -loadData
    override func sl_refreshData() {
        self.curruntPage = 1
        loadData()
    }
    
    func loadData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var request: SLBaseRequset!
        if SLPersonDataModel.sharePerson.personRole == .TEACHER{
            request = SLEducationTodoTeacherRedPointGroupRequest()
        }else{
            request = SLEducationTodoChildrenRedPointGroupRequest.init(childrenClassList: sl_childrenClassList)
        }
        
        request.requestCollection({ (list:[AgendaRedModel]) in
            MBProgressHUD.hide(for: self.view, animated: false)
            //            0:通知,1:作业,2:打卡,3:接龙,4:成绩,5:班级圈
            for index in 0..<images.count{
                let model = SLAgendaListModel()
                model.image = images[index]
                model.title = titles[index]
                model.eventType = events[index]
                for redModel in list{
                    if serviceIds[index] == redModel.serviceType{
                        model.count = redModel.count ?? 0
                        if let allCount = redModel.allCount{
                            model.allCount = allCount
                        }else{
                            model.allCount = model.count
                        }
                        break
                    }
                }
                self.dataSource.append(model)
            }
            self.tableView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: false)
            MBProgressHUD.sl_showMessage(message: msg)
        }
        
    }
    
    // MARK: -action
    
    
    // MARK: -private
    func reloadTableView(_ indexPath: IndexPath){
        //        none
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaListCell") as! AgendaListCell
        cell.sl_setCellModel(model)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listModel = dataSource[indexPath.row]
        if (listModel.allCount == 0 && listModel.eventType == .punchCard) || (listModel.count == 0 && listModel.eventType != .punchCard){
            return
        }
        switch listModel.eventType {
        case .homework:
            let vc = SLHomeworkListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        case .notice:
            let vc = SLNoticeListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        case .solitaire:
            let vc = SLSolitaireListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        case .punchCard:
            let vc = SLPunchCardListController.init(isAgenda: true)
            navigationController?.pushViewController(vc)
            break
        default:
            break
        }
    }
    
    
    // MARK: - getter&setter
    
}

class AgendaListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        
        contentView.addSubview(bgContainView)
        bgContainView.addSubview(iconImageView)
        bgContainView.addSubview(titlelabel)
//        bgContainView.addSubview(desLabel)
        bgContainView.addSubview(redLabel)
        bgContainView.addSubview(iconImageView)
        bgContainView.addSubview(arrowImage)
        
        bgContainView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(bgContainView)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        
        arrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 13.4, height: 13.4))
            make.centerY.equalTo(bgContainView)
        }
        redLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp_left).offset(-11)
            make.centerY.equalTo(bgContainView)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: SLAgendaListModel!
    func sl_setCellModel(_ model: SLAgendaListModel){
        iconImageView.image = UIImage.init(named: model.image)
        titlelabel.text = model.title
        
        var rightText = ""
        switch model.eventType {
        case .punchCard:
            rightText = SLPersonDataModel.sharePerson.personRole == .PARENT ? "项待打卡" : "项打卡待查看"
        case .homework:
            rightText = SLPersonDataModel.sharePerson.personRole == .PARENT ? "项作业待提交" : "份作业待查看"
        case .solitaire:
            rightText = SLPersonDataModel.sharePerson.personRole == .PARENT ? "项接龙待提交" : "份接龙待查看"
        case .notice:
            rightText = SLPersonDataModel.sharePerson.personRole == .PARENT ? "项通知待回执" : "份通知回执待查看"
        default:
            break
        }
        
        if model.count > 0{
            redLabel.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightLightForegroundColor)
            redLabel.text = "\(model.count)\(rightText)"
        }else{
            redLabel.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightLightForegroundColor)
            redLabel.backgroundColor = UIColor.clear
            redLabel.text = "暂无"
        }
        
//        if model.desTitle.isEmpty{
//            desLabel.isHidden = true
//            titlelabel.snp.remakeConstraints { (make) in
//                make.left.equalTo(iconImageView.snp_right).offset(14.5)
//                make.centerY.equalTo(bgContainView)
//            }
//        }else{
//            desLabel.isHidden = false
//            desLabel.text = model.desTitle
//            titlelabel.snp.remakeConstraints { (make) in
//                make.left.equalTo(iconImageView.snp_right).offset(14.5)
//                make.top.equalTo(19)
//            }
//            desLabel.snp.remakeConstraints { (make) in
//                make.left.equalTo(iconImageView.snp_right).offset(14.5)
//                make.top.equalTo(titlelabel.snp_bottom).offset(8)
//            }
//        }
        desLabel.isHidden = true
        titlelabel.snp.remakeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(14.5)
            make.centerY.equalTo(bgContainView)
        }
    }
    
    // MARK: -action
    
    
    // MARK: -getter&setter
    lazy var bgContainView: UIView = {
        let bgContainView = UIView()
        bgContainView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        bgContainView.cornerRadius = 4
        return bgContainView
    }()
    
    lazy var titlelabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#222222"), night: kNightLightForegroundColor)
        return label
    }()
    
    lazy var desLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightLightForegroundColor)
        return label
    }()
    
    lazy var redLabel: SLPaddingLabel = {
        let redLabel = SLPaddingLabel()
        redLabel.font = UIFont.systemFont(ofSize: 14)
        return redLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    lazy var arrowImage: UIImageView = {
        let arrowImage = UIImageView.init(image: UIImage.init(named: "arrow_gray"))
        return arrowImage
    }()
    
}
