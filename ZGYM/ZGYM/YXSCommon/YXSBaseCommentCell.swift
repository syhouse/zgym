//
//  YXSBaseCommentCell.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/9.
//  Copyright © 2020 hmym. All rights reserved.
//

import YYText
import NightNight

class YXSBaseCommentCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#292B3A"))
        contentView.addSubview(comentLabel)
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(longTap(_:)))
        contentView.addGestureRecognizer(longTap)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var commentBlock: (() -> ())?
    var cellLongTapEvent: ((_ point: CGPoint) -> ())?
    @objc func longTap(_ longTap: UILongPressGestureRecognizer){
        if longTap.state == UIGestureRecognizer.State.ended{
            if canDelect{
                var point = longTap.location(in: longTap.view)
                point.x += self.frame.origin.x
                cellLongTapEvent?(point)
            }
        }
    }
    /// 是否可以长按删除
    var canDelect :Bool = false
    
    lazy var comentLabel: YYLabel = {
        let label = YYLabel()
        label.font = YXSFriendsConfigHelper.helper.commentFont
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - YYLabel异步优化有问题   点赞取消点赞 评论cell会闪动
    //    func yxs_setCellModel(_ model: YXSFriendsCommentModel){
    //        DispatchQueue.global().async {
    //            self.model = model
    //            var text:NSMutableAttributedString
    //            var length: Int
    //
    //            let textNormalColor = NightNight.theme == .night ? UIColor.white : kTextMainBodyColor
    //            if let toPerson = model.showUserNameReplied{
    //                text = NSMutableAttributedString(string: "\(model.showUserName ?? "")回复\(toPerson)：\(model.content ?? "")")
    //                text.yy_setFont(YXSFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
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
    //                text.yy_setFont(YXSFriendsConfigHelper.helper.commentFont, range: text.yy_rangeOfAll())
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
    //            let titleContainer:YYTextContainer = YYTextContainer.init(size: CGSize.init(width: YXSFriendsConfigHelper.helper.commentWidth - 20, height: model.getTextHeight() + 5))
    //            let titleLayout:YYTextLayout = YYTextLayout.init(container: titleContainer, text: text)!
    //            DispatchQueue.main.async {
    //                //        comentLabel.frame = CGRect.init(x: 10, y: 5, width:YXSFriendsConfigHelper.helper.commentWidth , heigh`t: model.getTextHeight())
    //                self.comentLabel.frame = CGRect.init(x: 10, y: 2.5, width:titleLayout.textBoundingSize.width , height: titleLayout.textBoundingSize.height)
    //                self.comentLabel.textLayout = titleLayout
    //            }
    //        }
    //
    //    }
    //
    //    lazy var comentLabel: YYLabel = {
    //        let label = YYLabel()
    //        label.font = YXSFriendsConfigHelper.helper.commentFont
    //
    //        label.numberOfLines = 0
    //        return label
    //    }()
    
}
