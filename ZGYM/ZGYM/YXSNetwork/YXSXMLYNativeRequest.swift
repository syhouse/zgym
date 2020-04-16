//
//  YXSXMLYNativeRequest.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/15.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
/// 喜马拉雅 我们自己服务器的接口

// MARK: - 宝宝听收藏声音
// MARK: 取消收藏的宝宝听声音
let babyVoiceCollectionCancel = "/baby/voice/collection/cancel"
class YXSEducationBabyVoiceCollectionCancelRequest: YXSBaseRequset {
    init(voiceId: Int) {
        super.init()
        method = .post
        host = host
        path = babyVoiceCollectionCancel
        param = ["voiceId": voiceId]
        
    }
}

// MARK: 判定是否收藏宝宝听声音
let babyVoiceCollectionJudge = "/baby/voice/collection/judge"
class YXSEducationBabyVoiceCollectionJudgeRequest: YXSBaseRequset {
    init(voiceId: Int) {
        super.init()
        method = .post
        host = host
        path = babyVoiceCollectionJudge
        param = ["voiceId": voiceId]
        
    }
}

// MARK: 分页查询我收藏的宝宝听声音
let babyVoiceCollectionPage = "/baby/voice/collection/page"
class YXSEducationBabyVoiceCollectionPageRequest: YXSBaseRequset {
    init(current: Int = 1, size: Int = 20) {
        super.init()
        method = .post
        host = host
        path = babyVoiceCollectionPage
        param = ["current": current,
                 "size": size]
    }
}

// MARK: 收藏宝宝听声音
let babyVoiceCollectionSave = "/baby/voice/collection/save"
class YXSEducationBabyVoiceCollectionSaveRequest: YXSBaseRequset {
    init(voiceId: Int = 1, voiceTitle: String, voiceDuration: Int) {
        super.init()
        method = .post
        host = host
        path = babyVoiceCollectionSave
        param = ["voiceId": voiceId,
                 "voiceTitle": voiceTitle,
                 "voiceDuration": voiceDuration]
    }
}


// MARK: - 宝宝听收藏专辑
// MARK: 分页查询我收藏的宝宝听专辑
let babyAlbumCollectionPage = "/baby/album/collection/page"
class YXSEducationBabyAlbumCollectionPageRequset: YXSBaseRequset {
    init(current: Int = 1, size: Int = 20) {
        super.init()
        method = .post
        host = host
        path = babyAlbumCollectionPage
        param = ["current": current,
                 "size": size]
        
    }
}

// MARK: 收藏宝宝听专辑
let babyAlbumCollectionSave = "/baby/album/collection/save"
class YXSEducationBabyAlbumCollectionSaveRequest: YXSBaseRequset {
    init(albumId: Int, albumCover: String, albumTitle: String, albumNum: Int) {
        super.init()
        method = .post
        host = host
        path = babyAlbumCollectionSave
        param = ["albumId": albumId,
                 "albumCover": albumCover,
                 "albumTitle": albumTitle,
                 "albumNum": albumNum]
        
    }
}

// MARK: 取消收藏宝宝听专辑
let babyAlbumCollectionCancel = "/baby/album/collection/cancel"
class YXSEducationBabyAlbumCollectionCancelRequest: YXSBaseRequset {
    init(albumId: Int) {
        super.init()
        method = .post
        host = host
        path = babyAlbumCollectionCancel
        param = ["albumId": albumId]
    }
}

// MARK: 判定是否收藏宝宝听专辑
let babyAlbumCollectionJudge = "/baby/album/collection/judge"
class YXSEducationBabyAlbumCollectionJudgeRequest: YXSBaseRequset {
    init(albumId: Int) {
        super.init()
        method = .post
        host = host
        path = babyAlbumCollectionJudge
        param = ["albumId": albumId]
    }
}
