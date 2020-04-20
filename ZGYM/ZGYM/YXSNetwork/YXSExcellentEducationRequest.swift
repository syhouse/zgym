//
//  YXSExcellentEducationRequest.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation


// MARK: - 同步课堂
// MARK: 获取同步课堂标签tab类型（年级分类 “一年级，二年级...”）
let excellentTabPage = "/baby/voice/collection/cancel"
class YXSEducationExcellentTabPageRequest: YXSBaseRequset {
    init(voiceId: Int) {
        super.init()
        method = .post
        host = classHost
        path = excellentTabPage
        param = ["currentPage": 0,
                 "pageSize":100]
    }
}
