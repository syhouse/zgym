//
//  SLMineCommentViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/10.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import YYText

class SLMineCommentViewController: SLBaseTableViewController {

    var dataSource:[SLClassStarHistoryModel] = [SLClassStarHistoryModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的点评"
        // Do any additional setup after loading the view.
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        headerView.mixedBackgroundColor = MixedColor.init(normal: kTableViewBackgroundColor, night: UIColor.clear)
        self.tableView.tableHeaderView = headerView
        
        self.tableView.register(MineCommentCell.classForCoder(), forCellReuseIdentifier: "MineCommentCell")
        
        self.loadMore = true
    }
    
    override func sl_loadNextPage() {
        super.sl_loadNextPage()
        requestData()
    }
    
    override func sl_refreshData() {
        requestData()
    }
    
    // MARK: - Request
    @objc func requestData() {
        SLEducationTeacherMyEvaluationHistoryListRequest(currentPage: curruntPage, stage: self.sl_user.stage ?? "").requestCollection({ [weak self](list:[SLClassStarHistoryModel]) in
            guard let weakSelf = self else {return}
            weakSelf.sl_endingRefresh()
            if weakSelf.curruntPage == 1{
                weakSelf.dataSource.removeAll()
            }
//            let list = Mapper<SLHomeListModel>().mapArray(JSONObject: result["homeworkList"].object) ?? [SLHomeListModel]()
            weakSelf.dataSource += list
            weakSelf.tableView.reloadData()
            
        }) { [weak self](msg, code) in
            guard let weakSelf = self else {return}
            MBProgressHUD.sl_showMessage(message: msg)
            weakSelf.sl_endingRefresh()
            
        }
    }

    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MineCommentCell = tableView.dequeueReusableCell(withIdentifier: "MineCommentCell") as! MineCommentCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let model:SLClassStarHistoryModel = dataSource[indexPath.row]
            MBProgressHUD.sl_showLoading()
            SLEducationTeacherDeleteEvaluationHistoryRequest(classId: model.classId ?? 0, evaluationHistoryId: model.id ?? 0).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                MBProgressHUD.sl_showMessage(message: "删除成功")
                weakSelf.dataSource.remove(at: indexPath.row)
                weakSelf.tableView.reloadData()
                
            }) { (msg , code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
        }
    }
    

//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let more = UITableViewRowAction(style: .normal, title: "删除") { action, index in
//            println("more button tapped")
        }
        more.backgroundColor = UIColor.lightGray

        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
//            println("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orange

        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
//            println("share button tapped")
        }
        share.backgroundColor = UIColor.blue

        return [share, favorite, more]
    }

    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
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


class MineCommentCell: SLBaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.addSubview(imgAvatar)
        contentView.addSubview(lbTitle)
        contentView.addSubview(lbSubTitle)
        layout()
        
//        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
//        imageView?.image = kImageUserIconStudentDefualtImage
//        self.editingAccessoryView = imgView
        contentView.sl_addLine(position: .bottom, color: kLineColor, leftMargin: 70, rightMargin: 0, lineHeight: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
    var model: SLClassStarHistoryModel? {
        didSet {
            let placeholderImg = SLPersonDataModel.sharePerson.personRole == .TEACHER ? kImageUserIconTeacherDefualtImage:kImageUserIconStudentDefualtImage
            let newUrl = (self.model?.evaluationUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            imgAvatar.sd_setImage(with: URL(string: newUrl ?? ""), placeholderImage: placeholderImg)
            
            let str = "\(self.model?.scoreDescribe ??  "") \(self.model?.evaluationItem ?? "")"
            let att = NSMutableAttributedString(string: str)
            let blueRange = NSRange(location: 0, length: self.model?.scoreDescribe?.count ?? 0)
            att.yy_setTextHighlight(blueRange, color: UIColor.sl_hexToAdecimalColor(hex: "#5E88F7"), backgroundColor: nil, userInfo: nil)
            lbTitle.attributedText = att
            
            lbSubTitle.text = "我点评了\(self.model?.childrenName ?? "")   \(self.model?.createTime?.sl_Time() ?? "")"
        }
    }
    
    // MARK: -
    func layout() {
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.top.equalTo(13)
            make.left.equalTo(15)
            make.width.height.equalTo(42)
        })
    
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(16)
            make.left.equalTo(imgAvatar.snp_right).offset(14)
            make.right.equalTo(-15)
        })
        
        lbSubTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(10)
            make.left.equalTo(lbTitle.snp_left)
            make.right.equalTo(lbTitle.snp_right)
            make.bottom.equalTo(-16)
        })
    }
    
    // MARK: - LazyLoad
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.lightGray
        img.cornerRadius = 21
        img.image = UIImage(named: "normal")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var lbTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: 0x575A60, night: 0xFFFFFF)
//        lb.text = "王老师"
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var lbSubTitle: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0xFFFFFF)
        lb.text = "2019/11/13 14:30"
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
}
