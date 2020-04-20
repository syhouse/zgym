//
//  SLCommentView.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/3/6.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

/// 详情里的点评内容 （xxx的点评、内容、语音、日期)
class YXSHomeworkDetailCommentView: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    /// 语音
    var voiceTouchedHandler:((_ voiceUlr: String, _ voiceDuration: Int)->())?
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(lbTitle)
        self.addSubview(lbCommet)
        self.addSubview(btnCancel)
        self.addSubview(commetAudioView)
        self.addSubview(lbCommentTime)
        
        layout()
    }
    
    @objc func layout() {
        lbTitle.snp.makeConstraints({ (make) in
            make.left.equalTo(17.5)
            make.right.equalTo(-100)
            make.top.equalTo(10+10)
            make.height.equalTo(30)
        })
        
        lbCommet.snp.makeConstraints({ (make) in
            make.left.equalTo(17.5)
            make.right.equalTo(-17.5)
            make.top.equalTo(lbTitle.snp_bottom).offset(10)
        })
        
        commetAudioView.snp.makeConstraints({ (make) in
            make.left.equalTo(17.5)
            make.top.equalTo(lbCommet.snp_bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(162)
        })
        
        lbCommentTime.snp.makeConstraints({ (make) in
            make.top.equalTo(lbCommet.snp_bottom).offset(10)
            make.left.equalTo(17.5)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(0)
        })
        
        btnCancel.snp.makeConstraints({ (make) in
            make.right.equalTo(-17)
            make.top.equalTo(lbTitle.snp_top)
            make.height.equalTo(30)
            make.width.equalTo(50)
        })
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
    var model: YXSHomeworkDetailCommentViewModel? {
        didSet {
            
            btnCancel.isHidden = self.model?.isCancelButtonHidden ?? true
            lbCommet.text = self.model?.comment
            lbCommentTime.text = self.model?.time?.yxs_Time()
            
            if self.model?.audioModel?.voiceUlr?.count ?? 0 > 0 {
                commetAudioView.model = self.model?.audioModel
                commetAudioView.isHidden = false
                commetAudioView.id = self.model?.audioModel?.voiceUlr ?? ""
                lbCommentTime.snp.remakeConstraints({ (make) in
                    make.top.equalTo(commetAudioView.snp_bottom).offset(10)
                    make.left.equalTo(17.5)
                    make.height.equalTo(20)
                    make.bottom.equalToSuperview().offset(-20)
                })

            }else{
                commetAudioView.isHidden = true
                
                lbCommentTime.snp.remakeConstraints({ (make) in
                    make.top.equalTo(lbCommet.snp_bottom).offset(10)
                    make.left.equalTo(17.5)
                    make.height.equalTo(20)
                    make.bottom.equalToSuperview().offset(-20)
                })
            }
        }
    }
    
    // MARK: - LazyLoad
    lazy var btnCancel: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("撤销", for:    .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_homework_cancel", night: "yxs_homework_cancel"), forState: .normal)
        //btn.imageEdgeInsets = UIEdgeInsets(top: 4.5, left: 14.5, bottom: 14.5, right: 4.5)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        return btn
    }()
    
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x222222, night: 0xC4CDDA)
        lb.text = "老师的评论"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    lazy var lbCommet: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: 0x222222, night: 0xFFFFFF)
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var lbCommentTime: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "刚刚"
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0xFFFFFF)
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var commetAudioView: YXSListVoiceView = {
        let voiceView = YXSListVoiceView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30 , height: 36), complete: {
            [weak self] (url, duration) in
            guard let weakSelf = self else { return }

            weakSelf.voiceTouchedHandler?(url, duration)
        })
        voiceView.minWidth = 120
        voiceView.tapPlayer = true
        return voiceView
    }()
}

class YXSHomeworkDetailCommentViewModel: NSObject {
    var title: String?
    var comment: String?
    var time: String?
    var audioModel: YXSVoiceViewModel?
    var isCancelButtonHidden: Bool = true
}
