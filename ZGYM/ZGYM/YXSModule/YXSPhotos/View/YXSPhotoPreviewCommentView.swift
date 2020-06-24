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
    
    ///回复的那条评论id
    var replyId: Int?
    
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
            make.height.equalTo(37)
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
                strongSelf.lbTitle.text = "评论(\(strongSelf.dataSource.count))"
                strongSelf.updateCountBlock?(strongSelf.dataSource.count)
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
        
        YXSEducationAlbumCommentRequest(albumId: albumId, classId: classId, resourceId: resourceId, type: replyId == nil ? "COMMENT" : "REPLY", content: self.tf.text ?? "", id: replyId).request({ [weak self](result: YXSPhotoPreviewCommentModel) in
            guard let weakSelf = self else {return}
            weakSelf.dataSource.append(result)
            weakSelf.tbView.reloadData()
            weakSelf.tbView.scrollToRow(at: IndexPath.init(row: weakSelf.dataSource.count - 1 , section: 0), at: .bottom, animated: false)
            weakSelf.tf.text = ""
            if let _ = weakSelf.replyId{
                MBProgressHUD.yxs_showMessage(message: "回复成功")
            }else{
                MBProgressHUD.yxs_showMessage(message: "评论成功")
            }
            weakSelf.replyId = nil
            
            weakSelf.cleanTextView()
            weakSelf.lbTitle.text = "评论(\(weakSelf.dataSource.count))"
            weakSelf.updateCountBlock?(weakSelf.dataSource.count)
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - private
    func cleanTextView(){
        replyId = nil
        self.endEditing(true)
        self.tf.text = ""
        self.tf.placeholder = "评论"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cleanTextView()
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
        cell.replyClickBlock = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.replyId = model.id
            strongSelf.tf.text = ""
            strongSelf.tf.becomeFirstResponder()
            var nameText = model.userName ?? ""
            if model.userType == PersonRole.PARENT.rawValue{
                nameText = nameText.components(separatedBy: "&").last ?? ""
            }
            strongSelf.tf.placeholder = "回复\(nameText)："
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cleanTextView()
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
        textView.placeholderColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#1D1D1D")
        textView.textContainerInset = UIEdgeInsets.init(top: 11, left: 10.5, bottom: 0, right: 10)
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
    var replyClickBlock: (()->())?
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
            make.top.equalTo(lbDate.snp_bottom).offset(19)
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
            if let model = model{
                var placeholderImage = kImageUserIconTeacherDefualtImage
                if model.userType == PersonRole.PARENT.rawValue {
                    placeholderImage = kImageUserIconPartentDefualtImage
                }
                imgAvatar.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: placeholderImage)
                lbDate.text = Date.yxs_Time(date: Date.init(timeIntervalSince1970: TimeInterval(model.createTime ?? 0)))
                lbContent.text = model.content ?? ""
                delectButton.isHidden = !model.isMyPublish
                
                var nameText = model.userName ?? ""
                if model.isMyPublish{
                    nameText = "我"
                }else if model.userType == PersonRole.PARENT.rawValue{
                    nameText = nameText.components(separatedBy: "&").last ?? ""
                }
                
                
                if let reUserId = model.reUserId{
                    var replyNameText: String = model.reUserName ?? ""
                    if reUserId ==  self.yxs_user.id && model.reUserType == self.yxs_user.type{
                        replyNameText = "我"
                    }
                    UIUtil.yxs_setLabelAttributed(lbTitle, text: [nameText,"回复", replyNameText], colors: [UIColor.white,kBlueColor,UIColor.white])
                }else{
                    lbTitle.text = nameText
                }
                
                
                lbTitle.snp.remakeConstraints({ (make) in
                    make.top.equalTo(imgAvatar.snp_top).offset(0)
                    make.left.equalTo(imgAvatar.snp_right).offset(13)
                    make.right.equalTo(model.isMyPublish ? -45 : -10)
                })

            }
            
        }
    }
    
    @objc func delectClick(){
        delectClickBlock?()
    }
    
    @objc func replyContent(){
        if model?.isMyPublish ?? false{
            return
        }
        replyClickBlock?()
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
        lb.numberOfLines = 0
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
        lb.isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(replyContent))
        lb.addGestureRecognizer(tap)
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
