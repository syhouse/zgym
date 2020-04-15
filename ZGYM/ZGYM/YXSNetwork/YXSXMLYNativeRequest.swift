//
//  YXSXMLYNativeRequest.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/15.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
/// 喜马拉雅 我们自己服务器的接口

let babyVoiceCollectionSave = "/baby/voice/collection/save"
/// 收藏宝宝听声音
class YXSEducationBabyVoiceCollectionSaveRequest: YXSBaseRequset {
    init(voiceId: Int,voiceTitle: String,voiceDuration: Int) {
        super.init()
        method = .post
        host = homeHost
        path = babyVoiceCollectionSave
        param = ["voiceId": voiceId,
        "voiceTitle": voiceTitle,
        "voiceDuration": voiceDuration]
    }
}

let babyVoiceCollectionJudge = "/baby/voice/collection/judge"
/// 判定是否收藏宝宝听声音
class YXSEducationBabyVoiceCollectionJudgeRequest: YXSBaseRequset {
    init(voiceId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = babyVoiceCollectionJudge
        param = ["voiceId": voiceId]
    }
}

let babyVoiceCollectionCancel = "/baby/voice/collection/cancle"
/// 取消收藏宝宝听声音
class YXSEducationBabyVoiceCollectionCancelRequest: YXSBaseRequset {
    init(voiceId: Int) {
        super.init()
        method = .post
        host = homeHost
        path = babyVoiceCollectionCancel
        param = ["voiceId": voiceId]
    }
}
