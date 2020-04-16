//
//  YXSHomeworkDetailCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/7.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import UIKit
import YYText
import NightNight

class YXSHomeworkDetailCell: YXSBaseCommentCell {
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x = 15
            newFrame.size.width = frame.width - 30
            super.frame = newFrame
        }
    }
    var isMyComment: Bool = false{
        didSet{
            canDelect = isMyComment
        }
    }
    
    var model: YXSHomeworkCommentModel!
    func yxs_setCellModel(_ model: YXSHomeworkCommentModel){
        self.model = model
        isMyComment = model.isMyComment
        var text:NSMutableAttributedString
        var length: Int
        let textNormalColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
        if let toPerson = model.showUserNameReplied{
            text = NSMutableAttributedString(string: "\(model.showUserName ?? "")回复\(toPerson)：\(model.content ?? "")")
            text.yy_setFont(YXSFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
            length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count - 2 - toPerson.count
            text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
 
            text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count  , length: 2 ),color: textNormalColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }

            text.yy_setTextHighlight(NSRange.init(location: "\(model.showUserName ?? "")".count + 2 , length: toPerson.count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }

        }else{
            text = NSMutableAttributedString(string: "\(model.showUserName ?? "")：\(model.content ?? "")")
            text.yy_setFont(YXSFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
            length = text.yy_rangeOfAll().length - "\(model.showUserName ?? "")".count
            text.yy_setTextHighlight(NSRange.init(location: 0, length: "\(model.showUserName ?? "")".count ),color: kBlueColor,backgroundColor: nil){(view, str, range, rect) in
                print("")
            }
        }
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = 6
        paragraphStye.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.paragraphStyle:paragraphStye, NSAttributedString.Key.font: YXSFriendsConfigHelper.helper.commentFont]
        text.addAttributes(attributes, range: NSRange.init(location: 0, length: text.length))
        let range = NSRange.init(location: text.yy_rangeOfAll().length - length , length: length)
        text.yy_setTextHighlight(range, color: textNormalColor, backgroundColor: nil){[weak self](view, str, range, rect) in
            guard let strongSelf = self else { return }
            strongSelf.commentBlock?()
        }
//        text.setMixedAttributes([NNForegroundColorAttributeName: MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], range: range)
        comentLabel.attributedText = text
        self.comentLabel.frame = CGRect.init(x: 12, y: 8, width:SCREEN_WIDTH - 24 - 30 , height: model.cellHeight - 8)
    }
    
    
    /// 是否需要底部半圆
    var isNeedCorners: Bool = false{
        didSet{
            if isNeedCorners{
                self.contentView.yxs_addRoundedCorners(corners: [.bottomRight,.bottomLeft], radii: CGSize.init(width: 2.5, height: 2.5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height:model.cellHeight + 8))
            }else{
                self.contentView.yxs_addRoundedCorners(corners: [.bottomRight,.bottomLeft], radii: CGSize.init(width: 0, height: 0), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 15 - 15, height:model.cellHeight))
            }
        }
        
    }
}
