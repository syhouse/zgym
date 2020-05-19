//
//  SLPunchCardCommentModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/26.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import ObjectMapper


class YXSPunchCardCommintListModel : NSObject, NSCoding, Mappable{
    
    var audioDuration : Int?
    var audioUrl : String?
    var avatar : String?
    var bgUrl : String?
    var childrenId : Int?
    var comments : [YXSPunchCardCommentModel]?
    var clockInCommitId : Int?
    var praises : [YXSFriendsPraiseModel]?
    var clockInId : Int?
    var teacherId: Int?
    var clockInTotalCount: Int?
    var excellentCount: Int?
    //修改内容后高度重新计算
    var content : String?{
        didSet{
            frameModel = nil
        }
    }
    var createTime : String?
    /// 家长id
    var custodianId : Int?
    //修改图片后媒体资源重新计算
    var imageUrl : String?{
        didSet{
            showImages = nil
        }
    }
    
    /// 补卡时间
    var patchCardTime : String?
    var realName : String?
    var relationship : String?
    var studentId : String?
    //修改视频后媒体资源重新计算
    var videoUrl : String?{
        didSet{
            showImages = nil
        }
    }
    
    /// 是否优秀
    var excellent: Bool?
    /// 当前内容是否展开
    var isShowContentAll: Bool = false
    
    
    /// 当前评论是否展开
    var isShowCommentAll: Bool = false
    
    /// 是否需要展示评论展开按钮
    var isNeeedShowCommentAllButton: Bool{
        get{
            return (self.comments?.count ?? 0 > 3)
        }
    }
    
    
    /// 是否是我发布  可操作优秀
    var isMyPublish: Bool = false

    /// 是否展示分割时间
    var isShowTime: Bool = false
    
    /// 用来初始化存储
    private var showImages: [YXSFriendsMediaModel]!
    
    /// 媒体资源
    var imgs: [YXSFriendsMediaModel] {
        get{
            if showImages != nil{
                return showImages
            }
            showImages = [YXSFriendsMediaModel]()
            if let imageUrl = imageUrl, imageUrl.count > 0{
                let pics = imageUrl.components(separatedBy: ",")
                for pic in pics{
                    let img = YXSFriendsMediaModel.init(url: pic, type: .serviceImg)
                    showImages.append(img)
                    
                }
                return showImages
                
            }
            if let videoUrl = videoUrl, videoUrl.count > 0{
                showImages.append(YXSFriendsMediaModel.init(url: videoUrl, type: .serviceVedio))
                return showImages
            }
            return showImages
        }
        
    }
    
    /// 是否有音频
    var hasVoice : Bool{
        get{
            return (audioUrl ?? "").count > 0
        }
    }
    ///展示查看全部打卡
    var isShowLookStudentAllButton: Bool = true
    
    ///展示历史优秀打卡
    var isShowLookGoodButton: Bool = true
    
    ///班级之星排行
    var topHistoryModel: YXSClassStarTopHistoryModel?
    
    var myClassStartRank: Int?{
        get{
            if let top3Model = topHistoryModel?.mapTop3{
                if let lists = top3Model.first{
                    for model in lists{
                        if childrenId == model.childrenId{
                            return 1
                        }
                    }
                }
                
                if let lists = top3Model.secend{
                    for model in lists{
                        if childrenId == model.childrenId{
                            return 2
                        }
                    }
                }
                
                if let lists = top3Model.thrid{
                    for model in lists{
                        if childrenId == model.childrenId{
                            return 3
                        }
                    }
                }
            }
            
            return nil
        }
    }
    
    
    ///headerView高度
    var headerHeight: CGFloat{
        get{
            if frameModel == nil{
                confingHeight()
            }
            let helper = YXSFriendsConfigHelper.helper
            //content顶部距离
            var height: CGFloat = self.isShowTime ? 40 + 14.5 + 41.0  + 14.0 : 21.0 + 41.0 + 14.0
            if needShowAllButton{
                height += 25.0 + 10.0
            }
            if self.isShowContentAll{
                height += frameModel.contentIsShowAllHeight

            }else{
                height += frameModel.contentHeight
            }

            if (audioUrl ?? "").count > 0{
                height += 36.0 + 10.0
            }

            //有图片视频资源
            if self.imgs.count !=  0{
                //视频资源间距
                height += 10.0
                if (videoUrl ?? "").count != 0{
                    height += helper.videoSize.height
                }else{
                    let count: Int = imgs.count/3 +  (self.imgs.count%3 == 0 ? 0 : 1)
                    SLLog("imgs.count = \(imgs.count) count = \(count)")
                    height +=  CGFloat(count)*CGFloat((SCREEN_WIDTH - 15.0 - 2*5.0 - 15.0)/3) + CGFloat(5*(count - 1))
                }
            }else{

            }
            //到展示更多底部高度
            height += 10.0 + 26.0

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
                let favsHeight = UIUtil.yxs_getTextHeigh(textStr: favsStr, attributes: attributes, width: SCREEN_WIDTH - 15.0 - 31.0 - 15.0 - 15.0)
                height += 2.5 + 7.5  + 8.0 + favsHeight + 8.0 - 1.0
            }else{
                height += 12.5
            }
            return height
        }
    }
    
    /// 朋友圈
    var frameModel:YXSFriendsCircleFrameModel!
    
    
    /// 是否需要showAllButton
    var needShowAllButton: Bool = false
    // MARK: - func
    /// 计算朋友圈model值
    func confingHeight(){
        frameModel = YXSFriendsCircleFrameModel()
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = kMainContentLineHeight
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: kTextMainBodyFont]
        frameModel.contentIsShowAllHeight = UIUtil.yxs_getTextHeigh(textStr: content ?? "", attributes: attributes, width: SCREEN_WIDTH - 30) + 1
        let text: String = content ?? ""
        frameModel.contentHeight = UIUtil.yxs_getTextHeigh(textStr: text, attributes: attributes,width: SCREEN_WIDTH - 30, numberOfLines: 3) + 1
        needShowAllButton = frameModel.contentIsShowAllHeight > (kTextMainBodyFont.pointSize * 3 + kMainContentLineHeight * 2)  ? true : false
        SLLog(frameModel.contentHeight)
        SLLog(frameModel.contentIsShowAllHeight)
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        audioDuration <- map["audioDuration"]
        audioUrl <- map["audioUrl"]
        avatar <- map["avatar"]
        bgUrl <- map["bgUrl"]
        childrenId <- map["childrenId"]
        comments <- map["clockInCommitCommentJsonList"]
        clockInCommitId <- map["clockInCommitId"]
        praises <- map["clockInCommitPraiseJsonList"]
        clockInId <- map["clockInId"]
        content <- map["content"]
        createTime <- map["createTime"]
        custodianId <- map["custodianId"]
        imageUrl <- map["imageUrl"]
        patchCardTime <- map["patchCardTime"]
        realName <- map["realName"]
        relationship <- map["relationship"]
        studentId <- map["studentId"]
        videoUrl <- map["videoUrl"]
        excellent <- map["excellent"]
        teacherId <- map["teacherId"]
        clockInTotalCount <- map["clockInTotalCount"]
        excellentCount <- map["excellentCount"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        audioDuration = aDecoder.decodeObject(forKey: "audioDuration") as? Int
        audioUrl = aDecoder.decodeObject(forKey: "audioUrl") as? String
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        bgUrl = aDecoder.decodeObject(forKey: "bgUrl") as? String
        childrenId = aDecoder.decodeObject(forKey: "childrenId") as? Int
        praises = aDecoder.decodeObject(forKey: "praises") as? [YXSFriendsPraiseModel]
        clockInCommitId = aDecoder.decodeObject(forKey: "clockInCommitId") as? Int
        comments = aDecoder.decodeObject(forKey: "comments") as? [YXSPunchCardCommentModel]
        clockInId = aDecoder.decodeObject(forKey: "clockInId") as? Int
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        custodianId = aDecoder.decodeObject(forKey: "custodianId") as? Int
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        patchCardTime = aDecoder.decodeObject(forKey: "patchCardTime") as? String
        realName = aDecoder.decodeObject(forKey: "realName") as? String
        relationship = aDecoder.decodeObject(forKey: "relationship") as? String
        studentId = aDecoder.decodeObject(forKey: "studentId") as? String
        videoUrl = aDecoder.decodeObject(forKey: "videoUrl") as? String
        excellent = aDecoder.decodeObject(forKey: "excellent") as? Bool
        isShowTime = aDecoder.decodeBool(forKey: "isShowTime")
        teacherId = aDecoder.decodeObject(forKey: "teacherId") as? Int
        clockInTotalCount = aDecoder.decodeObject(forKey: "clockInTotalCount") as? Int
        excellentCount = aDecoder.decodeObject(forKey: "excellentCount") as? Int
        
    }
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if audioDuration != nil{
            aCoder.encode(audioDuration, forKey: "audioDuration")
        }
        if audioUrl != nil{
            aCoder.encode(audioUrl, forKey: "audioUrl")
        }
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
        }
        if bgUrl != nil{
            aCoder.encode(bgUrl, forKey: "bgUrl")
        }
        if childrenId != nil{
            aCoder.encode(childrenId, forKey: "childrenId")
        }
        if comments != nil{
            aCoder.encode(comments, forKey: "comments")
        }
        if clockInCommitId != nil{
            aCoder.encode(clockInCommitId, forKey: "clockInCommitId")
        }
        if praises != nil{
            aCoder.encode(praises, forKey: "praises")
        }
        if clockInId != nil{
            aCoder.encode(clockInId, forKey: "clockInId")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if custodianId != nil{
            aCoder.encode(custodianId, forKey: "custodianId")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if patchCardTime != nil{
            aCoder.encode(patchCardTime, forKey: "patchCardTime")
        }
        if realName != nil{
            aCoder.encode(realName, forKey: "realName")
        }
        if relationship != nil{
            aCoder.encode(relationship, forKey: "relationship")
        }
        if studentId != nil{
            aCoder.encode(studentId, forKey: "studentId")
        }
        if videoUrl != nil{
            aCoder.encode(videoUrl, forKey: "videoUrl")
        }
        if excellent != nil{
            aCoder.encode(excellent, forKey: "excellent")
        }
        aCoder.encode(isShowTime, forKey: "isShowTime")
        
        if teacherId != nil{
            aCoder.encode(teacherId, forKey: "teacherId")
        }
        if clockInTotalCount != nil{
            aCoder.encode(clockInTotalCount, forKey: "clockInTotalCount")
        }
        if excellentCount != nil{
            aCoder.encode(excellentCount, forKey: "excellentCount")
        }
    }
    
}
