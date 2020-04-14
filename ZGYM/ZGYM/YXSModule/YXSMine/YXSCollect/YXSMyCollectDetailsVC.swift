//
//  YXSMyCollectDetailsVC.swift
//  HNYMEducation
//
//  Created by yihao on 2020/4/14.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import NightNight
import JXCategoryView

class YXSMyCollectDetailsVC: YXSBaseViewController,UITableViewDelegate, UITableViewDataSource{

    
    var dataSource: [YXSMyCollectModel] = [YXSMyCollectModel]()

    override init(){
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-kSafeBottomHeight)
        }

        self.title = "我的收藏"
        self.loadData()
    }
    
    func loadData() {
        dataSource.removeAll()
        if leftBtn.isSelected {
            let model1 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["voiceName":"爷爷的话","voiceTime":"1:10"])!
            let model2 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["voiceName":"妈妈的话","voiceTime":"1:20"])!
            let model3 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["voiceName":"洗澡歌","voiceTime":"1:30"])!
            let model4 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["voiceName":"小燕子","voiceTime":"1:40"])!
            let model5 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["voiceName":"甩葱歌","voiceTime":"1:50"])!
            dataSource.append(model1)
            dataSource.append(model2)
            dataSource.append(model3)
            dataSource.append(model4)
            dataSource.append(model5)
        } else {
            let model1 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["albumName":"《三字儿歌》","albumSongs":20])!
            let model2 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["albumName":"《儿童卡通金曲》","albumSongs":30])!
            let model3 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["albumName":"《麦杰克儿歌》","albumSongs":16])!
            let model4 : YXSMyCollectModel = YXSMyCollectModel.init(JSON: ["albumName":"《猪迪克儿歌》","albumSongs":8])!
            dataSource.append(model1)
            dataSource.append(model2)
            dataSource.append(model3)
            dataSource.append(model4)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Action
    @objc func headerBtnClick(sender: UIButton) {
        switch sender.tag {
        case 2001:
            leftBtn.isSelected = true
            rightBtn.isSelected = false
            rightBtn.yxs_removeLine()
            leftBtn.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), leftMargin: 40, rightMargin: 40, lineHeight: 2)
        case 2002:
            rightBtn.isSelected = true
            leftBtn.isSelected = false
            leftBtn.yxs_removeLine()
            rightBtn.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), leftMargin: 40, rightMargin: 40, lineHeight: 2)
        default:
            print("")
        }
        self.loadData()
    }
    
    // MARK: - UITableViewDataSource，UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if leftBtn.isSelected {
            let cell: YXSMyCollectDetailsCell = tableView.dequeueReusableCell(withIdentifier: "YXSMyCollectDetailsCell") as! YXSMyCollectDetailsCell
            let model = dataSource[indexPath.row]
            cell.setModel(model: model)
            if indexPath.row == 0 {
                cell.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            }
            cell.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            return cell
        } else {
            let cell: YXSMyCollectAlbumCell = tableView.dequeueReusableCell(withIdentifier: "YXSMyCollectAlbumCell") as! YXSMyCollectAlbumCell
            let model = dataSource[indexPath.row]
            cell.setModel(model: model)
            if indexPath.row == 0 {
                cell.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            }
            cell.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 15, rightMargin: 0, lineHeight: 0.5)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tabHeaderView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if leftBtn.isSelected {
            return 60.0
        } else {
            return 93.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - LazyLoad
    lazy var tabHeaderView: UIView = {
        let tabHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        tabHeaderView.addSubview(leftBtn)
        tabHeaderView.addSubview(rightBtn)
        
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(1)
            make.bottom.equalTo(-1)
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(1)
            make.bottom.equalTo(-1)
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        
        tabHeaderView.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 1)
        return tabHeaderView
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton.init()
        leftBtn.setTitle("声音", for: .normal)
        leftBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        leftBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .selected)
        leftBtn.tag = 2001
        leftBtn.addTarget(self, action: #selector(headerBtnClick(sender:)), for: .touchUpInside)
        leftBtn.isSelected = true
        leftBtn.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), leftMargin: 40, rightMargin: 40, lineHeight: 2)
        return leftBtn
    }()
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton.init()
        rightBtn.setTitle("专辑", for: .normal)
        rightBtn.tag = 2002
        rightBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        rightBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .selected)
        rightBtn.addTarget(self, action: #selector(headerBtnClick(sender:)), for: .touchUpInside)
        return rightBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mixedBackgroundColor = MixedColor.init(normal: UIColor.white, night: kNightBackgroundColor)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        tableView.estimatedSectionHeaderHeight = 0
        //去除group空白
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.fd_debugLogEnabled = true
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(YXSMyCollectDetailsCell.self, forCellReuseIdentifier: "YXSMyCollectDetailsCell")
        tableView.register(YXSMyCollectAlbumCell.self, forCellReuseIdentifier: "YXSMyCollectAlbumCell")
        return tableView
    }()
}
