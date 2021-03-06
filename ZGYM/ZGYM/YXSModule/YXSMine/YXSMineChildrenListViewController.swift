//
//  SLMineChildrenListViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/9.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
/// 我的孩子列表
class YXSMineChildrenListViewController: YXSBaseTableViewController {

    var childrenList: [YXSChildrenModel] = [YXSChildrenModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "我的孩子"
        tableView.register(MineChildrenListCell.classForCoder(), forCellReuseIdentifier: "MineChildrenListCell")
    }
    
    // MARK: - Request
    override func yxs_refreshData() {
        MBProgressHUD.yxs_showLoading()
        YXSEducationChildrenListRequest().requestCollection({ [weak self](list:[YXSChildrenModel]) in
            guard let weakSelf = self else {return}
            
            MBProgressHUD.yxs_hideHUD()
            weakSelf.yxs_endingRefresh()
            weakSelf.childrenList = list
            if weakSelf.childrenList.count == 0 {
                MBProgressHUD.yxs_showMessage(message: "暂无孩子")
            }
            weakSelf.tableView.reloadData()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.yxs_showMessage(message: msg)
            weakSelf.yxs_endingRefresh()
        }
    }
    
    // MARK: -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.childrenList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MineChildrenListCell = tableView.dequeueReusableCell(withIdentifier: "MineChildrenListCell") as! MineChildrenListCell
        cell.model = self.childrenList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YXSProfileChildrenViewController()
        vc.model = self.childrenList[indexPath.row]
        self.navigationController?.pushViewController(vc)
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

class MineChildrenListCell: YXSBaseTableViewCell  {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        
        let panelView = UIView()
        contentView.addSubview(panelView)
        contentView.addSubview(imgAvatar)
        panelView.addSubview(lbTitle)
        panelView.addSubview(lbSubTitle)
        panelView.addSubview(lbThirdTitle)
        contentView.addSubview(imgRightArrow)
        
        panelView.snp.makeConstraints({ (make) in
            make.top.equalTo(19)
            make.left.equalTo(15)
            make.bottom.equalTo(-19)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        lbThirdTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbSubTitle.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        imgRightArrow.snp.makeConstraints({ (make) in
            make.centerY.equalTo(imgAvatar.snp_centerY)
            make.right.equalTo(-15)
            make.width.equalTo(9)
            make.height.equalTo(14)
        })
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.left.equalTo(panelView.snp_right).offset(48)
            make.right.equalTo(imgRightArrow.snp_left).offset(-13)
            make.width.height.equalTo(50)
            make.top.equalTo(22)
        })
        
        contentView.yxs_addLine(position: .top, color: kTableViewBackgroundColor, leftMargin: 0, rightMargin: 0, lineHeight: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:YXSChildrenModel? {
        didSet {
            let placeholderImg = kImageUserIconStudentDefualtImage//YXSPersonDataModel.sharePerson.personRole == .TEACHER ? kImageUserIconTeacherDefualtImage:kImageUserIconStudentDefualtImage
            imgAvatar.sd_setImage(with: URL(string: self.model?.avatar ?? ""), placeholderImage: placeholderImg)
            lbTitle.text = self.model?.realName
            lbSubTitle.text = "学号：\(self.model?.studentId ?? "")"
            var strArr = [String]()
            strArr.append(self.model?.grade?.name ?? "")
            lbThirdTitle.text = "班级：\(strArr.joined(separator: "、"))"
        }
    }
    
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.cornerRadius = 25
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x575A60, night: 0xFFFFFF)
//        lb.text = "王老师"
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbSubTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0xFFFFFF)
//        lb.text = "2019/11/13 14:30"
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var lbThirdTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0xFFFFFF)
//        lb.text = "2019/11/13 14:30"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var imgRightArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_class_arrow")
        return img
    }()
}
