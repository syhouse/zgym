//
//  SLHomeChildView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/18.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import SnapKit
import NightNight

private let imageSize = CGSize.init(width: 41, height: 41)
private let padding: CGFloat = 8.5
private let leftGap: CGFloat = 15.5

private let kYMHomeChildViewImageTag = 101

let kYMHomeChildViewUpdateEvent = "SLHomeChildViewUpdateEvent"
let kYMHomeChildViewAddChild = "kYMHomeChildViewAddChild"

class SLHomeChildView: UIControl {
    var kMaxCount: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(addChildButton)
        kMaxCount = Int((SCREEN_WIDTH - leftGap * 2)/(imageSize.width + padding))
        for index in 0..<kMaxCount{
            let childView = HomeChildIconView.init(frame: CGRect.zero)
            childView.tag = kYMHomeChildViewImageTag + index
            childView.imageView.contentMode = .scaleAspectFill
            childView.addTaget(target: self, selctor: #selector(imageClick))
            addSubview(childView)
        }
        addSubview(curruntLabel)
        nameLabel.isHidden = true
        curruntLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageClick(_ tap: UITapGestureRecognizer){
        let index = (tap.view?.tag ?? 0) - kYMHomeChildViewImageTag
        print("\(index)")
        let curruntId = childs[index].id ?? 0
        if let userCurruntId = sl_user.curruntChild?.id{
            if userCurruntId == curruntId{
                return
            }
        }
        UserDefaults.standard.set(curruntId, forKey: kHomeChildKey)
        sl_user.curruntChild = childs[index]
        next?.sl_routerEventWithName(eventName: kYMHomeChildViewUpdateEvent)
    }
    
    var childs: [SLChildrenModel]!
    func setModels(_ models: [SLChildrenModel]?){
        for index in 0..<kMaxCount{
            let image = viewWithTag(index + kYMHomeChildViewImageTag)
            image?.isHidden = true
            image!.snp.removeConstraints()
        }
        nameLabel.isHidden = true
        curruntLabel.isHidden = true
        addChildButton.isHidden = true
        if let models = models{
            childs = models
            if models.count >= 1{
                nameLabel.isHidden = false
                var selectIndex = 0
                for index in 0..<models.count{
                    if models[index].isSelect {
                        selectIndex = index
                    }
                }
                var last: UIView?
                for (index,model) in models.enumerated(){
                    let childView = viewWithTag(index + kYMHomeChildViewImageTag) as! HomeChildIconView
                    var imageSize = CGSize.init(width: 41, height: 41)
                    if index == selectIndex{
                        nameLabel.text = model.realName
                        curruntLabel.isHidden = false
                        childView.isSelect = true
                        childView.snp.remakeConstraints { (make) in
                            if let last = last{
                                make.left.equalTo(last.snp_right).offset(padding)
                            }else{
                                make.left.equalTo(15.5)
                            }
                            make.centerY.equalTo(self)
                            make.size.equalTo(imageSize)
                        }
                        
                        nameLabel.snp.remakeConstraints { (make) in
                            make.left.equalTo(childView.snp_right).offset(padding)
                            make.centerY.equalTo(self)
                            
                            if index == models.count - 1{
                                make.right.equalTo(-15)
                            }
                        }
                        curruntLabel.snp.remakeConstraints { (make) in
                            make.centerX.equalTo(childView)
                            make.size.equalTo(CGSize.init(width: 32, height: 14))
                            make.top.equalTo(nameLabel.snp_bottom).offset(3)
                        }
                    }else{
                        childView.isSelect = false
                        imageSize = CGSize.init(width: 36, height: 36)
                        
                        childView.snp.remakeConstraints { (make) in
                            if let last = last{
                                if index - 1 == selectIndex{
                                    make.left.equalTo(nameLabel.snp_right).offset(padding)
                                }else{
                                    make.left.equalTo(last.snp_right).offset(padding)
                                }
                                
                            }else{
                                make.left.equalTo(15.5)
                            }
                            make.centerY.equalTo(self)
                            make.size.equalTo(imageSize)
                            
                            if index == models.count - 1{
                                make.right.equalTo(-15)
                            }
                        }
                        
                    }
                    last = childView
                    childView.imageView.borderWidth = 1
                    childView.imageView.cornerRadius = imageSize.width/2
                    childView.masView.cornerRadius = imageSize.width/2
                    childView.isHidden = false
                    childView.imageView.sl_setImageWithURL(url:  URL(string: models[index].avatar ?? ""), placeholder: kImageUserIconStudentDefualtMixedImage)
                    childView.redView.isHidden = SLLocalMessageHelper.shareHelper.sl_localMessageCount(childId: models[index].id) == 0 ? true : false
                }
            }
            else{
                addChildButton.isHidden = false
                addChildButton.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.top.bottom.right.equalTo(0)
                }
            }
        }else{
            addChildButton.isHidden = false
            addChildButton.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.bottom.right.equalTo(0)
            }
        }
    }
    // MARK: -action
    @objc func addChildClick(){
        sl_routerEventWithName(eventName: kYMHomeChildViewAddChild)
    }
    
    // MARK: - getter&setter
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mixedTextColor = MixedColor(normal: kTextBlackColor, night: UIColor.white)
        return label
    }()
    
    lazy var addChildButton: SLButton = {
        let label = SLButton()
        label.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        label.setMixedTitleColor(MixedColor(normal: kTextMainBodyColor, night: UIColor.white), forState: .normal)
        label.addTarget(self, action: #selector(addChildClick), for: .touchUpInside)
        label.setTitle("尚未添加班级，去添加", for: .normal)
        label.isHidden = true
        return label
    }()
    
    lazy var curruntLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        label.backgroundColor = kBlueColor
        label.cornerRadius = 7
        label.text = "当前"
        label.textAlignment = .center
        return label
    }()
}


class HomeChildIconView: UIView {
    var isSelect: Bool = false{
        didSet{
            if isSelect{
                self.imageView.borderColor = kBlueColor
                masView.isHidden = true
            }else{
                self.imageView.borderColor = UIColor.white
                masView.isHidden = false
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(masView)
        self.addSubview(redView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        masView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        redView.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.size.equalTo(CGSize.init(width: 11, height: 11))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var masView: UIView = {
        let masView = UIView()
        masView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        return masView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var redView: UIView = {
        let redView = UIView()
        redView.cornerRadius = 5.5
        redView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#E8534C")
        redView.isHidden = true
        return redView
    }()
}
