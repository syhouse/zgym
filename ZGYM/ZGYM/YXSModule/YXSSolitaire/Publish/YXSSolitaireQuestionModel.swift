//
//  YXSSolitaireQuestionModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
class YXSSolitaireQuestionModel: NSObject, NSCoding{
    ///是否必答
    var isNecessary: Bool = false
    ///题干
    var questionStemText: String?
    ///图片限制
    var imageLimint: Int = 9
    ///最大选项数
    var maxSelect: Int?
    
    var type: YXSQuestionType
    
    var solitaireSelects:[SolitairePublishNewSelectModel]?
    
    ///回答内容
    var answerContent: String?
    
    ///回答图片
    var answerMedias = [SLPublishMediaModel]()
    
    init(questionType: YXSQuestionType){
        self.type = questionType
        super.init()
    }
    
    @objc required init(coder aDecoder: NSCoder){
        isNecessary = aDecoder.decodeBool(forKey: "isNecessary")
        questionStemText = aDecoder.decodeObject(forKey: "questionStemText") as? String
        imageLimint = Int(aDecoder.decodeCInt(forKey: "imageLimint")) as Int
        maxSelect = aDecoder.decodeObject(forKey: "maxSelect") as? Int
        solitaireSelects = aDecoder.decodeObject(forKey: "solitaireSelects") as? [SolitairePublishNewSelectModel]
        
        type = YXSQuestionType.init(rawValue: aDecoder.decodeObject(forKey: "type") as? String  ?? "") ?? .single
        
        answerContent = aDecoder.decodeObject(forKey: "answerContent") as? String
        
        answerMedias = aDecoder.decodeObject(forKey: "answerMedias") as? [SLPublishMediaModel] ?? [SLPublishMediaModel]()
    }
    @objc func encode(with aCoder: NSCoder)
    {
        if questionStemText != nil{
            aCoder.encode(questionStemText, forKey: "questionStemText")
            
        }
        
        aCoder.encode(imageLimint, forKey: "imageLimint")
        
        if maxSelect != nil{
            aCoder.encode(maxSelect, forKey: "maxSelect")
        }
        if solitaireSelects != nil{
            aCoder.encode(solitaireSelects, forKey: "solitaireSelects")
        }
        if answerContent != nil{
            aCoder.encode(answerContent, forKey: "answerContent")
        }
        aCoder.encode(isNecessary, forKey: "isNecessary")
        aCoder.encode(answerMedias, forKey: "answerMedias")
    }
}
