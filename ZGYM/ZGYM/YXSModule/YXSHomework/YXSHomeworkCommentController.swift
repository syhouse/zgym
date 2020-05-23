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
    var remarkGood: Int = 0
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
        remarkGood = myReviewModel?.isGood ?? 0
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
        contentView.addSubview(goodControl)
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
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(180)
        })
        
        voiceView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp_bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        btnVoice.snp.makeConstraints({ (make) in
            make.top.equalTo(textView.snp_bottom).offset(15)
            make.left.equalTo(15)
            make.height.width.equalTo(29)
        })
        
        goodControl.snp.makeConstraints { (make) in
            make.left.equalTo(btnVoice.snp_right).offset(15)
            make.centerY.equalTo(btnVoice)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
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
        goodControl.isSelected = (remarkGood == 1 ? true : false)
        initPublish()
    }
    
    func initPublish() {
        if isChangeRemark {
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
        goodControl.isSelected = (remarkGood == 1 ? true : false)
        if self.audioModel == nil {
            voiceView.isHidden = true
            btnVoice.isEnabled = true
            btnVoice.snp.remakeConstraints({ (make) in
                make.top.equalTo(textView.snp_bottom).offset(15)
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
    
    @objc func goodControlClick() {
        goodControl.isSelected = !goodControl.isSelected
        remarkGood = goodControl.isSelected ? 1 : 0
//        goodClick?(self.model!)
//        finishView.isHidden = !goodControl.isSelected
    }
    
    @objc func sendClick(sender: YXSButton) {//发送点评
        sender.isEnabled = false
        if self.textView.text.count < 1 {
            sender.isEnabled = true
            return
        }
        if isChangeRemark {
            if !isModify {
                if myReviewModel?.isGood != remarkGood {
                    YXSEducationHomeworkInTeacherChangeGoodRequest.init(childrenId: self.myReviewModel?.childrenId ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "", homeworkId: self.homeModel?.serviceId ?? 0, isGood: remarkGood).request({ (result) in
                        if (self.commetCallBack != nil) {
                            self.commetCallBack!(self.childrenIdList)
                        }
                        
                    }) { (msg, code) in
                        MBProgressHUD.yxs_showMessage(message: msg)
                        sender.isEnabled = true
                    }
                }
                self.navigationController?.popViewController()
                return
            }
        }
//        if isChangeRemark && !isModify{
//            self.navigationController?.popViewController()
//            return
//        }
        MBProgressHUD.yxs_showLoading()
        if self.audioModel != nil && self.audioModel.servicePath?.count ?? 0 <= 0{
            YXSUploadSourceHelper().uploadAudio(mediaModel: audioModel, storageType: YXSStorageType.temporary, sucess: { (url) in
                MBProgressHUD.yxs_hideHUD()
                self.remarkAudioDuration = self.audioModel.time
                self.remarkAudioUrl = url;
                sender.isEnabled = true
                self.commitCommet()
            }) { (msg, code) in
                MBProgressHUD.yxs_showMessage(message: msg)
                sender.isEnabled = true
            }
                    
        }else {
            sender.isEnabled = true
            commitCommet()
        }
        

       
    }
    
    
    @objc func voiceClick(sender: YXSButton) {//语音
        textView.resignFirstResponder()
       showAudio()
    }
    
    func commitCommet(){
        MBProgressHUD.yxs_showLoading()
        if isChangeRemark {
            //修改点评
            YXSEducationHomeworkRemarkUpdate(homeworkId: self.homeModel?.serviceId ?? 0, remark: self.textView.text, childrenId: self.myReviewModel?.childrenId ?? 0, remarkAudioUrl: self.remarkAudioUrl ?? "", remarkAudioDuration: self.remarkAudioDuration ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "",isGood: self.remarkGood).request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "修改点评成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    if (self.commetCallBack != nil) {
                        self.commetCallBack?(self.childrenIdList)
                    }
                    if self.isPop == true {
                        self.navigationController?.popViewController()
                    }else {
                        self.navigationController?.popViewController()
                    }
                }
            }) { (msg, code) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: msg)
            }
        } else {
            YXSEducationHomeworkBatchRemark(homeworkId: self.homeModel?.serviceId ?? 0, remark: self.textView.text, childrenIdList: self.childrenIdList, remarkAudioUrl: self.remarkAudioUrl ?? "", remarkAudioDuration: self.remarkAudioDuration ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "",isGood: self.remarkGood).request({ (json) in
                MBProgressHUD.yxs_hideHUD()
                MBProgressHUD.yxs_showMessage(message: "点评成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    if (self.commetCallBack != nil) {
                        self.commetCallBack?(self.childrenIdList)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kTeacherRemarkSucessNotification), object: [kValueKey: YXSHomeType.homework])
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
                MBProgressHUD.yxs_hideHUD()
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
        cell.textLabel?.numberOfLines = 0
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
//        let paragraphStye = NSMutableParagraphStyle()
//        paragraphStye.lineSpacing = kMainContentLineHeight
//        paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
//        let dic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.paragraphStyle:paragraphStye]
//        self.textView.attributedText = NSMutableAttributedString.init(string: title, attributes: dic)
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
    
//    lazy var textView: UITextView = {
//            let tv = UITextView()
//            tv.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
////            tv.limitCount = 200
////            tv.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: -17, right: 17)
//    //        tv.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
//            tv.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)
////            tv.placeholderColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
////            tv.placeholder = "请输入评语或添加语音"
////            tv.textDidChangeBlock = { (str)in
////                if str != self.remarkContent {
////                    self.isModify = true
////                }
////            }
//            tv.font = UIFont.systemFont(ofSize: 15)
//            return tv
//        }()
    
    lazy var textView: YXSPlaceholderTextView = {
        let tv = YXSPlaceholderTextView()
        tv.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
        tv.limitCount = 200
//        tv.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: -17, right: 17)
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
            strongSelf.textView.resignFirstResponder()
            strongSelf.showAudio(strongSelf.audioModel)
            }, delectHandler: {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.removeAudio()
                strongSelf.isModify = true
            }, showDelect: true)
        voiceView.tapPlayer = false
        return voiceView
    }()

    lazy var goodControl: YXSCustomImageControl = {
        let goodControl = YXSCustomImageControl.init(imageSize: CGSize.init(width: 16, height: 19), position: YXSImagePositionType.left, padding: 5)
        goodControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), for: .normal)
        goodControl.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#C92B1E"), for: .selected)
        goodControl.setTitle("设为优秀", for: .normal)
        goodControl.setTitle("取消优秀", for: .selected)
        goodControl.font = UIFont.systemFont(ofSize: 15)
        goodControl.setImage(UIImage.init(named: "yxs_punch_good_gray"), for: .normal)
        goodControl.setImage(UIImage.init(named: "yxs_punch_good_select"), for: .selected)
        goodControl.isSelected = false
        goodControl.addTarget(self, action: #selector(goodControlClick), for: .touchUpInside)
        return goodControl
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
        let arr = ["只有爱动脑筋的孩子才会有这么精彩的表现!",
                   "知道吗，最近你的进步可真大哦!",
                   "你的解题思路很奇妙!",
                   "你是个爱动脑，会提问的好孩子，掌声送给你!",
                   "聪明肯学，人见人爱，加油!", "你是个好学的学生，作业做的很棒哦!",
                   "继续努力，你很有潜力!",
                   "勤能补拙，从你的作业中我感觉到了你的努力与上进，加油!",
                   "老师喜欢你的认真劲儿。",
                   "这么端正的作业一定下了很大的功夫，不错!",
                   "你的作业由灰姑娘变成了漂亮的公主了~",
                   "没有最好只有更好，相信你就是那个更好的你!",
                   "深受老师喜欢的你进步可真快，要继续噢!",
                   "从容面对失败，就有超越自己的底气!",
                   "你在努力老师能感觉得到~",
                   "你的字迹工整，书写认真，作业看上去非常整洁。老师要给你一个大大的赞，看上去很赏心悦目哦。",
                   "你的作业任何时候看起来都像拓印的书卷一样漂亮，长期练字的习惯，让你的字体看起来横平竖直，遒劲有力。继续加油哦！",
                   "你的字和你的人一样，看起来特别有精神！字体方正，大方得体，运笔稳中有变化，看你的作业，是一种享受！",
                   "你的作业看起来就像小鸭子的脚掌—小梅花被印在了作业本上，虽然生动可爱，但是要注意作业书写的工整，写字不要歪歪扭扭哦！",
                   "你的书写非常漂亮！而且注意了露锋和收笔，这样字看起来骨骼丰满有力。这一定是你长期刻苦练习的结果！希望你继续坚持哦！",
                   "每次你的作业都书写得一笔一划，工整漂亮。值得表扬。而且老师特别欣赏你写字时专注，入神的样子。小背挺得直直的，姿势非常端正，优美。",
                   "你是一个聪明又思维敏捷的孩子，但是注意写作业的时候，不要一味地追求速度，字迹太过潦草。期待你越来越优秀哦！",
                   "作业非常不错，字迹工整清秀，而且注意了运笔，收笔就像凤尾一样饱满！老师想说你真是太棒了，希望你能给我更大的惊喜！",
                   "练字需要持之以恒，认真的书写能让你更加沉稳，希望你多多练习，书写更上一层楼哦。",
                   "你写字非常用心，整齐又清秀，可以试试多进行起笔和落笔位置的练习和模仿，这样你的书写会更加大气，看起来更加舒展和有力哦！"]
        
        return arr
    }()
    
    var audioModel: SLAudioModel!
    //缓存文件类型
    var sourceDirectory = YXSCacheDirectory.HomeWork
    
    var remarkAudioDuration: Int!
    var remarkAudioUrl: String!
    
    
    
    // MARK: - Setter
    var childrenIdList: [Int] = [Int]()
    

//    var homeModel1:YXSHomeListModel? {
//        didSet {
//
//        }
//    }
    var isPop: Bool! {
        didSet {
            
        }
    }
    
    var commetCallBack:((_ childreIdList: [Int]) -> ())?
    
//    // 是否有录音资源展示
//    private var isShowAudio: Bool
    
}
