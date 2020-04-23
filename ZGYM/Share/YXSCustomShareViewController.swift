//
//  SLCustomShareViewController.swift
//  Share
//
//  Created by Liu Jie on 2020/3/21.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import SnapKit
import MobileCoreServices

class YXSCustomShareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listUrl: [URL] = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        
        shareExtension_LoadDataSource { [weak self](list) in
            guard let weakSelf = self else {return}
            
            if !list.isEmpty {
                weakSelf.listUrl = list
            }
        }
    }
    
    @objc func createUI() {
    
        self.view.addSubview(panelView)
        
        self.panelView.addSubview(imgThumbnail)
        self.panelView.addSubview(lbTitle)
        self.panelView.addSubview(tableView)
        self.panelView.addSubview(btnCancel)
        
        tableView.register(ShareTableViewCell.classForCoder(), forCellReuseIdentifier: "ShareTableViewCell")
        
        panelView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(view.snp.centerY)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        })
        
        imgThumbnail.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(60)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(imgThumbnail.snp.bottom).offset(5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp.bottom).offset(5)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.height.equalTo(180)
        })
        
        btnCancel.snp.makeConstraints({ (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(50)
        })
    }
    
    // MARK: - Action
    @objc func cancelClick(sender: UIButton) {
        shareExtension_Cancel()
    }
    
    @objc func saveAction() {
        
        /// 写入存储
        var filesName = [String]()
        for sub in listUrl {
            let lstCompon = sub.lastPathComponent
            let fullPath = YXSFileManagerHelper.sharedInstance.getFullPathURL(lastPathComponent: lstCompon)
            let data: Data
            do {
                data = try Data(contentsOf: sub)
                let size = YXSFileManagerHelper.sharedInstance.sizeOfDataSrouce(data: data)
                if size < maxFileSize {
                    try data.write(to: fullPath)
                    filesName.append(lstCompon)
                }
                
            } catch {
            }
            
            print("保存文件路径：\(fullPath)")
        }
        
        let tmp = filesName.joined(separator: ",")
        /// 打开主APP
        shareExtension_OpenContainerApp(filesName: tmp)
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShareTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell") as! ShareTableViewCell
        cell.lbTitle.text = dataSource[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveAction()
    }
    
    // MARK: - LazyLoad
    lazy var panelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var imgThumbnail: UIImageView = {
        let img = UIImageView()
        return img
    }()

    lazy var lbTitle: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.separatorStyle = .none
        tbv.bounces = false
        tbv.delegate = self
        tbv.dataSource = self
        return tbv
    }()
    
    lazy var btnCancel: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var dataSource: NSArray = {
//        return ["用私聊发送", "添加到我的书包", "添加到班级文件"]
        return ["添加到我的书包"]
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
