//
//  YXSClassStarDetailListController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/9.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

///班级之星光荣榜
class YXSClassStarDetailListController: YXSClassStarSignleClassCommonController {
    var classId: Int = 0
    var classModel: YXSClassStartClassModel
    var dataSource: [YXSClassStarChildrenModel] = [YXSClassStarChildrenModel]()
    init(classModel: YXSClassStartClassModel) {
        self.classModel = classModel
        super.init()
        tableViewIsGroup = true
        showBegainRefresh = false
        hasRefreshHeader = false
        
        classId = classModel.classId ?? 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNav.title = "光荣榜"
        
        tableView.tableHeaderView = tableHeaderView
        tableView.rowHeight = 61.5
        tableView.register(YXSClassStarDetailListCell.self, forCellReuseIdentifier: "YXSClassStarDetailListCell")
        tableView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E4FF")
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        dayLabel.text = "\(NSUtil.yxs_timePeriodText(dateType: classModel.dateType))(\(NSUtil.yxs_getDateText(dateType: classModel.dateType)))"
        yxs_loadClassChildrensData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(yxs_loadClassChildrensData), name: NSNotification.Name.init(rawValue: kUpdateClassStarScoreNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: -UI
    
    // MARK: -loadData
    override func uploadData() {
        curruntPage = 1
        classModel.dateType = DateType.init(rawValue: selectModel.paramsKey) ?? DateType.W
        dayLabel.text = "\(NSUtil.yxs_timePeriodText(dateType: classModel.dateType))(\(NSUtil.yxs_getDateText(dateType: classModel.dateType)))"
        yxs_loadClassChildrensData()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    @objc func yxs_loadClassChildrensData(){
        YXSEducationClassStarTeacherClassChildrenTopRequest.init(classId: classModel.classId ?? 0, dateType: classModel.dateType).requestCollection({ (list:[YXSClassStarChildrenModel]) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.dataSource = list
            self.tableView.reloadData()
        }) { (msg, code) in
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSClassStarDetailListCell") as! YXSClassStarDetailListCell
        cell.stage = classModel.stageType
        cell.yxs_setCellModel(dataSource[indexPath.row])
        cell.isLastRow = indexPath.row == dataSource.count - 1
        cell.rowIndex = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let childrenModel = dataSource[indexPath.row]
        childrenModel.averageScore = classModel.averageScore
        childrenModel.stageType = classModel.stageType
        let vc = YXSClassStarSignleClassStudentDetialController.init(childrenModel: childrenModel,classId: classId)
        navigationController?.pushViewController(vc)
    }
    
    
    // MARK: - getter&setter
    lazy var tableHeaderView: UIView = {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_SCALE * 173))
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_class_honour_bg"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_SCALE * 188)
        headerView.addSubview(imageView)
        headerView.clipsToBounds = true
        
        headerView.addSubview(self.dayLabel)
        self.dayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView)
            make.top.equalTo(kSafeTopHeight + 64 + 15)
        }
        return headerView
    }()
    
    lazy var dayLabel: YXSLabel = {
        let dayLabel = YXSLabel()
        dayLabel.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#E7EDFD")
        dayLabel.font = UIFont.systemFont(ofSize: 14)
        return dayLabel
    }()
    
}    


class YXSClassStarDetailListCell: UITableViewCell {
    var stage: StageType!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D2E4FF")
        contentView.addSubview(bgView)
        bgView.addSubview(userIcon)
        bgView.addSubview(nameLabel)
        bgView.addSubview(scoreLabel)
        bgView.addSubview(numberLabel)
        bgView.addSubview(numberIconView)
        
        bgView.yxs_addLine(position: .bottom, leftMargin: 15.5,rightMargin: 15.5)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        userIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 41, height: 41))
            make.left.equalTo(51)
            make.centerY.equalTo(bgView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp_right).offset(13)
            make.centerY.equalTo(bgView)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-30.5)
            make.centerY.equalTo(bgView)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.centerY.equalTo(bgView)
        }
        numberIconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 21, height: 29))
            make.left.equalTo(15.5)
            make.centerY.equalTo(bgView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //背景间隔
    var isAllView: Bool = false{
        didSet{
            bgView.snp.remakeConstraints { (make) in
                make.top.left.right.bottom.equalTo(0)
            }
        }
    }
    
    var rowIndex: Int = 0{
        didSet{
            if rowIndex == 0{
                bgView.yxs_addRoundedCorners(corners: [.topLeft,.topRight], radii: CGSize.init(width: 4, height: 4), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 61.5))
            }else{
                bgView.yxs_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 0, height: 0), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 61.5))
            }
        }
    }
    
    var isLastRow: Bool = false{
        didSet{
            if isLastRow{
                bgView.yxs_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 4, height: 4), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 61.5))
            }else{
                bgView.yxs_addRoundedCorners(corners: [.bottomLeft,.bottomRight], radii: CGSize.init(width: 0, height: 0), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 61.5))
            }
        }
    }
    func yxs_setCellModel(_ model: YXSClassStarChildrenModel){
        
        nameLabel.text = model.childrenName ?? ""
        scoreLabel.text = "\(model.score ?? 0)\(stage == StageType.KINDERGARTEN ? "朵" : "分")"
        numberIconView.isHidden = true
        numberLabel.isHidden = true
        userIcon.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        let topNo = model.topNo ?? 0
        if topNo > 3{
            numberLabel.isHidden = false
            numberLabel.text = "\(topNo)"
        }else{
            numberIconView.isHidden = false
            switch topNo {
            case 1:
                numberIconView.image = UIImage.init(named: "yxs_punchCard_first")
            case 2:
                numberIconView.image = UIImage.init(named: "yxs_punchCard_secend")
            default:
                numberIconView.image = UIImage.init(named: "yxs_PunchCard_thrid")
            }
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    // MARK: -getter&setter
    lazy var numberIconView: UIImageView = {
        let numberIconView = UIImageView.init(image: kImageDefualtImage)
        numberIconView.cornerRadius = 20.5
        return numberIconView
    }()
    lazy var userIcon: UIImageView = {
        let userIcon = UIImageView.init(image: kImageUserIconStudentDefualtImage)
        userIcon.cornerRadius = 20.5
        userIcon.contentMode = .scaleAspectFill
        return userIcon
    }()
    
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var numberLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    
    lazy var scoreLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = kBlueColor
        return label
    }()
    
}
