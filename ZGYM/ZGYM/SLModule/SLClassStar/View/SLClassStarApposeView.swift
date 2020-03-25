//
//  SLClassStarApposeView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/11.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
private let kMaxtCount = 5
private let rowHeight: CGFloat = 57
class SLClassStarApposeView: UIView {
    @discardableResult static func showAlert(childs: [SLClassStarChildrenModel] ,curruntChild: SLClassStarChildrenModel? = nil, sort:Int,stage: StageType) -> SLClassStarApposeView{
        let view = SLClassStarApposeView.init(childs: childs,curruntChild: curruntChild, sort:sort,stage: stage)
        view.beginAnimation()
        return view
    }
    var childs:[SLClassStarChildrenModel]
    var curruntChild: SLClassStarChildrenModel? = nil
    var sort: Int// 排名
    var stage: StageType
    init(childs: [SLClassStarChildrenModel],curruntChild: SLClassStarChildrenModel? = nil, sort:Int,stage: StageType) {
        var isExit = false
        self.childs = childs
        var lists = [SLClassStarChildrenModel]()
        self.sort = sort
        self.stage = stage
        if let curruntChild = curruntChild{
            for model in childs{
                if curruntChild.childrenId == model.childrenId{
                    isExit = true
                }else{
                    model.topNo = sort
                    lists.append(model)
                }
            }
            if isExit{
                lists.insert(curruntChild, at: 0)
            }
            self.childs = lists
        }
        
        
        self.curruntChild = curruntChild
        super.init(frame: CGRect.zero)
        self.addSubview(titleLabel)
        
        self.addSubview(tableView)

        layout()
    }
    
    func layout(){
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(58.5)
        }
        titleLabel.sl_addLine(position: .bottom, leftMargin: 16.5, rightMargin: 20.5, lineHeight: 0.5)
        let outMaxCount = childs.count > kMaxtCount
        tableView.isScrollEnabled = outMaxCount
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(titleLabel.snp_bottom).offset(0)
            make.height.equalTo(rowHeight*CGFloat(( outMaxCount ? kMaxtCount : childs.count)))
            make.bottom.equalTo(0)
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
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(260)
            make.center.equalTo(bgWindow)
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        var title = "冠军"
        if sort == 2{
           title = "亚军"
        }else if sort == 3{
           title = "季军"
        }
        label.text = "并列\(title)"
        return label
    }()
    
    lazy var bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        view.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
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
        view.rowHeight = rowHeight
        return view
    }()
}
extension SLClassStarApposeView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:ClassStarApposeViewCell! = tableView.dequeueReusableCell(withIdentifier: "ClassStarApposeViewCell") as? ClassStarApposeViewCell
        if cell == nil{
            cell = ClassStarApposeViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ClassStarApposeViewCell", stage: stage)
        }
        cell.isLastRow = childs.count - 1 == indexPath.row
        cell.sl_setCellModel(childs[indexPath.row])
        return cell
    }
    
}


class ClassStarApposeViewCell: UITableViewCell {
    var stage: StageType
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?,stage: StageType) {
        self.stage = stage
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(userIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(line)
   
        userIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 41, height: 41))
            make.left.equalTo(20)
            make.centerY.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp_right).offset(15)
            make.centerY.equalTo(userIcon)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-21)
            make.centerY.equalTo(userIcon)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15.5)
            make.right.equalTo(-20.5)
            make.height.equalTo(0.5)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isLastRow: Bool = false{
        didSet{
            line.isHidden = isLastRow
        }
    }
    func sl_setCellModel(_ model: SLClassStarChildrenModel){
        
        nameLabel.text = model.childrenName ?? ""
        scoreLabel.text = "\(model.score ?? 0)\(stage == StageType.KINDERGARTEN ? "朵" : "分")"
       
        userIcon.sd_setImage(with: URL.init(string: model.avatar ?? ""),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
    }
    
    // MARK: -getter&setter
    lazy var userIcon: UIImageView = {
        let userIcon = UIImageView.init(image: kImageUserIconStudentDefualtImage)
        userIcon.cornerRadius = 20.5
        userIcon.contentMode = .scaleAspectFill
        return userIcon
    }()
    
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.sl_hexToAdecimalColor(hex: "#575A60")
        return label
    }()
    
    lazy var scoreLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = kBlueColor
        return label
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = kLineColor
        return line
    }()
    
}
