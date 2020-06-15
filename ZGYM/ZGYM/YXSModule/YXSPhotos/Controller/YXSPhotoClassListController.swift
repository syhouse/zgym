//
//  YXSPhotoClassListController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
import MBProgressHUD

/// 相册的班级列表
class YXSPhotoClassListController: YXSBaseTableViewController {
    var dataSource: [YXSPhotoClassListCellModel] = [YXSPhotoClassListCellModel]()
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
        tableView.register(YXSPhotoClassClassListCell.self, forCellReuseIdentifier: "YXSPhotoClassClassListCell")
        tableView.rowHeight = 84
        
        yxs_loadData()
    }
    
    public func yxs_loadData() {
        
        YXSEducationAlbumQueryClassListRequest(stage: YXSPersonDataModel.sharePerson.personStage).requestCollection({ [weak self](list: [YXSPhotoClassListCellModel]) in
            guard let weakSelf = self else {return}
            weakSelf.dataSource = list
            weakSelf.tableView.reloadData()
            
        }) { (msg, code) in
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
    
    // MARK: - Action
    @objc func addPhotoClick(){
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSPhotoClassClassListCell") as! YXSPhotoClassClassListCell
        cell.selectionStyle = .none
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classId = dataSource[indexPath.row].classId ?? 0
//        let albumId = dataSource[indexPath.row].alb
        let vc = YXSPhotoClassPhotoAlbumListController(classId: classId)
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

