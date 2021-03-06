//
//  YXSVoiceView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSVoiceView: YXSVoiceBaseView {
    var model: YXSVoiceViewModel? {
        didSet {
            voiceDuration = model?.voiceDuration
            voiceUlr = model?.voiceUlr
            if let voiceDuration = voiceDuration{
                if voiceDuration > 60{
                    lbSecond.text = "\(voiceDuration/60)'\(voiceDuration%60)\""
                }else{
                    lbSecond.text = "\(voiceDuration)\""
                }
            }
            
            /// 装载音频
            if let url = URL(string: model?.voiceUlr ?? "") {
                YXSSSAudioPlayer.sharedInstance.play(url: url, cacheAudio: true){
                    self.stopVoiceAnimation()
                }
                YXSSSAudioPlayer.sharedInstance.pauseVoice()
            }
            
            updateLayout()
        }
    }
}

class YXSVoiceBaseView: UIView {

    var voiceUlr: String?
    var voiceDuration: Int?
//    var minWidth: CGFloat! = 0
    
    var completionHandler:((_ voiceUlr: String, _ voiceDuration: Int)->())?
    var delectHandler:(()->())?
    
    /// 展示删除
    var showDelect: Bool = false
    
    
    
    /// 点击播放
    var tapPlayer: Bool = true
    
    /// 是否暂停
//    var isPause: Bool = true
    
    init(frame: CGRect, complete:((_ voiceUlr: String, _ voiceDuration: Int)->())?,delectHandler:(()->())? = nil, showDelect: Bool = false) {
        completionHandler = complete
        self.delectHandler = delectHandler
        self.showDelect = showDelect
        super.init(frame: frame)
        createUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    func createUI() {
        self.clipsToBounds = true
        self.addSubview(self.indicatorView)
        self.indicatorView.cornerRadius = frame.height / 2
        self.cornerRadius = frame.height / 2
        
        self.addSubview(self.lbSecond)
        self.addSubview(self.imgIcon)
        
        
        
        self.imgIcon.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.left.equalTo(13)
            make.width.height.equalTo(18)
        })
        
        self.lbSecond.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snp_centerY)
            make.left.equalTo(self.imgIcon.snp_right).offset(13)
        })
        
        
        if showDelect{
            indicatorView.addSubview(closeButton)
            closeButton.snp.makeConstraints { (make) in
                make.right.equalTo(-11.5)
                make.size.equalTo(CGSize.init(width: 23, height: 23))
                make.centerY.equalTo(indicatorView)
            }
        }
        
        
        self.lbSecond.text = "12\""
        
    }
    
    // MARK: - Setter
    // 统一宽度语音最小宽度为：111    最大宽度为：175.5
    
    private let minWidth: CGFloat = 111
    ///最大宽度
    private let maxWidth: CGFloat  = 175.5
    
    ///最大录音时间长度 单位秒
    var maxTime: CGFloat = 300.0 {
        didSet {
            updateLayout()
        }
    }
    
    @objc func updateLayout() {
        let percentage: CGFloat = CGFloat(voiceDuration ?? 0) / maxTime
        //伸缩宽度
        var flexibleWidth = self.frame.width - minWidth
        flexibleWidth = maxWidth - minWidth
         
        let width:CGFloat = minWidth + flexibleWidth * percentage
        
        indicatorView.snp_remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(width)
        }
    }

    
    // MARK: - Action
    @objc func indicatorClick(sender: UIControl) {
        if tapPlayer{

            if YXSSSAudioPlayer.sharedInstance.isPause {
                YXSSSAudioPlayer.sharedInstance.resumeVoice()
                startVoiceAnimation()
                
            } else {
                YXSSSAudioPlayer.sharedInstance.pauseVoice()
                stopVoiceAnimation()
            }
        }
        self.completionHandler?(voiceUlr ?? "", voiceDuration ?? 0)
    }
    
    func startVoiceAnimation(){
        //  Converted to Swift 5.1 by Swiftify v5.1.28520 - https://objectivec2swift.com/
        let ary = [
            UIImage(named: "yxs_homework_voice0"),
            UIImage(named: "yxs_homework_voice1"),
            UIImage(named: "yxs_homework_voice2"),
        ]
        imgIcon.animationImages = ary.compactMap { $0 }
        imgIcon.animationDuration = 1 //动画时间
        imgIcon.animationRepeatCount = 0 //动画重复次数，0：无限
        imgIcon.startAnimating() //

    }
    
    func stopVoiceAnimation(){
        imgIcon.stopAnimating() //
    }
    
    @objc func closeClick(sender: UIControl) {
        delectHandler?()
    }
    
    // MARK: - LazyLoad
    lazy var indicatorView: UIControl = {
        let view = UIControl()
        view.borderColor = UIColor.yxs_hexToAdecimalColor(hex: "#D1D6E0")
        view.borderWidth = 0.5
        view.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
        view.addTarget(self, action: #selector(indicatorClick(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var imgIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_homework_voice2")
        return img
    }()
    
    lazy var lbSecond: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var closeButton: YXSButton = {
        let closeButton = YXSButton()
        closeButton.setImage(UIImage.init(named: "yxs_publish_voice_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return closeButton
    }()
    
}


class YXSVoiceViewModel: NSObject {
    var voiceUlr: String?
    var voiceDuration: Int?
    
    /// 0~1
//    var percentage: CGFloat? {
//        didSet {
//            self.percentage = (self.percentage ?? 0) > 1.0 ? 1.0 : (self.percentage ?? 0)
//        }
//    }
//
    
}
