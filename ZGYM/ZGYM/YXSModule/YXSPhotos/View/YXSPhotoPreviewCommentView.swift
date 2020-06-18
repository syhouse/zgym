//
//  YXSPhotoPreviewCommentView.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/6/1.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
/// 图片预览 底部评论框
class YXSPhotoPreviewCommentView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let albumId: Int
    let classId: Int
    var resourceId: Int = 0
    
    var dataSource: [YXSPhotoPreviewCommentModel] = [YXSPhotoPreviewCommentModel]()
    
    
    var commentLists: [Int: [YXSPhotoPreviewCommentModel]] = [Int: [YXSPhotoPreviewCommentModel]]()
    var updateCountBlock: ((_ curruntCount: Int)->())?
    
    init(albumId: Int, classId: Int) {
        self.albumId = albumId
        self.classId = classId
        super.init(frame: CGRect.zero)
        
        tbView.register(YXSPhotoPreviewCommentCell.classForCoder(), forCellReuseIdentifier: "YXSPhotoPreviewCommentCell")
        
        self.addSubview(self.lbTitle)
        self.addSubview(self.tbView)
        self.addSubview(self.btnSend)
        self.addSubview(self.tf)
        
        self.lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(snp_top)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(58)
        })
        lbTitle.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#434343"))
        
        self.tbView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(270)
        })
        
        self.tf.snp.makeConstraints({ (make) in
            make.top.equalTo(tbView.snp_bottom).offset(14)
            make.left.equalTo(14)
            make.bottom.equalTo(-14)
            make.height.equalTo(44)
        })
        
        self.btnSend.snp.makeConstraints({ (make) in
            make.left.equalTo(self.tf.snp_right).offset(6)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.tf.snp_centerY)
            make.width.equalTo(62)
            make.height.equalTo(38)
            
        })
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.greetingTextFieldChanged),
                                               name:NSNotification.Name(rawValue:"UITextFieldTextDidChangeNotification"),
                                               object: self.tf)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Request
    @objc func loadData() {
        YXSEducationAlbumQueryCommentListRequest(albumId: albumId, classId: classId, resourceId: resourceId).requestCollection({ [weak self](list:[YXSPhotoPreviewCommentModel]) in
            guard let weakSelf = self else {return}
            weakSelf.dataSource = list
            weakSelf.lbTitle.text = "评论(\(list.count))"
            weakSelf.tbView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    func delectRequset(commentId: Int){
        YXSCommonAlertView.showAlert(title: "是否撤销该条评论？", rightClick: {
            [weak self] in
            guard let strongSelf = self else { return }
            MBProgressHUD.yxs_showLoading()
            YXSEducationAlbumDeleteCommentRequest.init(albumId: strongSelf.albumId, classId: strongSelf.classId, resourceId: strongSelf.resourceId, id: commentId).request({ (result) in
                MBProgressHUD.yxs_showMessage(message: "撤销成功")
                strongSelf.dataSource.removeAll { (model) -> Bool in
                    model.id == commentId
                }
                strongSelf.tbView.reloadData()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        })
        
    }
    
    func reloadData(){
        if let list = commentLists[resourceId]{
            dataSource = list
        }else{
            dataSource = [YXSPhotoPreviewCommentModel]()
        }
        loadData()
        self.lbTitle.text = "评论(\(dataSource.count))"
        self.tbView.reloadData()
    }
    
    // MARK: - Action
    @objc func greetingTextFieldChanged(obj:Notification) {
        self.greetingTextFieldChanged(obj: obj, length: 100)
    }
    
    @objc func sendClick(sender: YXSButton) {
        if self.tf.text.isEmpty{
            MBProgressHUD.yxs_showMessage(message: "评论不能为空")
            return
        }
        
        YXSEducationAlbumCommentRequest(albumId: albumId, classId: classId, resourceId: resourceId, content: self.tf.text ?? "", id: 1).request({ [weak self](result: YXSPhotoPreviewCommentModel) in
            guard let weakSelf = self else {return}
            weakSelf.dataSource.append(result)
            weakSelf.tbView.reloadData()
            weakSelf.tf.text = ""
            MBProgressHUD.yxs_showMessage(message: "评论成功")
            weakSelf.endEditing(true)
            weakSelf.lbTitle.text = "评论(\(weakSelf.dataSource.count))"
            weakSelf.updateCountBlock?(weakSelf.dataSource.count)
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YXSPhotoPreviewCommentCell = tableView.dequeueReusableCell(withIdentifier: "YXSPhotoPreviewCommentCell") as! YXSPhotoPreviewCommentCell
        let model = dataSource[indexPath.row]
        cell.model = model
        cell.delectClickBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delectRequset(commentId: model.id ?? 0)
        }
        return cell
    }
    
    
    // MARK: - LazyLoad
    lazy var lbTitle: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.text = "评论(0)"
        return lb
    }()
    
    lazy var tbView: UITableView = {
        let tb = UITableView()
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor.clear
        
        tb.delegate = self
        tb.dataSource = self
        
        return tb
    }()
    
    lazy var tf: YXSPlaceholderTextView = {
        let textView = YXSPlaceholderTextView()
        textView.placeholder = "评论"
        textView.font = kTextMainBodyFont
        textView.placeholderColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        textView.textColor = kTextMainBodyColor
        textView.backgroundColor = UIColor.white
        textView.contentInset = UIEdgeInsets.init(top: 5, left: 10, bottom: 0, right: 10)
        textView.cornerRadius = 3
        textView.limitCount = 100
        textView.inputAccessoryView = nil
        return textView
    }()
    
    
    lazy var btnSend: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("发送", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#4E88FF")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(sendClick(sender:)), for: .touchUpInside)
        return btn
    }()
}

// MARK: - 评论Cell
class YXSPhotoPreviewCommentCell: UITableViewCell {
    
    var delectClickBlock: (()->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(imgAvatar)
        contentView.addSubview(lbTitle)
        contentView.addSubview(lbDate)
        contentView.addSubview(lbContent)
        
        imgAvatar.snp.makeConstraints({ (make) in
            make.top.equalTo(25)
            make.left.equalTo(15)
            make.width.height.equalTo(40)
        })
        
        lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(imgAvatar.snp_top).offset(0)
            make.left.equalTo(imgAvatar.snp_right).offset(13)
            make.right.equalTo(-10)
        })
        
        lbDate.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle.snp_bottom).offset(6)
            make.left.equalTo(lbTitle.snp_left)
            make.right.equalTo(lbTitle.snp_right)
        })
        
        lbContent.snp.makeConstraints({ (make) in
            make.top.equalTo(imgAvatar.snp_bottom).offset(17)
            make.left.equalTo(imgAvatar.snp_right).offset(12)
            make.right.equalTo(-15)
            make.bottom.equalTo(-20)
        })
        
        contentView.addSubview(delectButton)
        delectButton.snp.makeConstraints({ (make) in
            make.centerY.equalTo(imgAvatar)
            make.right.equalTo(-8)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
    var model: YXSPhotoPreviewCommentModel? {
        didSet {
            imgAvatar.sd_setImage(with: URL(string: self.model?.avatar ?? ""), placeholderImage: UIImage(named: "defultImage"))
            lbTitle.text = self.model?.userName
            lbDate.text = "\(self.model?.createTime ?? 0)".yxs_DayTime()
            lbContent.text = self.model?.content ?? ""
            delectButton.isHidden = !(model?.isMyPublish ?? false)
        }
    }
    
    @objc func delectClick(){
        delectClickBlock?()
    }
    
    // MARK: - LazyLoad
    lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "defultImage")
        img.cornerRadius = 20.0
        return img
    }()
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "王梓豪爸爸"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    
    lazy var lbDate: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "昨天 15:30"
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var lbContent: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "孩子们玩的真欢乐！孩子们玩的真欢乐！孩子们玩的真欢乐！孩子们玩的真欢乐！孩子们玩的真欢乐！孩子们玩的真欢乐！"
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var delectButton: YXSButton = {
        let button = YXSButton()
        button.setImage(UIImage.init(named: "recall"), for: .normal)
         button.addTarget(self, action: #selector(delectClick), for: .touchUpInside)
        button.yxs_touchInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
}
