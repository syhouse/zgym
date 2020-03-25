//
//  SLHomeworkCommentController.swift
//  ZGYM
//
//  Created by apple on 2020/2/24.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

class SLHomeworkCommentController: SLBaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "点评作业"
        sl_setupRightBarButtonItem()
        // Do any additional setup after loading the view.
        self.view.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        self.view.addSubview(contentView)
        contentView.addSubview(textView)
        self.view.sl_addLine(position: .top, color: kTableViewBackgroundColor, leftMargin: 0, rightMargin: 0, lineHeight: 10)
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
        
      
    }
    
    func updateUI() {
        if self.audioModel == nil {
            voiceView.isHidden = true
            btnVoice.isEnabled = true
            btnVoice.snp.remakeConstraints({ (make) in
                make.top.equalTo(textView.snp_bottom).offset(5)
                make.left.equalTo(15)
            })
            contentView.snp.remakeConstraints({ (make) in
                make.top.equalTo(10)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(440)
            })
        }else {
            voiceView.isHidden = false
            btnVoice.isEnabled = false
            btnVoice.snp.remakeConstraints({ (make) in
                make.top.equalTo(voiceView.snp_bottom).offset(5)
                make.left.equalTo(15)
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
        self.remarkAudioDuration = 0
        updateUI()
    }
    
    // MARK: -private
    func showAudio(_ model:SLAudioModel? = nil){
        let audioView = SLRecordAudioView.showRecord(audio: model) { [weak self](audio) in
            guard let strongSelf = self else { return }
            strongSelf.audioModel = audio
            strongSelf.updateUI()
        }
        audioView.sourceDirectory = self.sourceDirectory
    }
    
    @objc func sendClick(sender: SLButton) {//发送点评
        if self.textView.text.count < 1 {
            return
        }
        MBProgressHUD.sl_showLoading()
        
        if self.audioModel != nil {
            SLUploadSourceHelper().uploadAudio(mediaModel: audioModel, sucess: { (url) in
                MBProgressHUD.sl_hideHUD()
                self.remarkAudioDuration = self.audioModel.time
                self.remarkAudioUrl = url;
                self.commitCommet()
            }) { (msg, code) in
                MBProgressHUD.sl_showMessage(message: msg)
            }
                    
        }else {
            commitCommet()
        }
        

       
    }
    
    
    @objc func voiceClick(sender: SLButton) {//语音
       showAudio()
    }
    
    func commitCommet(){
        MBProgressHUD.sl_showLoading()
        SLEducationHomeworkBatchRemark(homeworkId: self.homeModel?.serviceId ?? 0, remark: self.textView.text, childrenIdList: self.childrenIdList, remarkAudioUrl: self.remarkAudioUrl ?? "", remarkAudioDuration: self.remarkAudioDuration ?? 0, homeworkCreateTime: self.homeModel?.createTime ?? "").request({ (json) in
            MBProgressHUD.sl_hideHUD()
            MBProgressHUD.sl_showMessage(message: "点评成功")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                if (self.commetCallBack != nil) {
                    self.commetCallBack!()
                }
                if self.isPop == true {
                    self.navigationController?.popViewController()
                }else {
//                    let vc  = SLHomeworkCommitListViewController()
//                    self.navigationController?.popToViewController(vc, animated: true)
                    for  vc in self.navigationController!.viewControllers{
                        if vc is SLHomeworkDetailViewController{
                            let popVc = vc as! SLHomeworkDetailViewController
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
            MBProgressHUD.sl_showMessage(message: msg)
        })
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
        self.textView.text = title
    }
    
    
    func sl_setupRightBarButtonItem() {

        let btnSend = SLButton(frame: CGRect(x: 0, y: 0, width: 60, height: 26))
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
    
    lazy var textView: SLPlaceholderTextView = {
        let tv = SLPlaceholderTextView()
        tv.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight2C3144)
        tv.limitCount = 200
        tv.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: -17, right: 17)
//        tv.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        tv.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightFFFFFF)
        tv.placeholderColor = UIColor.sl_hexToAdecimalColor(hex: "#C4CDDA")
        tv.placeholder = "请输入评语或添加语音"
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
    
 
    lazy var btnVoice: SLButton = {
        let btn = SLButton()
        btn.setMixedImage(MixedImage(normal: "sl_publish_audio", night: "sl_publish_audio"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "sl_publish_audio_gray", night: "sl_publish_audio_gray"), forState: .disabled)
        btn.addTarget(self, action: #selector(voiceClick(sender:)), for: .touchUpInside)
        return btn
    }()

    lazy var lbNote: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: 0xC4CDDA, night: 0xC4CDDA)
        lb.text = "200字内"
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textAlignment = NSTextAlignment.right
        return lb
    }()
    
    lazy var voiceView: SLVoiceView = {
        let voiceView = SLVoiceView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 36), complete: {
            [weak self](url, duration) in
            guard let strongSelf = self else { return }
            strongSelf.showAudio(strongSelf.audioModel)
            }, delectHandler: {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.removeAudio()
            }, showDelect: true)
        voiceView.minWidth = 120
        voiceView.tapPlayer = false
        return voiceView
    }()

    lazy var lbLine: SLLabel = {
        let lb = SLLabel()
        lb.mixedBackgroundColor = MixedColor(normal: 0xE6EAF3, night: 0x20232F)
        return lb
    }()
    
    lazy var tableView: SLTableView = {
        let tableView = SLTableView(frame:self.view.frame, style:.plain)
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
    var sourceDirectory = SLCacheDirectory.HomeWork
    
    var remarkAudioDuration: Int!
    var remarkAudioUrl: String!
    
    
    
    // MARK: - Setter
    var childrenIdList: [Int]! {
        didSet {
        }
    }
    
    var homeModel:SLHomeListModel? {
        didSet {
            
        }
    }
    
    var isPop: Bool! {
        didSet {
            
        }
    }
    
    var commetCallBack:(() -> ())?
    
//    // 是否有录音资源展示
//    private var isShowAudio: Bool
    
}
