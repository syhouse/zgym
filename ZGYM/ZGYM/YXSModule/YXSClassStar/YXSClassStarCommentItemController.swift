//
//  YXSClassStarCommentItemController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/23.
//  Copyright © 2020 zgym. All rights reserved.
//


import UIKit
import JXCategoryView
import NightNight

private let controlOrginTag = 101

class YXSClassStarCommentItemController: YXSBaseViewController, JXCategoryListContentViewDelegate {
    let canCommentDataSource: [YXSClassStarCommentItemModel]
    var didCommentDataSource: [YXSClassStarCommentItemModel]?{
        didSet{
            if let didCommentSource = didCommentDataSource, didCommentSource.count != 0{
                bottomLabel.text = "今日已点评"
                offsetX = 15
                for (index,model) in didCommentSource.enumerated(){
                    let view = ClassStarCommentItemView()
                    view.titleLabel.text = model.evaluationItem
                    view.scoreLabel.text = "\(model.score ?? 0)"
                    let width = view.titleLabel.sizeThatFits(CGSize(width: 200, height: 30)).width + 26
                    if offsetX + 15.0 + width + 15.0 > self.view.width {
                        offsetY += 21.0 + itemHeight
                        offsetX = 15
                    }else{
                        offsetX += 15
                    }
                    view.tag = controlOrginTag + index + canCommentDataSource.count
                    view.frame = CGRect.init(x: offsetX, y: offsetY, width: width, height: itemHeight)
                    view.addTaget(target: self, selctor: #selector(controlClick))
                    offsetX += width
                    self.scrollView.addSubview(view)
                }
                self.scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH, height: offsetY + 34 + 12)
            }
        }
    }
    let childrenIds: [Int]
    let classId: Int
    let stage: StageType
    ///类型(10:表扬,20:待改进)
    let category: Int
    init(canCommentDataSource: [YXSClassStarCommentItemModel], childrens: [Int], classId: Int, stage: StageType, category: Int) {
        self.canCommentDataSource = canCommentDataSource
        self.childrenIds = childrens
        self.classId = classId
        self.stage = stage
        self.category = category
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var offsetY: CGFloat = 25
    var offsetX: CGFloat = 15
    let itemHeight: CGFloat = 34
    override func viewDidLoad() {
        self.view.addSubview(self.scrollView)
        for (index,model) in canCommentDataSource.enumerated(){
            let view = ClassStarCommentItemView()
            view.titleLabel.text = model.evaluationItem
            view.scoreLabel.text = "\(model.score ?? 0)"
            let width = view.titleLabel.sizeThatFits(CGSize(width: 200, height: 30)).width + 26
            if offsetX + 15.0 + width + 15.0 > self.view.width {
                offsetY += 21.0 + itemHeight
                offsetX = 15
            }else{
                offsetX += 15
            }
            view.tag = controlOrginTag + index
            view.frame = CGRect.init(x: offsetX, y: offsetY, width: width, height: itemHeight)
            view.addTaget(target: self, selctor: #selector(controlClick))
            offsetX += width
            self.scrollView.addSubview(view)
        }
        
        
        if childrenIds.count == 1{
            loadTodayListData()
            self.scrollView.addSubview(bottomLabel)
            self.scrollView.addSubview(leftLine)
            self.scrollView.addSubview(rightLine)
            bottomLabel.frame = CGRect.init(x: (self.view.width - 82)/2, y: offsetY + 34 + 26, width: 82, height: 16)
            leftLine.frame = CGRect.init(x: 0, y: 0, width: 47.5, height: 1)
            leftLine.yxs_right = bottomLabel.yxs_left - 8
            leftLine.yxs_top = bottomLabel.yxs_top + 7.5
            rightLine.frame = CGRect.init(x: 0, y: 0, width: 47.5, height: 1)
            rightLine.yxs_left = bottomLabel.yxs_right + 8
            rightLine.yxs_top = bottomLabel.yxs_top + 7.5
            offsetY += 68.5 + 34
        }else{
            offsetY += 34 + 12
        }
        
        self.scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH, height: offsetY)
    }

    var didSelectItems:((_ item: YXSClassStarCommentItemModel) -> ())?
    
    func loadTodayListData(){
        YXSEducationClassStarEvaluationListTodayListRequest(category: category, childrenId: childrenIds.first ?? 0, classId: classId, stage: stage).requestCollection({ (lists: [YXSClassStarCommentItemModel]) in
            self.didCommentDataSource = lists
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    @objc func controlClick(tap: UITapGestureRecognizer){
        let index = (tap.view?.tag ?? controlOrginTag) - controlOrginTag
        if index < canCommentDataSource.count{
            didSelectItems?(canCommentDataSource[index])
        }else if let didCommentDataSource = didCommentDataSource{
            didSelectItems?(didCommentDataSource[index - canCommentDataSource.count])
        }
        
    }
    
    func listView() -> UIView! {
        return self.view
    }
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (64 + kSafeTopHeight) - 49 - 49))
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        label.text = "今日未点评"
        return label
    }()
    
    lazy var leftLine: UIView = {
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D8DADD")
        return leftLine
    }()
    
    lazy var rightLine: UIView = {
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#D8DADD")
        return rightLine
    }()
}
//34  13  13
class ClassStarCommentItemView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgView)
        bgView.addSubview(titleLabel)
        self.addSubview(scoreLabel)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(-9.5)
            make.width.height.equalTo(19)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), night: kNight898F9A)
        return label
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        bgView.cornerRadius = 17
        return bgView
    }()
    
    lazy var scoreLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.cornerRadius = 9
        label.borderWidth = 1
        label.textColor = UIColor.white
        label.borderColor = UIColor.white
        label.backgroundColor = kBlueColor
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
}
