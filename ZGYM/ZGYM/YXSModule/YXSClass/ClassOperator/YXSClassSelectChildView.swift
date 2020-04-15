//
//  YXSClassSelectChildView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/21.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
private let kMaxtCount = 3
class YXSClassSelectChildView: UIView {
    @discardableResult @objc static func showAlert(childs: [YXSChildrenModel] ,leftClick:(() ->())? = nil,rightClick:((_ model: YXSChildrenModel) ->())? = nil) -> YXSClassSelectChildView{
        let view = YXSClassSelectChildView.init(childs: childs)
        view.rightClick = rightClick
        view.leftClick = leftClick
        view.beginAnimation()
        return view
    }
    var childs:[YXSChildrenModel]
    var rightClick:((_ model: YXSChildrenModel) ->())?
    var leftClick:(() ->())?
    init(childs: [YXSChildrenModel]) {
        self.childs = childs
        super.init(frame: CGRect.zero)
        
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        self.addSubview(leftButton)
        self.addSubview(rightButton)

        leftButton.yxs_addLine(position: .top, lineHeight: 0.5)
        rightButton.yxs_addLine(position: .top, lineHeight: 0.5)
        leftButton.yxs_addLine(position: .right, lineHeight: 0.5)
        layout()
    }
    
    func layout(){
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.top.equalTo(24)
        }
        
        let outMaxCount = childs.count > kMaxtCount
        tableView.isScrollEnabled = outMaxCount
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titleLabel.snp_bottom).offset(9)
            make.height.equalTo(68 * ( outMaxCount ? kMaxtCount : childs.count))
        }

        leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(tableView.snp_bottom).offset(9)
            make.left.equalTo(0)
        }
        rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(leftButton)
            make.right.equalTo(0)
            make.left.equalTo(leftButton.snp_right)
            make.width.equalTo(leftButton)
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
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(57.5)
            make.right.equalTo(-57.5)
            make.centerY.equalTo(bgWindow)
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
    
    @objc func certainClick(){
        dismiss()
        var selectModel: YXSChildrenModel?
        for model in childs {
            if model.isSelect{
                 selectModel = model
                break
            }
        }
        
        if let selectModel = selectModel{
            rightClick?(selectModel)
        }else{
            MBProgressHUD.yxs_showMessage(message: "请选择孩子")
        }
    }
    
    @objc func cancelClick(){
        dismiss()
        leftClick?()
        
    }
    
    // MARK: -getter
    
    lazy var titleLabel : UILabel = {
        let view = getLabel(text: "选择孩子")
        view.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#000000")
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()

    
    lazy var leftButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#797B7E"), for: .normal)
        button.setTitle("新增", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = UITableViewCell.SeparatorStyle.none;
        if #available(iOS 11.0, *){
            view.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        view.rowHeight = 68
        view.register(SLClassSelectChildViewCell.self, forCellReuseIdentifier: "SLClassSelectChildViewCell")
        return view
    }()
}
extension YXSClassSelectChildView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLClassSelectChildViewCell") as! SLClassSelectChildViewCell
        cell.yxs_setCellModel(childs[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for model in childs {
             model.isSelect = false
        }
        let curruntModel = childs[indexPath.row]
        curruntModel.isSelect = true
        tableView.reloadData()
    }
    
}

class SLClassSelectChildViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(selectButton)

        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(33)
            make.top.equalTo(15)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp_bottom).offset(9)
        }

        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-33)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 17, height: 17))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: YXSChildrenModel!
    func yxs_setCellModel(_ model: YXSChildrenModel){
        self.model = model
        nameLabel.text = model.realName
        numberLabel.text = "学号：\(model.studentId ?? "")"
        selectButton.isSelected = model.isSelect
    }
    var cellBlock: ((_ isSelectTeacher: Bool ) ->())?
    // MARK: -action
    @objc func selectClick(){
//        model.isSelect = !
    }
    
    // MARK: -getter&setter
    lazy var nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var numberLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return label
    }()

    lazy var selectButton: YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_class_select"), for: .selected)
        button.setBackgroundImage(UIImage.init(named: "yxs_class_unselect"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()

}

