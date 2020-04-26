//
//  YXSMoveToViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/10.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
/// 文件移动VC 将文件移动到指定文件夹下
class YXSMoveToViewController: YXSBaseTableViewController {

    /// From目录
    var oldParentFolderId: Int = -1
    /// To目录
    var parentFolderId: Int = -1
    /// 目录List
    var folderList: [YXSFolderModel] = [YXSFolderModel]()
    
    /// 移动那些对象
    var selectedFolderList: [Int] = [Int]()
    var selectedFileIdList: [Int] = [Int]()
    
    var classId: Int?

    var completionHandler: ((_ oldParentFolderId: Int, _ parentFolderId: Int)-> Void)?
    
    /// 注意 classId传值则认为是班级文件移动，反之则是老师书包文件移动
    init(classId: Int?, folderIdList: [Int] = [Int](), fileIdList: [Int] = [Int](), oldParentFolderId: Int = -1, parentFolderId: Int = -1, completionHandler:((_ oldParentFolderId: Int, _ parentFolderId: Int)->())?) {
        super.init()

        self.classId = classId
        self.oldParentFolderId = oldParentFolderId
        self.parentFolderId = parentFolderId
        self.selectedFolderList = folderIdList
        self.selectedFileIdList = fileIdList
        
        self.completionHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "移动文件"
        
        view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        
        tableView.register(YXSFileGroupCell.classForCoder(), forCellReuseIdentifier: "SLFileGroupCell")
        tableView.register(YXSFileCell.classForCoder(), forCellReuseIdentifier: "SLFileCell")
        
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(tableView.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(60)
        })
        
        loadData()
        
    }
    
    // MARK: - Request
    @objc func loadData() {
        if classId == nil {
            YXSSatchelFolderPageQueryRequest(currentPage: curruntPage, parentFolderId: parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let hasNext = json["hasNext"]
                
                weakSelf.folderList = Mapper<YXSFolderModel>().mapArray(JSONString: json["satchelFolderList"].rawString()!) ?? [YXSFolderModel]()
                weakSelf.tableView.reloadData()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        } else {
            YXSFileFolderPageQueryRequest(classId: classId ?? 0, currentPage: curruntPage, folderId: parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                let hasNext = json["hasNext"]
                
                weakSelf.folderList = Mapper<YXSFolderModel>().mapArray(JSONString: json["classFolderList"].rawString()!) ?? [YXSFolderModel]()
                weakSelf.tableView.reloadData()
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
        

    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = folderList[indexPath.row]
        let cell: YXSFileGroupCell = tableView.dequeueReusableCell(withIdentifier: "SLFileGroupCell") as! YXSFileGroupCell
        cell.model = item
        cell.lbTitle.text = item.folderName//"作业"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF)
        let lb = YXSLabel()
        lb.text = "将文件移动到："
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNight898F9A)
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(lb)
        lb.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        })
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = folderList[indexPath.row]
        let vc = YXSMoveToViewController(classId: classId, folderIdList: selectedFolderList, fileIdList: selectedFileIdList, oldParentFolderId: oldParentFolderId, parentFolderId: item.id ?? 0, completionHandler: completionHandler)

        navigationController?.pushViewController(vc)
    }
    
    // MARK: - Action
    @objc func createFolderBtnClick(sender: YXSButton) {
        let view = YXSInputAlertView2.showIn(target: self.view) { [weak self](result, btn) in
            guard let weakSelf = self else {return}
            
            if weakSelf.classId == nil {
                YXSSatchelCreateFolderRequest(folderName: result, parentFolderId: weakSelf.parentFolderId).request({ [weak self](json) in
                    guard let weakSelf = self else {return}
                    if btn.titleLabel?.text == "创建" {
                        weakSelf.loadData()
                    }
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
                
            } else {
                YXSFileCreateFolderRequest(classId: weakSelf.classId ?? 0, folderName: result, parentId: weakSelf.parentFolderId).request({ [weak self](json) in
                    guard let weakSelf = self else {return}
                    if btn.titleLabel?.text == "创建" {
                        weakSelf.loadData()
                    }
                    
                }) { (msg, code) in
                    MBProgressHUD.yxs_showMessage(message: msg)
                }
            }
            

        }
        view.lbTitle.text = "创建文件夹"
        view.tfInput.placeholder = "请输入文件夹名称"
        view.btnDone.setTitle("创建", for: .normal)
        view.btnCancel.setTitle("取消", for: .normal)
    }
    
    @objc func moveBtnClick(sender: YXSButton) {
        
        if classId == nil {
            YXSSatchelBatchMoveRequest(folderIdList: selectedFolderList, fileIdList: selectedFileIdList, oldParentFolderId: oldParentFolderId, parentFolderId: parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                if json.stringValue.count > 0 {
                    MBProgressHUD.yxs_showMessage(message: json.stringValue)
                    weakSelf.dismiss(animated: true, completion: nil)
                    
                } else {
                    weakSelf.completionHandler?(weakSelf.oldParentFolderId, weakSelf.parentFolderId)
                    weakSelf.dismiss(animated: true, completion: nil)
                }

            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
            
        } else {
            YXSFileBatchMoveRequest(classId: classId ?? 0, folderIdList: selectedFolderList, fileIdList: selectedFileIdList, oldParentFolderId: oldParentFolderId, parentFolderId: parentFolderId).request({ [weak self](json) in
                guard let weakSelf = self else {return}
                if json.stringValue.count > 0 {
                    MBProgressHUD.yxs_showMessage(message: json.stringValue)
                    weakSelf.dismiss(animated: true, completion: nil)
                    
                } else {
                    weakSelf.completionHandler?(weakSelf.oldParentFolderId, weakSelf.parentFolderId)
                    weakSelf.dismiss(animated: true, completion: nil)
                }
                
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        }
    }
    
    
    
    // MARK: - LazyLoad
    lazy var bottomView: SLMoveToBottomView = {
        let view = SLMoveToBottomView()
        view.btnFirst.addTarget(self, action: #selector(createFolderBtnClick(sender:)), for: .touchUpInside)
        view.btnSecond.addTarget(self, action: #selector(moveBtnClick(sender:)), for: .touchUpInside)
        return view
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class SLMoveToBottomView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF)
        addSubview(btnFirst)
        addSubview(btnSecond)
        
        btnFirst.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(40)
            make.left.equalTo(15)
            make.right.equalTo(snp_centerX).offset(-7.5)
        })

        btnSecond.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(40)
            make.left.equalTo(snp_centerX).offset(7.5)
            make.right.equalTo(-15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var btnFirst: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("创建文件夹", for: .normal)
        btn.setTitleColor(kNight5E88F7, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.backgroundColor = kNightFFFFFF
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20
        btn.borderWidth = 0.5
        btn.borderColor = kNight5E88F7
        return btn
    }()
    
    lazy var btnSecond: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("移动", for: .normal)
        btn.setTitleColor(kNightFFFFFF, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.backgroundColor = kNight5E88F7
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20
        return btn
    }()
}
