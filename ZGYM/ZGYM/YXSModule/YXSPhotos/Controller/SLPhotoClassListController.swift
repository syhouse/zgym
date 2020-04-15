//
//  SLPhotoClassListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/2/27.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper

import MBProgressHUD

class SLPhotoClassClassListCell: SLClassBaseListCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        bgView.addSubview(photoCountButton)
        photoCountButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-44)
            make.size.equalTo(CGSize.init(width: 65, height: 19))
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var model:SLClassModel!
    func yxs_setCellModel(_ model: SLClassModel){
        self.model = model
        nameLabel.text = model.name
        numberLabel.text = "班级号：\(model.num ?? "")"
        memberLabel.text = "成员：\(model.members ?? 0)"
        
//        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), for: .disabled)
    }
    
    lazy var photoCountButton: UIButton = {
        let button = UIButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), for: .disabled)
        button.setTitle("暂无相册", for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#E1EBFE")), for: .normal)
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#E6E9F0")), for: .disabled)
        button.isUserInteractionEnabled = false
        return button
    }()
    
}

class SLPhotoClassListController: YXSBaseTableViewController {
    var dataSource: [SLClassModel] = [SLClassModel]()
    override init() {
        super.init()
        showBegainRefresh = false
        hasRefreshHeader = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "班级相册"
        
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        tableView.register(SLPhotoClassClassListCell.self, forCellReuseIdentifier: "SLPhotoClassClassListCell")
        tableView.rowHeight = 84
        
        yxs_loadData()
    }
    
    func yxs_loadData() {
        YXSEducationGradeListRequest().request({ (json) in
            let joinClassList = Mapper<SLClassModel>().mapArray(JSONString: json["listJoin"].rawString()!) ?? [SLClassModel]()
            let listCreate = Mapper<SLClassModel>().mapArray(JSONString: json["listCreate"].rawString()!) ?? [SLClassModel]()
            
            self.dataSource = joinClassList + listCreate
            self.tableView.reloadData()
        }) { (msg, code) in
            self.view.makeToast("\(msg)")
        }
    }
    
    // MARK: -UI
    
    // MARK: -action
    @objc func addPhotoClick(){
        
    }
    
    // MARK: -private
    
    // MARK: -public
    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLPhotoClassClassListCell") as! SLPhotoClassClassListCell
        cell.selectionStyle = .none
        cell.yxs_setCellModel(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classId = dataSource[indexPath.row].id ?? 0
        let vc = SLPhotoClassPhotoAlbumListController(classId: classId)
        self.navigationController?.pushViewController(vc)
    }
    
    
    
//    override func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
//        return showEmptyDataSource
//    }
    
//    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
//        let view = SLBaseEmptyView()
//        view.frame = self.view.frame
//        view.imageView.mixedImage = MixedImage(normal: "yxs_photo_nodata", night: "yxs_photo_nodata")
//        view.label.text = "你还没有创建过相册哦"
//        view.button.setTitle("新建相册", for: .normal)
//        view.button.setTitleColor(UIColor.white, for: .normal)
//        view.button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        view.button.addTarget(self, action: #selector(addPhotoClick), for: .touchUpInside)
//        view.button.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
//        view.button.yxs_shadow(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 57, height: 49), color: UIColor(red: 0.3, green: 0.45, blue: 0.96, alpha: 0.5), cornerRadius:  24.5, offset: CGSize(width: 0, height: 3))
//        return view
//    }
    // MARK: - getter&setter
}

