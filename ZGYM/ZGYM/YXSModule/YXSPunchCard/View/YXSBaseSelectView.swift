//
//  YXSBaseSelectView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/3/31.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

import UIKit
import NightNight

private let kMaxtCount = 7

/// 箭头弹窗  只有剧中文本
class YXSBaseSelectView: UIView {
    
    /// 初始化并展示
    /// - Parameters:
    ///   - offset: 位置 x为视图距右边的距离  y为视图的minY
    ///   - selects: 数据
    ///   - selectComplete: 完成回调
    @discardableResult static func showAlert(offset:CGPoint ,selects: [YXSSelectModel] ,selectComplete:((_ index: Int, _ selects:[YXSSelectModel]) ->())? = nil) -> YXSBaseSelectView{
        let view = YXSBaseSelectView.init(offset:offset,selects: selects)
        view.selectComplete = selectComplete
        view.beginAnimation()
        return view
    }
    var selects:[YXSSelectModel]
    var offset:CGPoint
    var selectComplete:((_ index: Int,_ selects:[YXSSelectModel]) ->())?
    init(offset:CGPoint,selects: [YXSSelectModel]) {
        self.selects = selects
        self.offset = offset
        super.init(frame: CGRect.zero)
        addSubview(tableView)
        let outMaxCount = selects.count > kMaxtCount
        tableView.isScrollEnabled = outMaxCount
        tableView.rowHeight = 35
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(35 * ( outMaxCount ? kMaxtCount : selects.count))
            make.bottom.equalTo(0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIUtil.TopViewController().fd_interactivePopDisabled = true
        UIUtil.curruntNav().view.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.clipsToBounds = true
        self.cornerRadius = 2.5
        self.snp.makeConstraints { (make) in
            make.top.equalTo(offset.y)
            make.right.equalTo(-offset.x)
            make.width.equalTo(78.5)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        UIUtil.TopViewController().fd_interactivePopDisabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }
    
    // MARK: -getter
    lazy var whiteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "yxs_white_up", night: "yxs_white_up_night")
        return imageView
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
//        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        view.delegate = self
        view.dataSource = self
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.separatorStyle = UITableViewCell.SeparatorStyle.none;
        if #available(iOS 11.0, *){
            view.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        view.rowHeight = 44
        view.addShadow(ofColor: UIColor(red: 0.58, green: 0.61, blue: 0.67, alpha: 0.35), radius: 16, offset: CGSize(width: 0, height: 0), opacity: 1)
        view.register(YXSBaseSelectViewCell.self, forCellReuseIdentifier: "YXSBaseSelectViewCell")
        return view
    }()
}
extension YXSBaseSelectView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSBaseSelectViewCell") as! YXSBaseSelectViewCell
        cell.titleLabel.text = selects[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectComplete?(indexPath.row,selects)
        dismiss()
    }
}

class YXSBaseSelectViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(titleLabel)
        contentView.yxs_addLine()
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -getter&setter
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
}

