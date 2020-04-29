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
                
                let firstUrl = list.first
                let arr = firstUrl?.lastPathComponent.components(separatedBy: ".")
                let fileName = arr?.first
                let extName = arr?.last?.lowercased()
                let fullName = "\(fileName ?? "").\(extName ?? "")"
                weakSelf.lbTitle.text = fullName
                
                if let url = firstUrl {
                    if let img = YXSFileManagerHelper.sharedInstance.getIconWithFileUrl(url) {
                        weakSelf.imgThumbnail.image = img
                        
                    } else {
                        if let url = firstUrl {
                            if let data = try? Data(contentsOf: url) {
                                if let img = UIImage(data: data) {
                                    
                                    let newImg = weakSelf.resizeImage(image: img, newSize: CGSize(width: 50.0, height: 50.0))
                                    weakSelf.imgThumbnail.image = newImg
                                }
                            }
                        }
                    }
                }
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
            make.left.equalTo(52)
            make.right.equalTo(-52)
        })
        
        imgThumbnail.snp.makeConstraints({ (make) in
            make.top.equalTo(29)
            make.centerX.equalTo(panelView.snp_centerX)
            make.width.height.equalTo(50)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(imgThumbnail.snp.bottom).offset(12)
            make.left.equalTo(22)
            make.right.equalTo(-22)
        })
        
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp.bottom).offset(25)
            make.left.equalTo(lbTitle.snp_left).offset(0)
            make.right.equalTo(lbTitle.snp_right).offset(0)
            make.height.equalTo(80)
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
    
    @objc func saveAction(index:Int) {
        
        /// 写入存储
        var filesName = [String]()
        for sub in listUrl {
            let lstCompon = sub.lastPathComponent
            let fullPath = YXSFileManagerHelper.sharedInstance.getFullPathURL(lastPathComponent: lstCompon)
            let data: Data
            do {
                data = try Data(contentsOf: sub)
                let size = YXSFileManagerHelper.sharedInstance.sizeMbOfDataSrouce(data: data)
                if size < maxFileSize {
                    try data.write(to: fullPath)
                    filesName.append(lstCompon)
                }
                
            } catch {
            }
            
            print("保存文件路径：\(fullPath)")
        }
        
        let tmp = filesName.joined(separator: ",")
        let type = index == 0 ? "satchel" : "class"
        let dic = ["type":type, "files":tmp]
        
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8) ?? ""
        
        /// 打开主APP
        shareExtension_OpenContainerApp(filesName: str)
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
        saveAction(index: indexPath.row)
    }
    
    // MARK: - Other
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: - LazyLoad
    lazy var panelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var imgThumbnail: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        return img
    }()

    lazy var lbTitle: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.textAlignment = .center
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#000000")
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.separatorStyle = .none
        tbv.bounces = false
        tbv.delegate = self
        tbv.dataSource = self
        tbv.backgroundColor = UIColor.white
        return tbv
    }()
    
    lazy var btnCancel: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var dataSource: NSArray = {
        return ["添加到我的文件", "添加到班级文件"]
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
