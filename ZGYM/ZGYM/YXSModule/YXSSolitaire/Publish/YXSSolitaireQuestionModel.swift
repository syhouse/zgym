//
//  YXSSolitaireQuestionModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
class YXSSolitaireQuestionModel: NSObject{
    ///是否必答
    var isNecessary: Bool = false
    ///题干
    var questionStemText: String = ""
    ///图片限制
    var imageLimint: Int?
    ///最大选项数
    var maxSelect: Int?
    
    var type: YXSQuestionType
    
    var solitaireSelects:[SolitairePublishNewSelectModel]?
    
    init(questionType: YXSQuestionType){
        self.type = questionType
        super.init()
    }
}
