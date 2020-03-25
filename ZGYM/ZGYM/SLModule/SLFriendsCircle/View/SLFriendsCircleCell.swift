//
//  SLFriendsCircleCell.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/13.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import YYText
import NightNight

class SLFriendsCircleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.sl_hexToAdecimalColor(hex: "#292B3A"))
        contentView.addSubview(comentLabel)
        self.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.sl_hexToAdecimalColor(hex: "#292B3A"))
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(longTap(_:)))
        contentView.addGestureRecognizer(longTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x = SLFriendsConfigHelper.helper.contentLeftMargin
            newFrame.size.width = frame.width - SLFriendsConfigHelper.helper.contentLeftMargin - 14.5
            super.frame = newFrame
        }
    }
    
    
    var commentBlock: (() -> ())?
    var cellLongTapEvent: ((_ point: CGPoint) -> ())?
    
    @objc func longTap(_ longTap: UILongPressGestureRecognizer){
        if longTap.state == UIGestureRecognizer.State.ended{
            if isMyPublish || model.isMyComment{
                var point = longTap.location(in: longTap.view)
                point.x += self.frame.origin.x
                cellLongTapEvent?(point)
            }
        }
    }
    var isMyPublish:Bool = false
    var model: SLFriendsCommentModel!
    func sl_setCellModel(_ model: SLFriendsCommentModel){
        //        DispatchQueue.global().async {
        //            self.model = model
        //            var text:NSMutableAttributedString
        //            var length: Int
        //
        //            let textNormalColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
        //            if let toPerson = model.showUserNameReplied{
        //                text = NSMutableAttributedString(string: "\(model.showUserName ?? "")回复\(toPerson)：\(model.content ?? "")")
        //                text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
        //                length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count - 2 - toPerson.count
        //                text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
        //                    print("")
        //                }
        //
        //                text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count  , length: 2 ),color: textNormalColor,backgroundColor: nil){(view, str, range, rect) in
        //                    print("")
        //                }
        //                text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count + 2 , length: toPerson.count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
        //                    print("")
        //                }
        //
        //
        //            }else{
        //                text = NSMutableAttributedString(string: "\(model.showUserName ?? "")：\(model.content ?? "")")
        //                text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
        //                length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count
        //                text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
        //                    print("")
        //                }
        //            }
        //            let range = NSRange.init(location: text.yy_rangeOfAll().length - length , length: length)
        //            text.yy_setTextHighlight(range, color: textNormalColor, backgroundColor: nil){[weak self](view, str, range, rect) in
        //                guard let strongSelf = self else { return }
        //                strongSelf.commentBlock?()
        //            }
        //
        //            let titleContainer:YYTextContainer = YYTextContainer.init(size: CGSize.init(width: SLFriendsConfigHelper.helper.commentWidth - 20, height: model.getTextHeight() + 5))
        //            let titleLayout:YYTextLayout = YYTextLayout.init(container: titleContainer, text: text)!
        //            DispatchQueue.main.async {
        //                //        comentLabel.frame = CGRect.init(x: 10, y: 5, width:SLFriendsConfigHelper.helper.commentWidth , height: model.getTextHeight())
        //                self.comentLabel.frame = CGRect.init(x: 10, y: 2.5, width:titleLayout.textBoundingSize.width , height: titleLayout.textBoundingSize.height)
        //                self.comentLabel.textLayout = titleLayout
        //            }
        //        }
        
        
        self.model = model
        var text:NSMutableAttributedString
        var length: Int
        
        let textNormalColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
        if let toPerson = model.showUserNameReplied{
            text = NSMutableAttributedString(string: "\(model.showUserName ?? "")回复\(toPerson)：\(model.content ?? "")")
            text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
            length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count - 2 - toPerson.count
            text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
            
//            setMixedAttributes([NNForegroundColorAttributeName: colors![i]], range: range)
            
            text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count  , length: 2 ),color: textNormalColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
//            text.setMixedAttributes([NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], range: NSRange.init(location: "\(model.showUserName ?? "")".count  , length: 2 ))
            
            text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count + 2 , length: toPerson.count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
//            text.setMixedAttributes([NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], range: NSRange.init(location: "\(model.showUserName ?? "")".count + 2 , length: toPerson.count ))
            
            
        }else{
            text = NSMutableAttributedString(string: "\(model.showUserName ?? "")：\(model.content ?? "")")
            text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
            length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count
            text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
        }
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = 6
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: SLFriendsConfigHelper.helper.commentFont]
        text.addAttributes(attributes, range: NSRange.init(location: 0, length: text.length))
        let range = NSRange.init(location: text.yy_rangeOfAll().length - length , length: length)
        text.yy_setTextHighlight(range, color: textNormalColor, backgroundColor: nil){[weak self](view, str, range, rect) in
            guard let strongSelf = self else { return }
            strongSelf.commentBlock?()
        }
//        text.setMixedAttributes([NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], range: range)
        comentLabel.attributedText = text
        self.comentLabel.frame = CGRect.init(x: 10, y: 2.5, width:SLFriendsConfigHelper.helper.commentWidth - 20 , height: model.getTextHeight() + 5)
    }
    
    var isLastRow: Bool = false{
        didSet{
            if isLastRow{
                self.contentView.sl_addRoundedCorners(corners: [.bottomRight,.bottomLeft], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - SLFriendsConfigHelper.helper.contentLeftMargin - 15, height:(model.cellHeight ?? 0) + 3))
            }else{
                self.contentView.sl_addRoundedCorners(corners: [.bottomRight,.bottomLeft], radii: CGSize.init(width: 0, height: 0), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - SLFriendsConfigHelper.helper.contentLeftMargin - 15, height:(model.cellHeight ?? 0) + 3))
            }
        }
        
    }
    
    lazy var comentLabel: YYLabel = {
        let label = YYLabel()
        label.font = SLFriendsConfigHelper.helper.commentFont
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - YYLabel异步优化有问题   点赞取消点赞 评论cell会闪动
    //    func sl_setCellModel(_ model: SLFriendsCommentModel){
    //        DispatchQueue.global().async {
    //            self.model = model
    //            var text:NSMutableAttributedString
    //            var length: Int
    //
    //            let textNormalColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
    //            if let toPerson = model.showUserNameReplied{
    //                text = NSMutableAttributedString(string: "\(model.showUserName ?? "")回复\(toPerson)：\(model.content ?? "")")
    //                text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
    //                length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count - 2 - toPerson.count
    //                text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
    //                    print("")
    //                }
    //
    //                text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count  , length: 2 ),color: textNormalColor,backgroundColor: nil){(view, str, range, rect) in
    //                    print("")
    //                }
    //                text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count + 2 , length: toPerson.count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
    //                    print("")
    //                }
    //
    //
    //            }else{
    //                text = NSMutableAttributedString(string: "\(model.showUserName ?? "")：\(model.content ?? "")")
    //                text.yy_setFont(SLFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
    //                length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count
    //                text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
    //                    print("")
    //                }
    //            }
    //            let range = NSRange.init(location: text.yy_rangeOfAll().length - length , length: length)
    //            text.yy_setTextHighlight(range, color: textNormalColor, backgroundColor: nil){[weak self](view, str, range, rect) in
    //                guard let strongSelf = self else { return }
    //                strongSelf.commentBlock?()
    //            }
    //
    //            let titleContainer:YYTextContainer = YYTextContainer.init(size: CGSize.init(width: SLFriendsConfigHelper.helper.commentWidth - 20, height: model.getTextHeight() + 5))
    //            let titleLayout:YYTextLayout = YYTextLayout.init(container: titleContainer, text: text)!
    //            DispatchQueue.main.async {
    //                //        comentLabel.frame = CGRect.init(x: 10, y: 5, width:SLFriendsConfigHelper.helper.commentWidth , heigh`t: model.getTextHeight())
    //                self.comentLabel.frame = CGRect.init(x: 10, y: 2.5, width:titleLayout.textBoundingSize.width , height: titleLayout.textBoundingSize.height)
    //                self.comentLabel.textLayout = titleLayout
    //            }
    //        }
    //
    //    }
    //
    //    lazy var comentLabel: YYLabel = {
    //        let label = YYLabel()
    //        label.font = SLFriendsConfigHelper.helper.commentFont
    //
    //        label.numberOfLines = 0
    //        return label
    //    }()
    
}
