//
//  YXSHomeworkThumbnailsView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSHomeworkThumbnailsView: UIView {
    
    var touchedAtIndexBlock: ((_ imageView: UIImageView, _ index:Int)->())?
    private var inner:CGFloat! = 10
    private var itemWidth:CGFloat! = 0
    private var itemHeight:CGFloat! = 0
    private var leftMargin:CGFloat! = 0
    private var rightMargin:CGFloat! = 0
    
    /// 重要 leftMargin、rightMargin 是指针对屏幕(用来计算Item的宽高)
    init(leftMargin:CGFloat = 0, rightMargin:CGFloat = 0, inner:CGFloat = 10) {
        super.init(frame: CGRect.zero)
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.inner = inner
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setter
    var images:[String]? {
        didSet {
            self.removeSubviews()
            
//            self.itemWidth = (SCREEN_WIDTH - self.inner*2 - self.leftMargin - self.rightMargin) / 3.0
            let totalInner = SCREEN_WIDTH - self.frame.size.width
            self.itemWidth = (SCREEN_WIDTH - self.inner*2 - totalInner) / 3.0
            self.itemHeight = itemWidth
            if images == nil{
                return
            }
            var rowNumber = self.images!.count / 3
            rowNumber += self.images!.count % 3 > 0 ? 1:0
            
            var height:CGFloat = CGFloat() * itemHeight
            height += CGFloat(rowNumber) * (itemHeight + inner) - inner
            
            let view = UIView()
           view.backgroundColor = UIColor.clear
           self.addSubview(view)
           view.snp.makeConstraints({ (make) in
               make.edges.equalTo(0)
               make.width.equalTo(SCREEN_WIDTH)
               make.height.equalTo(height)
           })
                   
            for i in 0..<(self.images ?? [String]()).count {
               let img = UIImageView()
                img.contentMode = .scaleAspectFill
                img.sd_setImage(with: URL.init(string: self.images?[i] ?? ""),placeholderImage: kImageDefualtImage, completed: nil)
               img.tag = i
//               img.backgroundColor = UIColor.green
                img.isUserInteractionEnabled = true
                img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTouched(sender:))))
               self.addSubview(img)
               
               let line: Int = i/3
               let column: Int = i%3
               let horizontalInner: CGFloat = CGFloat(line) * inner//line>0 ? CGFloat(inner) : 0
               let verticalInner: CGFloat = CGFloat(column) * inner//column>0 ? CGFloat(inner) : 0
               
               img.snp.makeConstraints({ (make) in
                   make.top.equalTo(CGFloat(line) * itemHeight + horizontalInner)
                   make.left.equalTo(CGFloat(column) * itemHeight + verticalInner)
                   make.width.equalTo(itemHeight)
                   make.height.equalTo(itemHeight)
               })
           }
        }
    }
    
    
    var isVideo: Bool? {
        didSet {
            if self.isVideo ?? false {
                imgPlayIcon.isHidden = false
                let firstImageView = getFirstImageView()
                if firstImageView != nil {
                    self.addSubview(imgPlayIcon)
                    imgPlayIcon.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(firstImageView!.snp_centerX)
                        make.centerY.equalTo(firstImageView!.snp_centerY)
//                        make.width.equalTo(itemHeight)
//                        make.height.equalTo(itemHeight)
                    })
                }

            } else {
                imgPlayIcon.isHidden = true
            }
        }
    }
    
    // MARK: - ImageTouched
    @objc func imageTouched(sender: UITapGestureRecognizer) {
        if sender.view is UIImageView {
            let view: UIImageView = sender.view as! UIImageView
            touchedAtIndexBlock?(view, view.tag)
        }
    }
    
//    init(thumbnails:[String], itemSize:CGSize = CGSize(width: 110, height: 110), inner:CGFloat = 10) {
//        super.init(frame: CGRect.zero)
//
//        var height:CGFloat = CGFloat(thumbnails.count / 3) * itemSize.height
//        height += CGFloat(thumbnails.count % 3) * itemSize.height
//
//        let view = UIView()
//        view.backgroundColor = UIColor.clear
//        self.addSubview(view)
//        view.snp.makeConstraints({ (make) in
//            make.edges.equalTo(0)
//            make.width.equalTo(SCREEN_WIDTH)
//            make.height.equalTo(height)
//        })
//
//        for i in 0..<thumbnails.count {
//            let img = UIImageView()
//            img.tag = i
//            img.backgroundColor = UIColor.green
//            self.addSubview(img)
//
//            let line: Int = i/3
//            let column: Int = i%3
//            let horizontalInner: CGFloat = CGFloat(line) * inner//line>0 ? CGFloat(inner) : 0
//            let verticalInner: CGFloat = CGFloat(column) * inner//column>0 ? CGFloat(inner) : 0
//
//            img.snp.makeConstraints({ (make) in
//                make.top.equalTo(CGFloat(line) * itemSize.height + horizontalInner)
//                make.left.equalTo(CGFloat(column) * itemSize.height + verticalInner)
//                make.width.equalTo(itemSize.height)
//                make.height.equalTo(itemSize.height)
//            })
//        }
//    }
    

    // MARK: - LazyLoad
    lazy private var imgPlayIcon: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = false
        img.image = UIImage(named: "yxs_publish_play")
        return img
    }()
    
    
    // MARK: - Other
    @objc func getFirstImageView()-> UIImageView? {
        var firstImageView: UIImageView?
        for sub in self.subviews {
            if sub.tag == 0 {
                if sub is UIImageView {
                    firstImageView = sub as? UIImageView
                    break
                }
            }
        }
        return firstImageView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
