//
//  FriendsCommentself.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/13.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import Foundation
import ObjectMapper
import YYText



class SLFriendsCommentModel : NSObject, NSCoding, Mappable{
    
    var classCircleId : Int?
    var content : String?
    var createTime : String?
    var id : Int?
    var type : String?
    var userId : Int?
    var userIdReplied : Int?
    var userName : String?
    var userNameReplied : String?
    var userType : String?
    var userTypeReplied : String?
    
    var isMyComment: Bool{
        get{
            return sl_user.id == userId && userType == sl_user.type
        }
    }
    
    var showUserName: String?{
        get{
            if isMyComment{
                return "我"
            }
            return userName
        }
    }
    
    var showUserNameReplied: String?{
        get{
            if userIdReplied == sl_user.id && userTypeReplied == sl_user.type{
                return "我"
            }
            return userNameReplied
        }
    }
    
    var commentText: String{
        get{
            return showUserNameReplied == nil ? "\(showUserName ?? "")：\(content ?? "")" : "\(showUserName ?? "")回复\(showUserNameReplied!)：\(content ?? "")"
        }
    }
    
    public var cellHeight: CGFloat?
    
    @discardableResult public func getTextHeight() -> CGFloat{
        if let cellHeight = cellHeight{
            return cellHeight - 5
        }
        //        cellHeight = UIUtil.sl_getTextHeigh(textStr: commentText, font: SLFriendsConfigHelper.helper.commentFont, width: SLFriendsConfigHelper.helper.commentWidth - 20) + 10
        var text:NSMutableAttributedString
        var length: Int
        if let toPerson = self.showUserNameReplied{
            text = NSMutableAttributedString(string: "\(self.showUserName ?? "")回复\(toPerson)：\(self.content ?? "")")
            text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
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
            text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
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
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: SLFriendsConfigHelper.helper.commentFont]
        text.addAttributes(attributes, range: NSRange.init(location: 0, length: text.length))
        
        let titleContainer:YYTextContainer = YYTextContainer.init(size: CGSize.init(width: SLFriendsConfigHelper.helper.commentWidth - 20, height: 4000))
        let titleLayout:YYTextLayout = YYTextLayout.init(container: titleContainer, text: text)!
        cellHeight = titleLayout.textBoundingSize.height + 8
        return cellHeight! - 7
    }
    
    
    /// 初始化高度
    public func configHeight(){
        if let _ = cellHeight{
            return
        }
        getTextHeight()
    }
    
    
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        classCircleId <- map["classCircleId"]
        content <- map["content"]
        createTime <- map["createTime"]
        id <- map["id"]
        type <- map["type"]
        userId <- map["userId"]
        userIdReplied <- map["userIdReplied"]
        userName <- map["userName"]
        userNameReplied <- map["userNameReplied"]
        userType <- map["userType"]
        userTypeReplied <- map["userTypeReplied"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        classCircleId = aDecoder.decodeObject(forKey: "classCircleId") as? Int
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? Int
        userIdReplied = aDecoder.decodeObject(forKey: "userIdReplied") as? Int
        userName = aDecoder.decodeObject(forKey: "userName") as? String
        userNameReplied = aDecoder.decodeObject(forKey: "userNameReplied") as? String
        userType = aDecoder.decodeObject(forKey: "userType") as? String
        userTypeReplied = aDecoder.decodeObject(forKey: "userTypeReplied") as? String
        cellHeight = aDecoder.decodeObject(forKey: "cellHeight") as? CGFloat
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if classCircleId != nil{
            aCoder.encode(classCircleId, forKey: "classCircleId")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if userIdReplied != nil{
            aCoder.encode(userIdReplied, forKey: "userIdReplied")
        }
        if userName != nil{
            aCoder.encode(userName, forKey: "userName")
        }
        if userNameReplied != nil{
            aCoder.encode(userNameReplied, forKey: "userNameReplied")
        }
        if userType != nil{
            aCoder.encode(userNameReplied, forKey: "userType")
        }
        if userTypeReplied != nil{
            aCoder.encode(userTypeReplied, forKey: "userTypeReplied")
        }
        if cellHeight != nil{
            aCoder.encode(cellHeight, forKey: "cellHeight")
        }
    }
    
}
