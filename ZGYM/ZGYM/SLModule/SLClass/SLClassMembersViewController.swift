//
//  SLClassMembersViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/22.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

class SLClassMembersViewController: SLBaseTableViewController {
    
    var gradeId: Int!
    
    var teacherList: [SLClassMemberModel] = [SLClassMemberModel]()
    var studentList: [SLClassMemberModel] = [SLClassMemberModel]()
    
    override func viewDidLoad() {
        self.tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        
        super.viewDidLoad()
        self.title = "班级人员"
        // Do any additional setup after loading the view.
        self.tableView.register(SLClassMembersTableViewCell.classForCoder(), forCellReuseIdentifier: "SLClassMembersTableViewCell")
        self.tableView.register(ClassMembersSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: "ClassMembersSectionHeader")
        
    }
    
    // MARK: -Request
    override func sl_refreshData() {
        SLEducationGradeMemberDetailRequest(gradeId: self.gradeId ?? 0).request({ [weak self](json) in
            guard let weakSelf = self else {return}
            weakSelf.sl_endingRefresh()

            weakSelf.teacherList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["detailForTeacher"].rawString()!) ?? [SLClassMemberModel]()
            weakSelf.studentList = Mapper<SLClassMemberModel>().mapArray(JSONString: json["detailForParent"].rawString()!) ?? [SLClassMemberModel]()
            weakSelf.tableView.reloadData()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            weakSelf.sl_endingRefresh()
            MBProgressHUD.sl_showMessage(message: msg)
        }
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.teacherList.count
        } else {
            return self.studentList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let dic:[String:String] = self.dataSource[indexPath.section][indexPath.row]
        let model: SLClassMemberModel!
        if indexPath.section == 0 {
            model =  self.teacherList[indexPath.row]
        } else {
            model = self.studentList[indexPath.row]
        }
        
        let cell: SLClassMembersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SLClassMembersTableViewCell") as! SLClassMembersTableViewCell
        if indexPath.section == 0 {
            cell.imgAvatar.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconTeacherDefualtImage)
            
            cell.lbTitle.text = model.realName != nil ? model.realName : model.name
            let position = model.position == "HEADMASTER" ? "班主任" : "任课老师"
            cell.lbSubTitle.text = position
            
        } else {
            cell.imgAvatar.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: kImageUserIconStudentDefualtImage)
            var name = model.realName != nil ? model.realName : model.name
            for sub in Relationships {
                if sub.paramsKey == model.relationship {
                    name! += sub.text
                    break
                }
            }
            cell.lbTitle.text = name
            cell.lbSubTitle.text = ""
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header:UIView = UIView()
//        header.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9")
        let header: ClassMembersSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClassMembersSectionHeader") as! ClassMembersSectionHeader
        if section == 0 {
            header.lbTitle.text = "教师  (\(self.teacherList.count))"
        } else {
            header.lbTitle.text = "成员  (\(self.studentList.count))"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: SLClassMemberModel!
        var userType = ""
        if indexPath.section == 0 {
            model =  self.teacherList[indexPath.row]
            userType = PersonRole.TEACHER.rawValue
        } else {
            model = self.studentList[indexPath.row]
            userType = PersonRole.PARENT.rawValue
        }
        let vc = SLFriendsCircleInfoController.init(userId: model.userId ?? 0, childId: model.childrenId, type: userType)
        navigationController?.pushViewController(vc)
    }
    
    // MARK: - LazyLoad
//    lazy var dataSource:[[[String:String]]] = {
//        let arr:[[[String:String]]] = [[["title":"黄老师","subTitle":"班主任"],["title":"马老师","subTitle":"任课老师"]],[["title":"赵小飞妈妈"],["title":"小王的爸爸"]]]
//        return arr
//    }()
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ClassMembersSectionHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.contentView.addSubview(lbTitle)
        self.lbTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
}
