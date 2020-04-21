//
//  YXSSynClassListVC.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import JXCategoryView
import NightNight

class YXSSynClassListVC: YXSBaseTableViewController,JXCategoryListContentViewDelegate {
    
    var type: YXSSynClassListType?
    var gradeTypeList:[YXSSynClassGradeType] = [YXSSynClassGradeType]()
    var gradeTitleList:[String] = [String]()
    func listView() -> UIView! {
        return self.view
    }
    init(type: YXSSynClassListType) {
        super.init()
        self.type = type
        switch type {
        case .PRIMARY_SCHOOL:
            gradeTypeList = [.first_grade, .second_grade, .third_grade, .fourth_grade, .fifth_grade]
            gradeTitleList = ["一年级","二年级","三年级","四年级","五年级"]
        case .MIDDLE_SCHOOL:
            gradeTypeList = [.one_junior, .two_junior, .three_junior]
            gradeTitleList = ["初一","初二","初三"]
        case .HIGH_SCHOOL:
            gradeTypeList = [.one_senior, .two_senior, .three_senior]
            gradeTitleList = ["高一","高二","高三"]
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.register(YXSSynClassListCell.self, forCellReuseIdentifier: "YXSSynClassListCell")
        tableView.tableHeaderView = tableHeaderView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableHeaderView.setTitles(titles: gradeTitleList)
//        self.tableView.reloadData()
    }
    
    func loadTabData() {
        
    }
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  12
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSSynClassListCell") as! YXSSynClassListCell
        cell.yxs_addLine(position: .bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), lineHeight: 0.5)
        return cell
    }
    
    // MARK: - getter&setter
    lazy var tableHeaderView:YXSSynClassListTableHeaderView = {
        let headerView = YXSSynClassListTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 58))
        return headerView
    }()
}

class YXSSynClassListTableHeaderView:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.scrollView.addSubview(self.mas_widthContentView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.mas_widthContentView)
            make.height.equalTo(self.scrollView)
        }
//        self.mas_widthContentView.snp.makeConstraints { (make) in
//            make.top.bottom.left.equalTo(self.scrollView)
//
//        }
//
//        self.contentView.snp.makeConstraints { (make) in
//            make.left.top.bottom.equalTo(0)
//            make.right.equalTo(0)
//            make.height.equalTo(58)
//            make.width.equalTo(SCREEN_WIDTH)
//        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var lastView: UIView = UIView()
    var titles:[String] = [String]()
    func setTitles(titles:[String]) {
        self.titles = titles
        self.contentView.removeSubviews()

        let firstBtn = UIButton()
        firstBtn.tag = 10001
        firstBtn.setTitle(titles.first, for: .normal)
        firstBtn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        firstBtn.setTitleColor(UIColor.white, for: .selected)
        firstBtn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
        firstBtn.layer.cornerRadius = 14
        firstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        firstBtn.layer.masksToBounds = true
        self.contentView.addSubview(firstBtn)
        firstBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.width.equalTo(69)
            make.height.equalTo(28)
        }
        lastView = firstBtn
        var index = 0
        for title in titles {
            if index == 0 {
                index += 1
                continue
            }
            let btn = UIButton()
            btn.tag = 10001 + index
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
            btn.setTitleColor(UIColor.white, for: .selected)
            btn.layer.cornerRadius = 14
            btn.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"))
            btn.layer.masksToBounds = true
            self.contentView.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.left.equalTo(self.lastView.snp_right).offset(8)
                make.top.equalTo(15)
                make.width.equalTo(69)
                make.height.equalTo(28)
            }
            lastView = btn
            index += 1
        }
        self.updateLayout()
    }
    
    func updateLayout() {
        self.mas_widthContentView.snp.remakeConstraints { (make) in
            make.top.bottom.left.equalTo(self.scrollView)
            make.right.equalTo(self.lastView).offset(8)
        }
        
        
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.zero)
        scrollView.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
        return scrollView
    }()
    
    lazy var mas_widthContentView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        return view
    }()
    
    lazy var view1: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var view2: UIView = {
        let view = UIView()
        return view
    }()
    lazy var view3: UIView = {
        let view = UIView()
        return view
    }()
}
