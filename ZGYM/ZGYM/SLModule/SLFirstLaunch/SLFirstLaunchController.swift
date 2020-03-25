//
//  YMFirstLaunchController.swift
//  YMEducation
//
//  Created by sy_mac on 2019/11/14.
//  Copyright © 2019 sy_mac. All rights reserved.
//

import UIKit
import GBDeviceInfo

let kSLFirstLaunchCellGoInEvent = "SLFirstLaunchCellGoInEvent"

class SLFirstLaunchCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(goInButton)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        goInButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-48.5 - kSafeBottomHeight)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 140, height: 41))
        }
    }
    
    func setCellInfo(_ info:[String: Any]){
        goInButton.isHidden = !(info[kShowButton] as? Bool ?? false)
        imageView.image = UIImage.init(named: info[kImageKey] as? String ?? "")
    }
    
    @objc func goInClick(){
        sl_routerEventWithName(eventName: kSLFirstLaunchCellGoInEvent)
    }
    
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = kTextBlackColor
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    lazy var goInButton: UIButton = {
        let button = UIButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("立即体验", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = kBlueColor
        button.layer.cornerRadius = 20.5
        button.addTarget(self, action: #selector(goInClick), for: .touchUpInside)
        return button
    }()
}

class SLFirstLaunchController: SLBaseViewController {
    fileprivate var dataSource = [[String: Any]]()
    lazy fileprivate var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: setLayout(flow))
        view.backgroundColor = UIColor.clear
        view.register(SLFirstLaunchCell.self, forCellWithReuseIdentifier: "SLFirstLaunchCell")
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        return view
    }()
    
    // MARK: -leftCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        initDataSource()
    }
    
    // MARK: -UI
    func initDataSource(){
        let imagesP = ["launch_class_start","launch_notice", "launch_punch_card", "launch_friend_circle"]
        for index in 0..<4{
            var image = imagesP[index]
            let dv = GBDeviceInfo.deviceInfo()
            if let dv = dv{
                switch dv.displayInfo.display {
                case GBDeviceDisplay.display3p5Inch:
                    image += "_640_960"
                case GBDeviceDisplay.display4Inch:
                    image += "_640_1136"
                case GBDeviceDisplay.display4p7Inch:
                    image += "_750"
                case GBDeviceDisplay.display5p5Inch:
                    image += "_1242_2208"
                case GBDeviceDisplay.display5p8Inch:
                    image += "_1125_2436"
                case GBDeviceDisplay.display6p1Inch:
                    image += "_828_1792"
                case GBDeviceDisplay.display6p5Inch:
                    image += "_1242_2688"
                default:
                    image += "_1242_2688"
                }
            }
            var info:[String: Any] = [kImageKey: image]
//            if index == 3{
//
//            }
            info[kShowButton] = true
            dataSource.append(info)
        }
    }
    
    // MARK: -loadData
    
    // MARK: -action
    
    // MARK: -private
    
    // MARK: -public
    
    
    // MARK: - getter&setter
//    lazy var pageControl: WRPageControl = {
//        let currentPageDotImage = UIImage.ym_image(with: kBlueColor,size: CGSize.init(width: 12.5, height: 8))
//        let defaultPageDotImage = UIImage.ym_image(with: UIColor.ym_hexToAdecimalColor(hex: "#A1C0FF"),size: CGSize.init(width: 8, height: 8))
//        let pageControl = WRPageControl(frame: CGRect.zero, currentImage: currentPageDotImage, defaultImage: defaultPageDotImage)
//        pageControl.hidesForSinglePage = true
//        pageControl.isUserInteractionEnabled = false
//        pageControl.pointSpace = 5
//        pageControl.imgCornerRadius = true
//        return pageControl
//    }()
}

extension SLFirstLaunchController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SLFirstLaunchCell", for: indexPath) as! SLFirstLaunchCell
        
        cell.setCellInfo(self.dataSource[indexPath.row])
        return cell;
    }
    
    func setLayout(_ layout: UICollectionViewFlowLayout) -> UICollectionViewFlowLayout {
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        layout.scrollDirection = .horizontal
        return layout
    }
}

extension SLFirstLaunchController:SLRouterEventProtocol{
    func sl_user_routerEventWithName(eventName: String, info: [String : Any]?) {
        switch eventName {
        case kSLFirstLaunchCellGoInEvent:
            sl_showTabRoot()
        default:
            break
        }
    }
}


