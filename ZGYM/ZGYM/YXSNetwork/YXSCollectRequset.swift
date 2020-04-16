//
//  YXSCollectRequset.swift
//  ZGYM
//
//  Created by yihao on 2020/4/15.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

// MARK: 取消收藏的喜马拉雅声音
let cancelCollectVoice = "/baby/voice/collection/cancle"
class YXSEducationCancelCollectVoiceRequset: YXSBaseRequset {
    init(voiceId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = cancelCollectVoice
        param = ["voiceId": voiceId]
        
    }
}
