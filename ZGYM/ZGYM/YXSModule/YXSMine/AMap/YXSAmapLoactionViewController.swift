//
//  YXSAmapLoactionViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class YXSAmapLoactionViewController: YXSBaseTableViewController, MAMapViewDelegate {
    
    var completionHandler:((_ coordinate: CLLocationCoordinate2D, _ name:String)->())?
    var currentCoordinate: CLLocationCoordinate2D?
    var pois: [AMapPOI]?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        hasRefreshHeader = false
        showBegainRefresh = false
        self.fd_interactivePopDisabled = true
        super.viewDidLoad()
    
        self.title = "所在学校"
        
        // Do any additional setup after loading the view.
        self.view.addSubview(mapView)
        self.view.addSubview(btnCoordinateMine)
        
        mapView.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(SCREEN_SCALE*253.0)
        })
        
        btnCoordinateMine.snp.makeConstraints({ (make) in
            make.bottom.equalTo(mapView.snp_bottom).offset(-5)
            make.right.equalTo(mapView.snp_right).offset(-5)
            make.width.height.equalTo(44)
        })
        
        tableView.snp.remakeConstraints({ (make) in
            make.top.equalTo(mapView.snp_bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(0)
            }
        })

        tableView.register(YXSPOITableViewCell.classForCoder(), forCellReuseIdentifier: "YXSPOITableViewCell")
//        tableView.register(ZLPOITableViewCell.classForCoder(), forCellReuseIdentifier: "ZLPOITableViewCell")

        coordinateMineClick(sender: nil)
        createNavRightBtnItems()
    }
    
    @objc func createNavRightBtnItems() {
        let itemWidth: CGFloat = 33
        let btnService = YXSButton(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth))
        btnService.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnService.setTitle("手动输入", for: .normal)
        btnService.addTarget(self, action: #selector(commitClick(sender:)), for: .touchUpInside)
        let barBtnNavRight = UIBarButtonItem(customView: btnService)
        self.navigationItem.rightBarButtonItems = [barBtnNavRight]
    }
    
    // MARK: - Action
    @objc func coordinateMineClick(sender: YXSButton?) {
        self.mapView.shouldUpdatePOI = sender != nil ? true : false
        
        YXSAMapManager.share().searchPOIKeyword("学校") { [weak self](response, coordinate, err) in
            guard let weakSelf = self else {return}
                weakSelf.currentCoordinate = coordinate;
                
//                if sender != nil {
                weakSelf.moveToPoisition(position: coordinate)
                weakSelf.mapView.removeAnnotation(weakSelf.pointAnnotation)
                weakSelf.mapView.addAnnotation(weakSelf.pointAnnotation)
//                }
                
            if let pois = response.pois,pois.count == 0 {
                return
            }else{
                weakSelf.selectedIndex = nil
                weakSelf.pois = response.pois
                weakSelf.tableView.reloadData()
            }
        }
    }

    @objc func moveToPoisition(position: CLLocationCoordinate2D) {
        self.mapView.setCenter(position, animated: true)
    }
    
    // MARK: -手动输入
    @objc func commitClick(sender: YXSButton) {
        let vc = YXSInputViewController(maxLength: 10) { [weak self](text,vc) in
            guard let weakSelf = self else {return}
            weakSelf.completionHandler?(CLLocationCoordinate2D(latitude: 0, longitude: 0), text)
            weakSelf.navigationController?.popViewController(animated: true)
//            if text.count > 0 {
//                MBProgressHUD.yxs_showLoading(inView: vc.view)
//                YXSAMapManager.share().searchPOIKeyword(text) {(response, coordinate, err) in
//                    MBProgressHUD.yxs_hideHUDInView(view: vc.view)
//                    if err == nil {
//                        weakSelf.currentCoordinate = coordinate
//                        if response.pois.count == 0 {
//                            return
//                        } else {
//                            weakSelf.pois = response.pois
//                            weakSelf.tableView.reloadData()
//                        }
//
//                        weakSelf.mapView.shouldUpdatePOI = false
//                        weakSelf.moveToPoisition(position: weakSelf.currentCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
//                        weakSelf.navigationController?.popViewController()
//
//                    } else {
//                        MBProgressHUD.yxs_showMessage(message: err.localizedDescription, inView: vc.view)
//                    }
//                }
//            }
        }
        vc.title = "手动输入"
        vc.btnDone.setTitle("确认", for: .normal)
        vc.tfText.setPlaceholder(ph: "输入您所在的学校") 
        self.navigationController?.pushViewController(vc)
    }

    
    override func yxs_onBackClick() {
        if self.selectedIndex == nil {
            self.navigationController?.popViewController(animated: true)
            
        } else {
            self.completionHandler?(self.currentCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), pois?[selectedIndex!].name ?? "")
        }
        
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pois?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YXSPOITableViewCell = tableView.dequeueReusableCell(withIdentifier: "YXSPOITableViewCell") as! YXSPOITableViewCell
        cell.model = self.pois?[indexPath.row] ?? AMapPOI()
        if self.selectedIndex != nil && indexPath.row == self.selectedIndex {
            cell.imgMark.isHidden = false
        } else {
            cell.imgMark.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            selectedIndex = nil
        } else {
            self.selectedIndex = indexPath.row
        }
        tableView.reloadData()
        
        let poi: AMapPOI = self.pois?[indexPath.row] ?? AMapPOI()
        let position = CLLocationCoordinate2D(latitude: Double(poi.location?.latitude ?? 0), longitude: Double(poi.location.longitude ?? 0))
        self.mapView.shouldUpdatePOI = false
        self.currentCoordinate = position
        self.moveToPoisition(position: position)
    }

    
    // MARK: - MapViewDelegate
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate: CLLocationCoordinate2D = mapView.region.center
        if self.mapView.shouldUpdatePOI {
            YXSAMapManager.share().searchPOICoordinate(centerCoordinate, keyword: "学校") { [weak self](response, coordinate, err) in
                guard let weakSelf = self else {return}
                weakSelf.currentCoordinate = coordinate
                if response.pois.count == 0 {
                    return
                } else {
                    weakSelf.pois = response.pois
                    weakSelf.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - LazyLoad
    lazy var mapView: YXSMAMapView = {
        let view = YXSMAMapView(frame: CGRect.zero)
        view.delegate = self;
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        view.showsUserLocation = true;
        view.userTrackingMode = MAUserTrackingMode.follow;
        view.setZoomLevel(17.5, animated: true)
        return view;
    }()

    lazy var btnCoordinateMine: YXSButton = {
        let btn = YXSButton()
        btn.setImage(UIImage(named: "yxs_back_mine_point"), for: .normal)
        btn.addTarget(self, action: #selector(coordinateMineClick(sender:)), for: .touchUpInside)
        return btn
    }()

    lazy var pointAnnotation: MAPointAnnotation = {
        let view = MAPointAnnotation()
        view.coordinate = self.mapView.region.center
        view.isLockedToScreen = true
        view.lockedScreenPoint = CGPoint(x: SCREEN_WIDTH/2.0, y: SCREEN_SCALE*253.0/2.0)
        return view
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
