//
//  YXSSystemConfigController.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2020/2/4.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import UIKit

class YXSSystemConfigController: YXSBaseViewController {
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        if YXSPersonDataModel.sharePerson.isNetWorkingConnect{
            //请求版本信息
            YXSVersionUpdateManager.sharedInstance.versionRequest { [weak self](model) in
                guard let weakSelf = self else {return}
                weakSelf.yxs_showTabRoot()
            }
        }else{
            yxs_showTabRoot()
        }
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_launchImage_1"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
}

