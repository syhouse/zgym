//
//  YXSHomeworkCommentModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/7.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper
import YYText

class YXSHomeworkCommentModel : NSObject, NSCoding, Mappable{
    var content : String?
    var createTime : Int?
    var id : Int?
    var ruserId : Int?
    var ruserName : String?
    var ruserType : String?
    var type : String?
    var userId : Int?
    var userName : String?
    var userType : String?
    
    
    /// 是否是我评论
    var isMyComment: Bool{
        get{
            return yxs_user.id == userId && userType == yxs_user.type
        }
    }
    
    
    /// 展示评论名称
    var showUserName: String?{
        get{
            if isMyComment{
                return "我"
            }
            return userName
        }
    }
    
    
    /// 展示回复名称
    var showUserNameReplied: String?{
        get{
            if ruserId == yxs_user.id && ruserType == yxs_user.type{
                return "我"
            }
            return ruserName
        }
    }
    
    
    /// 组装评论文本
    var commentText: String{
        get{
            return showUserNameReplied == nil ? "\(showUserName ?? "")：\(content ?? "")" : "\(showUserName ?? "")回复\(showUserNameReplied!)：\(content ?? "")"
        }
    }
    
    
    /// 文本计算高度
    private var commentHeight: CGFloat!
    
    
    /// 上边8px+文本高度
    public var cellHeight: CGFloat{
        get{
            if commentHeight == nil{
                configHeight()
            }
            return commentHeight + 8
        }
    }
    
    /// 初始化高度
    public func configHeight(){
        var text:NSMutableAttributedString
        var length: Int
        if let toPerson = self.showUserNameReplied{
            text = NSMutableAttributedString(string: "\(self.showUserName ?? "")回复\(toPerson)：\(self.content ?? "")")
            text.yy_setFont(YXSFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
            length = text.yy_rangeOfAll().length - "\(self.showUserName ?? "")".count - 2 - toPerson.count - 1
            text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(self.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
            
            text.yy_setTextHighlight(NSRange.init(location: "\(self.showUserName ?? "")".count  , length: 2 ),color: kTextMainBodyColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
            text.yy_setTextHighlight(NSRange.init(location: "\(self.showUserName ?? "")".count + 2 , length: toPerson.count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
            
            
        }else{
            text = NSMutableAttributedString(string: "\(self.showUserName ?? "")：\(self.content ?? "")")
            text.yy_setFont(YXSFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
            length = text.yy_rangeOfAll().length - "\(self.showUserName ?? "")".count - 1
            text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(self.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
        }
        let range = NSRange.init(location: text.yy_rangeOfAll().length - length, length: length)
        text.yy_setTextHighlight(range, color: kTextMainBodyColor, backgroundColor: nil){[weak self](view, str, range, rect) in
            guard let strongSelf = self else { return }
        }
        
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = 6
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: YXSFriendsConfigHelper.helper.commentFont]
        text.addAttributes(attributes, range: NSRange.init(location: 0, length: text.length))
        
        let titleContainer:YYTextContainer = YYTextContainer.init(size: CGSize.init(width: SCREEN_WIDTH - 24 - 30, height: 4000))
        let titleLayout:YYTextLayout = YYTextLayout.init(container: titleContainer, text: text)!
        commentHeight = titleLayout.textBoundingSize.height
    }
    
    required init?(map: Map){}
    private override init(){}
    
    
    func mapping(map: Map)
    {
        content <- map["content"]
        createTime <- map["createTime"]
        id <- map["id"]
        ruserId <- map["reUserId"]
        ruserName <- map["reUserName"]
        ruserType <- map["reUserType"]
        type <- map["type"]
        userId <- map["userId"]
        userName <- map["userName"]
        userType <- map["userType"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         content = aDecoder.decodeObject(forKey: "content") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         ruserId = aDecoder.decodeObject(forKey: "reUserId") as? Int
         ruserName = aDecoder.decodeObject(forKey: "reUserName") as? String
         ruserType = aDecoder.decodeObject(forKey: "reUserType") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int
         userName = aDecoder.decodeObject(forKey: "userName") as? String
         userType = aDecoder.decodeObject(forKey: "userType") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if ruserId != nil{
            aCoder.encode(ruserId, forKey: "reUserId`````````")
        }
        if ruserName != nil{
            aCoder.encode(ruserName, forKey: "reUserName")
        }
        if ruserType != nil{
            aCoder.encode(ruserType, forKey: "reUserType")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if userName != nil{
            aCoder.encode(userName, forKey: "userName")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "userType")
        }

    }
}
