//
//  SLChoseFileViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

/// 从书包选择文件
class YXSChoseFileViewController: YXSBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择文件"
        
        // Do any additional setup after loading the view.
        tableView.backgroundColor = kTableViewBackgroundColor
        tableView.register(YXSFileGroupCell.classForCoder(), forCellReuseIdentifier: "SLFileGroupCell")
        tableView.register(YXSFileAbleSlectedCell.classForCoder(), forCellReuseIdentifier: "SLFileAbleSlectedCell")
        
        tableView.snp.remakeConstraints { (make) in
            make.left.top.right.equalTo(0)
        }
            
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(tableView.snp_bottom).offset(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(60)
        })
    }
    
    // MARK: - Action
    @objc func doneClick(sender: YXSButton) {
        
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: YXSFileGroupCell = tableView.dequeueReusableCell(withIdentifier: "SLFileGroupCell") as! YXSFileGroupCell
            cell.lbTitle.text = "文件夹"
            return cell
            
        } else {
            let cell: YXSFileAbleSlectedCell = tableView.dequeueReusableCell(withIdentifier: "SLFileAbleSlectedCell") as! YXSFileAbleSlectedCell
            cell.lbTitle.text = "十万个为什么.pdf"
            cell.lbSubTitle.text = "56M"
            cell.lbThirdTitle.text = "05/02"
            switch indexPath.row {
                case 0:
                    cell.imgIcon.image = UIImage(named: "yxs_file_excel")
                case 1:
                    cell.imgIcon.image = UIImage(named: "yxs_file_pdf")
                case 2:
                    cell.imgIcon.image = UIImage(named: "yxs_file_ppt")
                default:
                    cell.imgIcon.image = UIImage(named: "yxs_file_word")
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            navigationController?.pushViewController(YXSChoseFileViewController())
            
        } else {
            let cell: YXSFileAbleSlectedCell = tableView.cellForRow(at: indexPath) as! YXSFileAbleSlectedCell
            cell.btnSelect.isSelected = !cell.btnSelect.isSelected
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - LazyLoad
    lazy var bottomView: SLChoseFileBottomView = {
        let view = SLChoseFileBottomView()
        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3")
        return view
    }()
}

class SLChoseFileBottomView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(lbSize)
        self.addSubview(btnDone)
        
        lbSize.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(15)
        })
        
        btnDone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-10)
            make.width.equalTo(214)
            make.height.equalTo(40)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var lbSize: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "已选择：110KB"
        lb.textColor = k222222Color
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("确定(2)", for: .normal)
        btn.setTitleColor(kNightFFFFFF, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 214, height: 40), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 20)
        btn.clipsToBounds = false
        return btn
    }()
}
