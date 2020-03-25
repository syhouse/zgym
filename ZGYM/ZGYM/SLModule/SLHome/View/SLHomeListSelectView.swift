//
//  SLHomeListSelectView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/22.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//


import UIKit
import NightNight

private let kMaxtCount = 7
class SLSelectModel: NSObject{
    var text: String
    var isSelect: Bool = false
    var paramsKey: String
    init(text: String, isSelect: Bool = false ,paramsKey: String = "") {
        self.text = text
        self.isSelect = isSelect
        self.paramsKey = paramsKey
    }
}

class SLHomeListSelectView: UIView {
    @discardableResult static func showAlert(offset:CGPoint ,selects: [SLSelectModel] ,selectComplete:((_ model: SLSelectModel, _ selects:[SLSelectModel]) ->())? = nil) -> SLHomeListSelectView{
        let view = SLHomeListSelectView.init(offset:offset,selects: selects)
        view.selectComplete = selectComplete
        view.beginAnimation()
        return view
    }
    var selects:[SLSelectModel]
    var offset:CGPoint
    var selectComplete:((_ model: SLSelectModel,_ selects:[SLSelectModel]) ->())?
    init(offset:CGPoint,selects: [SLSelectModel]) {
        self.selects = selects
        self.offset = offset
        super.init(frame: CGRect.zero)
        addSubview(tableView)
        addSubview(whiteImageView)
        
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
        UIUtil.curruntNav().view.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.top.equalTo(offset.y)
            make.right.equalTo(-offset.x)
            make.width.equalTo(143.5)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }
    
    // MARK: -getter
    lazy var whiteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "sl_white_up", night: "sl_white_up_night")
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
        view.register(SLHomeListSelectViewCell.self, forCellReuseIdentifier: "SLHomeListSelectViewCell")
        return view
    }()
}
extension SLHomeListSelectView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLHomeListSelectViewCell") as! SLHomeListSelectViewCell
        cell.sl_setCellModel(selects[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curruntModel = selects[indexPath.row]
        var selectModels = [SLSelectModel]()
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

class SLHomeListSelectViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectButton)
        contentView.sl_addLine(leftMargin: 14)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(selectButton.snp_right).offset(9)
            make.centerY.equalTo(contentView)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 17, height: 17))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: SLSelectModel!
    func sl_setCellModel(_ model: SLSelectModel){
        titleLabel.text = model.text
        selectButton.isSelected = model.isSelect
    }
    var cellBlock: ((_ isSelectTeacher: Bool ) ->())?
    // MARK: -action
    @objc func selectClick(){
        
    }
    
    // MARK: -getter&setter
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var selectButton: SLButton = {
        let button = SLButton.init()
        button.setBackgroundImage(UIImage.init(named: "sl_class_select"), for: .selected)
        button.setBackgroundImage(UIImage.init(named: "sl_class_unselect"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
}

