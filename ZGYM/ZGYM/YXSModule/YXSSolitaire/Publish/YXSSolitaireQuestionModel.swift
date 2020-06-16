//
//  YXSSolitaireQuestionModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/28.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation

///接龙详情组装的采集问题model
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
    
    ///题目的id
    var gatherTopicId: Int?
    
    ///回答图片
    var answerMedias = [SLPublishEditMediaModel]()
    
    ///家长回答人数
    var gatherTopicCount: Int?
    
    ///家长回答百分比
    var ratio: Int?
    
    ///详情页cell高度
    func getCellDetialHeight(index: Int) -> CGFloat{
        var height: CGFloat = 17.0
        
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
        let dic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.paragraphStyle:paragraphStye]

        height += UIUtil.yxs_getTextHeigh(textStr: "\(index + 1)、\(questionStemText ?? "")",attributes: dic, width: SCREEN_WIDTH - 15 - 15)
        height += 30
        if YXSPersonDataModel.sharePerson.personRole == .PARENT{
            switch type {
            case .single, .checkbox:
                if let solitaireSelects = solitaireSelects{
                    let maxCount = solitaireSelects.count > maxQuestionCount ? maxQuestionCount : solitaireSelects.count
                    for index in 0..<maxCount {
                        let model = solitaireSelects[index]
                        height += 13 //顶部
                        height += 15// 选项
                        height += UIUtil.yxs_getTextHeigh(textStr: "\(model.leftText ?? "")、\(model.title ?? "")",attributes: dic, width: SCREEN_WIDTH - 15 - 15)
                        if model.mediaModel != nil{
                            height += 84 + 12.5
                        }
                        
                        height += 13//底部
                    }
                }
                
            case .image:
                let itemW:CGFloat = CGFloat((SCREEN_WIDTH - 30 - 5*2)/3)
                let row:CGFloat = CGFloat(answerMedias.count/3)
                height += 17
                height += itemW*(row + ((answerMedias.count%3 == 0) ? 0 : 1)) + row*5
            case .gap:
                
                height += 17
                
                height += 135
            }
            ///底部距离
            height += 17
            return height
        }else{
            
            switch type {
            case .single, .checkbox:
                if let solitaireSelects = solitaireSelects{
                    let maxCount = solitaireSelects.count > maxQuestionCount ? maxQuestionCount : solitaireSelects.count
                    for index in 0..<maxCount {
                        let model = solitaireSelects[index]
                        height += 26
                        height += UIUtil.yxs_getTextHeigh(textStr: "\(model.leftText ?? "")、\(model.title ?? "")",attributes: dic, width: SCREEN_WIDTH - 15 - 15)
                        if model.mediaModel != nil{
                            height += 84 + 12.5
                        }
                        height += 41
                    }
                }
                
            case .image, .gap:
                height += 55.5
            }
            ///底部距离
            height += 17
            return height
        }
    }
    
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
        
        answerMedias = aDecoder.decodeObject(forKey: "answerMedias") as? [SLPublishEditMediaModel] ?? [SLPublishEditMediaModel]()
        gatherTopicId = aDecoder.decodeObject(forKey: "gatherTopicId") as? Int
        gatherTopicCount = aDecoder.decodeObject(forKey: "gatherTopicCount") as? Int
        ratio = aDecoder.decodeObject(forKey: "ratio") as? Int
        
        type = YXSQuestionType.init(rawValue: (aDecoder.decodeObject(forKey: "type") as? String) ?? "") ?? YXSQuestionType.single
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
        if answerContent != nil{
            aCoder.encode(gatherTopicId, forKey: "gatherTopicId")
        }
        if ratio != nil{
            aCoder.encode(ratio, forKey: "ratio")
        }
        if gatherTopicCount != nil{
            aCoder.encode(gatherTopicCount, forKey: "gatherTopicCount")
        }
        aCoder.encode(isNecessary, forKey: "isNecessary")
        aCoder.encode(answerMedias, forKey: "answerMedias")
        aCoder.encode(type.rawValue, forKey: "type")
    }
}

