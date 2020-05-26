//
//  YXSTemplateListController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

enum YXSTemplateType{
    case notice
    case punchcard
}

class YXSTemplateListController: YXSBaseCollectionViewController{
    
    /// 提交完成后的block
    var didSelectTemplateModel: (() -> ())?
   
    var type: YXSTemplateType = .punchcard
    
    var punchCardTemplates: [YXSTemplateListModel] = [YXSTemplateListModel]()
  
    init(type: YXSTemplateType, punchCardItems: [YXSTemplateListModel]?) {
        if let punchCardItems = punchCardItems{
            self.punchCardTemplates = punchCardItems
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -leftCicle
    
    override func viewDidLoad() {
        
        let layout = UICollectionViewFlowLayout()
        let space:CGFloat = (self.view.frame.size.width - CGFloat(68.0*4.0) - CGFloat(15.0*2.0))/3.0
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = 28
        layout.sectionInset = UIEdgeInsets.init(top: 30, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize.init(width: 68, height: 68)
        layout.scrollDirection = .vertical
        self.layout =  layout
        
        hasRefreshHeader = false
        
        super.viewDidLoad()
        
        collectionView.register(YXSTemplateListCell.self, forCellWithReuseIdentifier: "YXSTemplateListCell")
        
    }
    
    // MARK: - loadData
    func loadData(){

    }
    
    override func yxs_onBackClick() {
        self.navigationController?.popViewController()
    }
    
   
    // MARK: - UICol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .punchcard:
            return punchCardTemplates.count
        default:
            return 0
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSTemplateListCell", for: indexPath) as! YXSTemplateListCell
        return cell
    }
}



class YXSTemplateListCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setModel(_ model: YXSTemplateListModel){
        button.setTitle(model.title, for: .normal)
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.white), for: .selected)
        button.setBackgroundImage(UIImage.yxs_image(with: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")), for: .normal)
        button.setTitleColor(kBlueColor, for: .selected)
        button.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#696C73"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.cornerRadius = 14.5
        button.titleLabel?.textAlignment = .center
        return button
    }()
}
