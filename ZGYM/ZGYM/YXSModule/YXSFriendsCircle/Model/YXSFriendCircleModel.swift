//
//  YXSFriendCircleModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper

enum HMClassCircleType: String{
    ///用户发布
    case CIRCLE
    ///系统助手  默认发布
    case HELPER
}

enum YXSContentDealType: String{
    ///首页瀑布流单独处理 (内容如果有只保留一个空格； 同时过滤掉换行也就是不换行)
    case homeList
    /// 收缩状态移除空格换行 展开状态展示用户设置
    case other
}


class YXSFriendCircleModel : NSObject, NSCoding, Mappable{
    
    var attachment : String?{
        didSet{
            if let attachment = attachment{
                var imgs = [YXSFriendsMediaModel]()
                if attachment.hasSuffix(kHMVedioAppendKey){
                    let img = YXSFriendsMediaModel.init(url: attachment.removingSuffix(kHMVedioAppendKey), type: .serviceVedio)
                    imgs.append(img)
                    isVideoSource = true
                }else{
                    let pics = attachment.components(separatedBy: ",")
                    for pic in pics{
                        if pic.hasPrefix("friends_guide"){
                            let img = YXSFriendsMediaModel.init(url: pic, type: .locailImg)
                            imgs.append(img)
                        }else{
                            let img = YXSFriendsMediaModel.init(url: pic, type: .serviceImg)
                            imgs.append(img)
                        }
                        
                    }
                }
                if imgs.count > 0{
                    self.imgs = imgs
                }
            }
        }
    }
    
    var avatarPublisher : String?
    var classCircleId : Int?
    var content : String?
    var createTime : String?
    var id : Int?
    var namePublisher : String?
    var noComment : String?
    var typePublisher : String?
    var userIdPublisher : Int?
    var praises :[YXSFriendsPraiseModel]?
    var comments: [YXSFriendsCommentModel]?
    
    var childrenId: Int?
    var gradeName : String?
    var childrenRealName : String?
    var childrenAvatar : String?
    var relationship : String?
    var gradeId : String?
    var classCircleType : String?
    
    var circleType: HMClassCircleType{
        get{
            return HMClassCircleType.init(rawValue: classCircleType ?? "") ?? HMClassCircleType.CIRCLE
        }
    }
    
    /// 假数据头像
    var avatarImage : UIImage?
    
    /// 分享文字
    var shareText: String{
        if let content = content{
            if content.count > 40{
                return content.mySubString(to: 40)
            }
            return content
        }
        return ""
    }
    var isMyPublish:Bool{
        get{
            return userIdPublisher == yxs_user.id && typePublisher == yxs_user.type
        }
    }
    var personRole: PersonRole{
        get{
            return PersonRole.init(rawValue: typePublisher ?? "") ?? PersonRole.PARENT
        }
    }
    
    var imgs: [YXSFriendsMediaModel]?
    
    var isShowDay: Bool = false
    var isShowAll: Bool = false
    
    /// 视频资源
    var isVideoSource: Bool = false
    
    ///仅朋友圈列表该值正确
    var needShowAllButton: Bool = false
    
    var contentDealType: YXSContentDealType = .other
    
    /// 朋友圈
    var frameModel:YXSFriendsCircleFrameModel!
    /// 朋友圈高度
    var friendHeight: CGFloat{
        get{
            if frameModel == nil{
                confingHeight()
            }
            let helper = YXSFriendsConfigHelper.helper
            //content顶部距离
            var height: CGFloat = helper.nameLabelTopPadding + 16 + helper.contentTopToNameLPadding
            
        
            ///系统的不展示 展开按钮  直接展示全部数据
            if circleType == .HELPER{
                self.isShowAll = true
            }
            
            if needShowAllButton && circleType == .CIRCLE{
                height += 25 + 9
            }
            if self.isShowAll{
                height += frameModel.contentIsShowAllHeight
                
            }else{
                height += frameModel.contentHeight
            }
            
            //有图片视频资源
            if (self.imgs?.count ?? 0) !=  0{
                //视频资源间距
                height += 10
                if isVideoSource{
                    height += helper.videoSize.height
                }else{
                    let count: CGFloat = CGFloat((self.imgs?.count ?? 0)/3) +  CGFloat((self.imgs?.count ?? 0)%3 == 0 ? 0 : 1)
                    height += count*(SCREEN_WIDTH - helper.contentLeftMargin - 2*5 - 15)/3 + CGFloat(5*(count - 1))
                }
            }else{
                
            }
            //到时间底部高度
            height += 15 + 14 + 2
            
            var favs = [String]()
            if let prises = self.praises, prises.count > 0{
                for (_,prise) in prises.enumerated(){
                    favs.append(prise.userName ?? "")
                }
                let favsStr = favs.joined(separator: ",")
                
                let paragraphStye = NSMutableParagraphStyle()
                //调整行间距
                paragraphStye.lineSpacing = 6
                paragraphStye.lineBreakMode = .byWordWrapping
                let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                let favsHeight = UIUtil.yxs_getTextHeigh(textStr: favsStr, attributes: attributes, width: SCREEN_WIDTH - helper.contentLeftMargin - 31 - 15 - 15) + 2
                height += 12.5 + 8 + favsHeight + 8 + 7.5 - 1
            }else{
                height += 12.5
            }
            return height
        }
        
    }
    
    
    /// 正在点赞请求
    var isOnRequsetPraise: Bool = false
    
    ///内容调整宽度(首页有背景 内容宽度缩小)
    var contentAdjustWidth: CGFloat = 0
    
    // MARK: - func
    /// 计算朋友圈model值
    func confingHeight(){
        let helper = YXSFriendsConfigHelper.helper
        frameModel = YXSFriendsCircleFrameModel()
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
        
        ///展开文本
        var spreadContent: String = self.content ?? ""
        ///收缩文本
        var shrinkContent: String = self.content ?? ""
        if contentDealType == .homeList{
            spreadContent = self.content?.listReplaceSpaceAndReturn() ?? ""
            shrinkContent = spreadContent
        }else{
            shrinkContent = spreadContent.removeSpace()
        }
        frameModel.contentIsShowAllHeight = UIUtil.yxs_getTextHeigh(textStr: spreadContent, attributes: attributes, width: helper.contentWidth - contentAdjustWidth) + 1
        frameModel.contentHeight = UIUtil.yxs_getTextHeigh(textStr: shrinkContent , attributes: attributes,width: helper.contentWidth, numberOfLines: 3) + 1
        needShowAllButton = frameModel.contentIsShowAllHeight > (kTextMainBodyFont.pointSize * 3 + kMainContentLineHeight * 2)  ? true : false
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        attachment <- map["attachment"]
        avatarPublisher <- map["avatarPublisher"]
        classCircleId <- map["classCircleId"]
        comments <- map["comment"]
        content <- map["content"]
        childrenId <- map["childrenId"]
        createTime <- map["createTime"]
        id <- map["id"]
        namePublisher <- map["namePublisher"]
        noComment <- map["noComment"]
        praises <- map["praise"]
        typePublisher <- map["typePublisher"]
        userIdPublisher <- map["userIdPublisher"]
        gradeName <- map["gradeName"]
        childrenRealName <- map["childrenRealName"]
        childrenAvatar <- map["childrenAvatar"]
        relationship <- map["relationship"]
        gradeId <- map["gradeId"]
        childrenId <- map["childrenId"]
        classCircleType <- map["classCircleType"]
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        
        avatarImage = aDecoder.decodeObject(forKey: "avatarImage") as? UIImage
        attachment = aDecoder.decodeObject(forKey: "attachment") as? String
        avatarPublisher = aDecoder.decodeObject(forKey: "avatarPublisher") as? String
        childrenAvatar = aDecoder.decodeObject(forKey: "childrenAvatar") as? String
        childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
        childrenRealName = aDecoder.decodeObject(forKey: "childrenRealName") as? String
        classCircleId = aDecoder.decodeObject(forKey: "classCircleId") as? Int
        classCircleType = aDecoder.decodeObject(forKey: "classCircleType") as? String
        comments = aDecoder.decodeObject(forKey: "comment") as? [YXSFriendsCommentModel]
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        gradeId = aDecoder.decodeObject(forKey: "gradeId") as? String
        gradeName = aDecoder.decodeObject(forKey: "gradeName") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        namePublisher = aDecoder.decodeObject(forKey: "namePublisher") as? String
        noComment = aDecoder.decodeObject(forKey: "noComment") as? String
        praises = aDecoder.decodeObject(forKey: "praise") as? [YXSFriendsPraiseModel]
        relationship = aDecoder.decodeObject(forKey: "relationship") as? String
        typePublisher = aDecoder.decodeObject(forKey: "typePublisher") as? String
        userIdPublisher = aDecoder.decodeObject(forKey: "userIdPublisher") as? Int
        imgs = aDecoder.decodeObject(forKey: "imgs") as? [YXSFriendsMediaModel]
        isVideoSource = aDecoder.decodeBool(forKey: "isVideoSource")
        frameModel = aDecoder.decodeObject(forKey: "frameModel") as? YXSFriendsCircleFrameModel
        contentDealType = YXSContentDealType.init(rawValue: aDecoder.decodeObject(forKey: "contentDealType") as? String ?? "") ?? YXSContentDealType.homeList
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if attachment != nil{
            aCoder.encode(attachment, forKey: "attachment")
        }
        if avatarImage != nil{
            aCoder.encode(avatarImage, forKey: "avatarImage")
        }
        if avatarPublisher != nil{
            aCoder.encode(avatarPublisher, forKey: "avatarPublisher")
        }
        if childrenAvatar != nil{
            aCoder.encode(childrenAvatar, forKey: "childrenAvatar")
        }
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if childrenRealName != nil{
            aCoder.encode(childrenRealName, forKey: "childrenRealName")
        }
        if classCircleId != nil{
            aCoder.encode(classCircleId, forKey: "classCircleId")
        }
        if classCircleType != nil{
            aCoder.encode(classCircleType, forKey: "classCircleType")
        }
        if comments != nil{
            aCoder.encode(comments, forKey: "comment")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if gradeId != nil{
            aCoder.encode(gradeId, forKey: "gradeId")
        }
        if gradeName != nil{
            aCoder.encode(gradeName, forKey: "gradeName")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if namePublisher != nil{
            aCoder.encode(namePublisher, forKey: "namePublisher")
        }
        if noComment != nil{
            aCoder.encode(noComment, forKey: "noComment")
        }
        if praises != nil{
            aCoder.encode(praises, forKey: "praise")
        }
        if relationship != nil{
            aCoder.encode(relationship, forKey: "relationship")
        }
        if typePublisher != nil{
            aCoder.encode(typePublisher, forKey: "typePublisher")
        }
        if userIdPublisher != nil{
            aCoder.encode(userIdPublisher, forKey: "userIdPublisher")
        }
        if imgs != nil{
            aCoder.encode(imgs, forKey: "imgs")
        }
        aCoder.encode(isVideoSource, forKey: "isVideoSource")
        
        if frameModel != nil{
            aCoder.encode(frameModel, forKey: "frameModel")
        }
        aCoder.encode(contentDealType.rawValue, forKey: "contentDealType")
    }
    
}

