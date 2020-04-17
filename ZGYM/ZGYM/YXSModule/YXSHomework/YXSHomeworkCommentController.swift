//
//  YXSHomeworkCommentController.swift
//  ZGYM
//
//  Created by apple on 2020/2/24.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class YXSHomeworkCommentController: YXSBaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    var isChangeRemark: Bool = false
    var isModify: Bool = false
    var remarkContent: String = ""
    var remarkAudioModel: SLAudioModel = SLAudioModel()
    /// 修改点评model
    var myReviewModel: YXSHomeworkDetailModel?
    var homeModel:YXSHomeListModel?
    /// 老师修改点评使用
    /// - Parameter myReviewModel: 老师点评的作业model
    public func initChangeReview(myReviewModel: YXSHomeworkDetailModel?, model:YXSHomeListModel) {
        self.homeModel = model
        self.myReviewModel = myReviewModel
        remarkContent = myReviewModel!.remark!
        let audioModel = SLAudioModel()
        audioModel.servicePath = myReviewModel?.remarkAudioUrl
        audioModel.time = myReviewModel?.remarkAudioDuration ?? 0
        remarkAudioModel = audioModel
        isChangeRemark = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "点评作业"
        yxs_setupRightBarButtonItem()
        // Do any additional setup after loading the view.
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.view.addSubview(contentView)
        contentView.addSubview(textView)
        self.view.yxs_addLine(position: .top, color: kTableViewBackgroundColor, leftMargin: 0, rightMargin: 0, lineHeight: 10)
        self.tableView.backgroundColor = UIColor.clear
        
        contentView.addSubview(voiceView)
        voiceView.isHidden = true
        contentView.addSubview(btnVoice)
        contentView.addSubview(lbNote)
        contentView.addSubview(lbLine)
        
        contentView.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(440)
        })
        
        textView.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(200)
        })
        
        voiceView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp_bottom).offset(5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        btnVoice.snp.makeConstraints({ (make) in
            make.top.equalTo(textView.snp_bottom).offset(5)
            make.left.equalTo(15)
            make.height.width.equalTo(29)
        })
        
        lbNote.snp.makeConstraints({ (make) in
            make.top.equalTo(btnVoice.snp_top)
            make.right.equalTo(-15)
            make.height.equalTo(29)
            make.width.equalTo(100)
        })
        
        lbLine.snp.makeConstraints({ (make) in
            make.top.equalTo(btnVoice.snp_bottom).offset(9)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.left.equalTo(15)
        })
        contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(btnVoice.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(180)
        })
        
        initPublish()
    }
    
    func initPublish() {
        if myReviewModel !=  nil {
            textView.text = myReviewModel?.remark
            if let audioUrl = myReviewModel?.remarkAudioUrl, audioUrl.count != 0{
                let audioModel = SLAudioModel()
                audioModel.servicePath = audioUrl
                audioModel.time = myReviewModel?.remarkAudioDuration ?? 0
                self.audioModel = audioModel

                let vModel = YXSVoiceViewModel()
                vModel.voiceDuration = myReviewModel?.remarkAudioDuration ?? 0
                vModel.voiceUlr = audioUrl
                voiceView.model = vModel
                self.remarkAudioUrl = myReviewModel?.remarkAudioUrl
                self.remarkAudioDuration = myReviewModel?.remarkAudioDuration
            }
            self.updateUI()
        }
    }
    
    func updateUI() {
        if self.audioModel == nil {
            voiceView.isHidden = true
            btnVoice.isEnabled = true
            btnVoice.snp.remakeConstraints({ (make) in
                make.top.equalTo(textView.snp_bottom).offset(5)
                make.left.equalTo(15)
                make.height.width.equalTo(29)
            })
            contentView.snp.remakeConstraints({ (make) in
                make.top.equalTo(10)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(440)
            })
        }else {
            let vModel = YXSVoiceViewModel()
            vModel.voiceDuration = self.audioModel.time ?? 0
            vModel.voiceUlr = self.audioModel.path
            voiceView.model = vModel
            voiceView.isHidden = false
            btnVoice.isEnabled = false
            btnVoice.snp.remakeConstraints({ (make) in
                make.top.equalTo(voiceView.snp_bottom).offset(5)
                make.left.equalTo(15)
                make.height.width.equalTo(29)
            })
            contentView.snp.remakeConstraints({ (make) in
                make.top.equalTo(10)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(480)
            })
        }
    }
    
    func removeAudio(){
        self.audioModel = nil
        self.remarkAudioUrl = ""
        self.remarkAudioDuration = 0
        updateUI()
    }
    
    // MARK: -private
    func showAudio(_ model:SLAudioModel? = nil){
        let audioView = YXSRecordAudioView.showRecord(audio: model) { [weak self](audio) in
            guard let strongSelf = self else { return }
            if strongSelf.remarkAudioModel.servicePath != audio.servicePath {
                strongSelf.isModify = true
            }
            strongSelf.audioModel = audio
            strongSelf.updateUI()
        }
        audioView.sourceDirectory = self.sourceDirectory
    }
    
    @objc func sendClick(sender: YXSButton) {//发送点评
        if self.textView.text.count < 1 {
            return
        }
        if isChangeRemark && !isModify{
            self.navigationController?.popViewController()
            return
        }
        MBProgressHUD.yxs_showLoading()
        if self.audioModel != nil && self.audioModel.servicePath?.count ?? 0 <= 0{
            YXSUploadSourceHelper().uploadAudio(mediaModel: audioModel, sucess: { (url) in
                MBProgressHUD.yxs_hideHUD()
                self.remarkAudioDuration = self.audioModel.time
                self.remarkAudioUrl = url;
                self.commitCommet()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
                    
        }else {
            commitCommet()
        }
        

       
    }
    
    
    @objc func voiceClick(sender: YXSButton) {//语音
       showAudio()
    }
    
    func commitCommet(){
        MBProgressHUD.yxs_showLoading()
        if myReviewModel != nil {
            //修改点评
            YXSEducationHomeworkRemarkUpdate(homeworkId: self.homeModel?.serviceId ?? 0, remark: self.textView.text, childrenId: self.myReviewModel?.childrenId ?? 0, remarkAudioUrl: self.remarkAudioUrl ?? "", remarkAudioDuration: self.remarkAudioDuration ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "").request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "修改点评成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    if (self.commetCallBack != nil) {
                        self.commetCallBack!()
                    }
                    if self.isPop == true {
                        self.navigationController?.popViewController()
                    }else {
                        self.navigationController?.popViewController()
                    }
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        } else {
            YXSEducationHomeworkBatchRemark(homeworkId: self.homeModel?.serviceId ?? 0, remark: self.textView.text, childrenIdList: self.childrenIdList, remarkAudioUrl: self.remarkAudioUrl ?? "", remarkAudioDuration: self.remarkAudioDuration ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "").request({ (json) in
                        MBProgressHUD.yxs_hideHUD()
                        MBProgressHUD.yxs_showMessage(message: "点评成功")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                            if (self.commetCallBack != nil) {
                                self.commetCallBack!()
                            }
                            if self.isPop == true {
                                self.navigationController?.popViewController()
                            }else {
            //                    let vc  = YXSHomeworkCommitListViewController()
            //                    self.navigationController?.popToViewController(vc, animated: true)
                                for  vc in self.navigationController!.viewControllers{
                                    if vc is YXSHomeworkDetailViewController{
                                        let popVc = vc as! YXSHomeworkDetailViewController
                                        popVc.refreshData()
                                        self.navigationController?.popToViewController(popVc, animated: true)
                                        return
                                    }else{
                                         self.navigationController?.popViewController()
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }, failureHandler: { (msg, code) in
                        MBProgressHUD.yxs_showMessage(message: msg)
                    })
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = self.dataSource[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = title
        cell.textLabel?.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0xFFFFFF)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.dataSource[indexPath.row]
        if title != remarkContent {
            self.isModify = true
        }
        self.textView.text = title
    }
    
    
    func yxs_setupRightBarButtonItem() {

        let btnSend = YXSButton(frame: CGRect(x: 0, y: 0, width: 60, height: 26))
        btnSend.setTitle("发送", for: .normal)
        btnSend.setMixedTitleColor(MixedColor(normal: 0xFFFFFF, night: 0xFFFFFF), forState: .normal)
        btnSend.mixedBackgroundColor = MixedColor(normal: 0x5E88F7, night: 0x5E88F7)
        btnSend.clipsToBounds = true
        btnSend.cornerRadius = 12.5
        btnSend.addTarget(self, action: #selector(sendClick(sender:)), for: .touchUpInside)
        let navSendItem = UIBarButtonItem(customView: btnSend)
        self.navigationItem.rightBarButtonItem = navSendItem
            
        }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
        return view
    }()
    
    lazy var textView: YXSPlaceholderTextView = {
        let tv = YXSPlaceholderTextView()
        tv.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
        tv.limitCount = 200
        tv.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: -17, right: 17)
//        tv.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        tv.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)
        tv.placeholderColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        tv.placeholder = "请输入评语或添加语音"
        tv.textDidChangeBlock = { (str)in
            if str != self.remarkContent {
                self.isModify = true
            }
        }
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
    
 
    lazy var btnVoice: YXSButton = {
        let btn = YXSButton()
        btn.setMixedImage(MixedImage(normal: "yxs_publish_audio", night: "yxs_publish_audio"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_publish_audio_gray", night: "yxs_publish_audio_gray"), forState: .disabled)
        btn.addTarget(self, action: #selector(voiceClick(sender:)), for: .touchUpInside)
        return btn
    }()

    lazy var lbNote: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0xC4CDDA, night: 0xC4CDDA)
        lb.text = "200字内"
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textAlignment = NSTextAlignment.right
        return lb
    }()
    
    lazy var voiceView: YXSVoiceView = {
        let voiceView = YXSVoiceView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 36), complete: {
            [weak self](url, duration) in
            guard let strongSelf = self else { return }
            strongSelf.showAudio(strongSelf.audioModel)
            }, delectHandler: {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.removeAudio()
                strongSelf.isModify = true
            }, showDelect: true)
        voiceView.minWidth = 120
        voiceView.tapPlayer = false
        return voiceView
    }()

    lazy var lbLine: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedBackgroundColor = MixedColor(normal: 0xE6EAF3, night: 0x20232F)
        return lb
    }()
    
    lazy var tableView: YXSTableView = {
        let tableView = YXSTableView(frame:self.view.frame, style:.plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var dataSource: [String] = {
//        let arr = ["作业完成很棒，继续保持！","作业完成良好，继续加油！","作业完成合格，继续加油！","作业完成一般，再接再厉！"]
        let arr = ["只有爱动脑筋的孩子才会有这么精彩的表现!", "知道吗，最近你的进步可真大哦!", "你的解题思路很奇妙!", "你是个爱动脑，会提问的好孩子，掌声送给你!", "聪明肯学，人见人爱，加油!", "你是个好学的学生，作业做的很棒哦!", "继续努力，你很有潜力!", "勤能补拙，从你的作业中我感觉到了你的努力与上进，加油!", "老师喜欢你的认真劲儿。", "这么端正的作业一定下了很大的功夫，不错!", "你的作业由灰姑娘变成了漂亮的公主了~", "没有最好只有更好，相信你就是那个更好的你!", "深受老师喜欢的你进步可真快，要继续噢!", "从容面对失败，就有超越自己的底气。", "你在努力老师能感觉得到~"]
        return arr
    }()
    
    var audioModel: SLAudioModel!
    //缓存文件类型
    var sourceDirectory = YXSCacheDirectory.HomeWork
    
    var remarkAudioDuration: Int!
    var remarkAudioUrl: String!
    
    
    
    // MARK: - Setter
    var childrenIdList: [Int]! {
        didSet {
        }
    }
    

//    var homeModel1:YXSHomeListModel? {
//        didSet {
//
//        }
//    }
    var isPop: Bool! {
        didSet {
            
        }
    }
    
    var commetCallBack:(() -> ())?
    
//    // 是否有录音资源展示
//    private var isShowAudio: Bool
    
}
