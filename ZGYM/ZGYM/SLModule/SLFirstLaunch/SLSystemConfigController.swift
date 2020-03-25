//
//  SLSystemConfigController.swift
//  ZGYM
//
//  Created by hnsl_mac on 2020/2/4.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import UIKit

class SLSystemConfigController: SLBaseViewController {
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        if SLPersonDataModel.sharePerson.isNetWorkingConnect{
            //请求版本信息
            SLVersionUpdateManager.sharedInstance.versionRequest { [weak self](model) in
                guard let weakSelf = self else {return}
                weakSelf.sl_showTabRoot()
            }
        }else{
            sl_showTabRoot()
        }
    }
    
    // MARK: -UI
    
    // MARK: -loadData
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_launchImage_1"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
}

