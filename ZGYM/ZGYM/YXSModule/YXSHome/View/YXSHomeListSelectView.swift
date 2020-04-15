//
//  SLHomeListSelectView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/22.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//


import UIKit
import NightNight
import FDFullscreenPopGesture_Bell

private let kMaxtCount = 7
class YXSSelectModel: NSObject{
    ///展示文字
    var text: String
    ///是否选中
    var isSelect: Bool = false
    ///用来做请求的参数
    var paramsKey: String
    init(text: String, isSelect: Bool = false ,paramsKey: String = "") {
        self.text = text
        self.isSelect = isSelect
        self.paramsKey = paramsKey
    }
}

///带选择框的筛选视图
class YXSHomeListSelectView: UIView {
    
    /// 类方法初始化
    /// - Parameters:
    ///   - offset: x(距离右边框的x)  y(miny)
    ///   - selects: 列表modle
    ///   - selectComplete: 选中回调
    @discardableResult static func showAlert(offset:CGPoint ,isShowSelectBtn: Bool = true,selects: [YXSSelectModel] ,selectComplete:((_ model: YXSSelectModel, _ selects:[YXSSelectModel]) ->())? = nil) -> YXSHomeListSelectView{
        let view = YXSHomeListSelectView.init(offset:offset,isShowSelectBtn: isShowSelectBtn,selects: selects)
        view.selectComplete = selectComplete
        view.beginAnimation()
        return view
    }
    var selects:[YXSSelectModel]
    var offset:CGPoint
    var viewWidth: CGFloat = 143.5
    var isShowSelectBtn: Bool = true
    var selectComplete:((_ model: YXSSelectModel,_ selects:[YXSSelectModel]) ->())?
    init(offset:CGPoint,isShowSelectBtn: Bool = true,selects: [YXSSelectModel]) {
        self.selects = selects
        self.offset = offset
        self.isShowSelectBtn = isShowSelectBtn
        super.init(frame: CGRect.zero)
        addSubview(tableView)
        addSubview(whiteImageView)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        for model in selects{
            label.text = model.text
            label.sizeToFit()
            viewWidth = viewWidth > label.width + 14 * 2 + 17 ? viewWidth : (label.width + 14 * 2 + 17)
        }
        //阴影设置
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4.0
//        self.layer.masksToBounds = true
        let outMaxCount = selects.count > kMaxtCount
        tableView.isScrollEnabled = outMaxCount
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(whiteImageView.snp_bottom)
            make.height.equalTo(44 * ( outMaxCount ? kMaxtCount : selects.count))
            make.bottom.equalTo(0)
        }
        whiteImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-12.5)
            make.size.equalTo(CGSize.init(width: 12.5, height: 6))
            make.top.equalTo(0)
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
        
        self.snp.makeConstraints { (make) in
            make.top.equalTo(offset.y)
            make.right.equalTo(-offset.x)
            make.width.equalTo(viewWidth)
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
    
    // MARK: - getter
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
//        view.addShadow(ofColor: UIColor(red: 0.58, green: 0.61, blue: 0.67, alpha: 0.35), radius: 16, offset: CGSize(width: 0, height: 0), opacity: 1)
        view.register(YXSHomeListSelectViewCell.self, forCellReuseIdentifier: "YXSHomeListSelectViewCell")
        return view
    }()
}
extension YXSHomeListSelectView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSHomeListSelectViewCell") as! YXSHomeListSelectViewCell
        cell.yxs_setCellModel(selects[indexPath.row])
        if isShowSelectBtn {
            cell.yxs_selectButton.isHidden = false
            cell.yxs_titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(cell.yxs_selectButton.snp_right).offset(9)
                make.centerY.equalTo(cell.contentView)
            }

            cell.yxs_selectButton.snp.remakeConstraints { (make) in
                make.left.equalTo(14)
                make.centerY.equalTo(cell.contentView)
                make.size.equalTo(CGSize.init(width: 17, height: 17))
            }
        } else {
            cell.yxs_titleLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(cell.contentView)
                make.left.equalTo(14)
            }
            cell.yxs_selectButton.snp.removeConstraints()
            cell.yxs_selectButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curruntModel = selects[indexPath.row]
        var selectModels = [YXSSelectModel]()
        for model in selects{
            if model.text == curruntModel.text{
                model.isSelect = true
            }else{
                model.isSelect = false
            }
            selectModels.append(model)
        }
        selectComplete?(curruntModel,selectModels)
        dismiss()
    }
}

class YXSHomeListSelectViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(yxs_titleLabel)
        contentView.addSubview(yxs_selectButton)
        contentView.yxs_addLine(leftMargin: 14)
        
        yxs_titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_selectButton.snp_right).offset(9)
            make.centerY.equalTo(contentView)
        }
        
        yxs_selectButton.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 17, height: 17))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: YXSSelectModel!
    func yxs_setCellModel(_ model: YXSSelectModel){
        yxs_titleLabel.text = model.text
        yxs_selectButton.isSelected = model.isSelect
    }
    var cellBlock: ((_ isSelectTeacher: Bool ) ->())?
    // MARK: -action
    @objc func selectClick(){
        
    }
    
    // MARK: -getter&setter
    lazy var yxs_titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var yxs_selectButton: YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_class_select"), for: .selected)
        button.setBackgroundImage(UIImage.init(named: "yxs_class_unselect"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
}

