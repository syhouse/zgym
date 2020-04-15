//
//  SLClassFileViewController.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/4/1.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight
import ObjectMapper
import Photos
import YBImageBrowser

/// 班级文件
class SLClassFileViewController: YXSBaseTableViewController, YXSSelectMediaHelperDelegate {

    /// 页面是否在编辑状态
    var isTbViewEditing: Bool = false
    var parentFolderId: Int = -1
    /// 文件夹列表
    var folderList: [SLFolderModel] = [SLFolderModel]()
    /// 文件列表
    var fileList: [SLFileModel] = [SLFileModel]()
    
    var currentImg: UIImage?
    var currentVideoUrl: URL?
    
    private var navRightBtn: YXSButton = YXSButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "移动文件"
        
        view.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightBackgroundColor)
        tableView.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNightBackgroundColor)
        
        tableView.register(SLFileGroupCell.classForCoder(), forCellReuseIdentifier: "SLFileGroupCell")
        tableView.register(SLFileCell.classForCoder(), forCellReuseIdentifier: "SLFileCell")
        
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            setupRightBarButtonItem()
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(tableViewLongPress(gestureRecognizer:)))
        tableView.addGestureRecognizer(longPress)
        
        view.insertSubview(bottomView, aboveSubview: tableView)
        bottomView.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(60)
            make.height.equalTo(60)
        })
    }
    
    func setupRightBarButtonItem() {
        let btnAdd = YXSButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        btnAdd.setTitle("添加", for: .normal)
        btnAdd.setTitle("取消", for: .selected)
        btnAdd.setTitleColor(k575A60Color, for: .normal)
        btnAdd.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btnAdd.addTarget(self, action: #selector(addFileClick), for: .touchUpInside)
        navRightBtn = btnAdd
        
        let navShareItem = UIBarButtonItem(customView: navRightBtn)
        self.navigationItem.rightBarButtonItems = [navShareItem]
    }
    
    override func yxs_refreshData() {
        yxs_endingRefresh()
    }
    
    // MARK: - Request
    @objc func loadData() {

    }
    
    // MARK: - Action
    @objc func addFileClick() {
        if isTbViewEditing {
            endEditing()
            
        } else {
            let lists = [YXSCommonBottomParams.init(title: "从相册选择", event: "album"),YXSCommonBottomParams.init(title: "从书包选择", event: "bag"),YXSCommonBottomParams.init(title: "新建文件夹", event: "createFolder")]
            
            YXSCommonBottomAlerView.showIn(buttons: lists) { [weak self](model) in
                guard let strongSelf = self else { return }
                switch model.event {
                case "album":
                    strongSelf.selectedFromAlbumClick()
                case "bag":
                    strongSelf.selectedFromBagClick()
                case "createFolder":
                    strongSelf.createFolderClick()
                default:
                    break
                }
            }
        }
    }
    
    @objc func selectedFromAlbumClick() {
        YXSSelectMediaHelper.shareHelper.pushImagePickerController(mediaStyle: SLSelectMediaStyle.bothImageVideoGif, showTakePhoto: false, maxCount: 30)
        YXSSelectMediaHelper.shareHelper.delegate = self
    }
    
    @objc func selectedFromBagClick() {
//        let vc = SLFileBagViewController()
        let vc = SLChoseFileViewController()
        navigationController?.pushViewController(vc)
    }
    
    @objc func createFolderClick() {
        let view = YXSInputAlertView2.showIn(target: self.view) { (result, btn) in
            
        }
        view.lbTitle.text = "创建文件夹"
        view.tfInput.placeholder = "请输入文件夹名称"
        view.btnDone.setTitle("创建", for: .normal)
        view.btnCancel.setTitle("取消", for: .normal)
    }
    
    @objc func tableViewLongPress(gestureRecognizer:UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizer.State.began) {
            
            if(isTbViewEditing == false) {
                beginEditing()
                
            } else {
                endEditing()
            }
        }
    }
    
    // MARK: -重命名、移动、删除
    @objc func renameBtnClick(sender: YXSButton) {

    }
    
    @objc func moveBtnClick(sender: YXSButton) {
        
    }
    
    @objc func deleteBtnClick(sender: YXSButton) {
        
    }
    
    // MARK: - 图片选择代理
    /// 拍照完成/选中视频
    func didSelectMedia(asset: YXSMediaModel) {
        didSelectSourceAssets(assets: [asset])
    }
    
    /// 选中图片资源
    func didSelectSourceAssets(assets: [YXSMediaModel]) {
        for sub in assets {
            if sub.type == .image {
                
                let imgName = "\(sub.fileName).\(sub.fileType)"
                UIUtil.PHAssetToImage(sub.asset) { (result) in
                    if sub.fileType == "JPG" {
                        
                        let data = result.sd_imageData(as: .JPEG)
                        let fullPath = SLFileManagerHelper.sharedInstance.getDocumentFullPathURL(lastPathComponent: imgName)
                        try! data?.write(to: fullPath)
                     
                        DispatchQueue.main.async {
                            self.currentImg = UIImage(contentsOfFile: fullPath.path)
                            self.tableView.reloadData()
                        }

                    }
                }
                
            } else if sub.type == .video {
                
                let videoName = "\(sub.fileName).\(sub.fileType)"
                PHCachingImageManager().requestAVAsset(forVideo: sub.asset, options:nil, resultHandler: { (asset, audioMix, info)in
                    if let avAsset = asset as? AVURLAsset {
                        let session = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetHighestQuality)
                        let fullPath = SLFileManagerHelper.sharedInstance.getDocumentFullPathURL(lastPathComponent: videoName)
                        session?.outputURL = fullPath
                        session?.outputFileType = .mp4
                        session?.exportAsynchronously {
                            SLLog("转存视频成功:\(fullPath)")
                            self.currentVideoUrl = fullPath
                        }
                        
                    }
//                    self.videoUrl = avAsset?.url
//                    self.showImg = UIImage.yxs_getScreenShotImage(fromVideoUrl: avAsset?.url)
                })
            }
        }
    }
    
    // MARK: - Other
    @objc func saveImageFileToDocument(image: UIImage) {

    }
    
    /// 检测重命名按钮可否点击
    @objc func verifyBottomViewBtnEnable() {
        var selectedCount = 0
        for sub in folderList {
            if sub.isSelected == true {
                selectedCount += 1
            }
        }
        
        for sub in fileList {
            if sub.isSelected == true {
                selectedCount += 1
            }
        }
        
        bottomView.btnFirst.isEnabled = selectedCount == 1 ? true : false
        bottomView.btnSecond.isEnabled = selectedCount < 1 ? false : true
        bottomView.btnThird.isEnabled = selectedCount < 1 ? false : true
    }
    
    /// 进入编辑状态
    @objc func beginEditing() {
        isTbViewEditing = true
        
        navRightBtn.isSelected = true
        
        for sub in folderList {
            sub.isEditing = true
        }
        
        for sub in fileList {
            sub.isEditing = true
        }
        
        bottomView.isHidden = false
        verifyBottomViewBtnEnable()
        UIView.animate(withDuration: 0.3) {
            self.bottomView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(0)
            })
            self.view.layoutIfNeeded()
        }
        tableView.reloadData()
    }
    
    /// 退出编辑状态
    @objc func endEditing() {
        isTbViewEditing = false
        
        navRightBtn.isSelected = false

        for sub in folderList {
             sub.isEditing = false
        }
        
        for sub in fileList {
             sub.isEditing = false
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.snp.updateConstraints({ (make) in
                 make.bottom.equalTo(60)
            })
            self.view.layoutIfNeeded()
            
        }) { (result) in
             self.bottomView.isHidden = true
        }
        tableView.reloadData()
    }
    
    // MARK: -Tool
    @objc func getSelectedFolerList() -> [SLFolderModel] {
        var tmpArr = [SLFolderModel]()
        for sub in folderList {
            if sub.isSelected ?? false {
                tmpArr.append(sub)
            }
        }
        return tmpArr
    }
    
    @objc func getSelectedFileList() -> [SLFileModel] {
        var tmpArr = [SLFileModel]()
        for sub in fileList {
            if sub.isSelected ?? false {
                tmpArr.append(sub)
            }
        }
        return tmpArr
    }
    
    
    
    @objc func getUnselectedFolerList() -> [SLFolderModel] {
        var tmpArr = [SLFolderModel]()
        for sub in folderList {
            if !(sub.isSelected ?? false) {
                tmpArr.append(sub)
            }
        }
        return tmpArr
    }
    
    @objc func getUnselectedFileList() -> [SLFileModel] {
        var tmpArr = [SLFileModel]()
        for sub in fileList {
            if !(sub.isSelected ?? false) {
                tmpArr.append(sub)
            }
        }
        return tmpArr
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
            let cell: SLFileGroupCell = tableView.dequeueReusableCell(withIdentifier: "SLFileGroupCell") as! SLFileGroupCell
            cell.lbTitle.text = "作业"
            return cell
            
        } else {
            let cell: SLFileCell = tableView.dequeueReusableCell(withIdentifier: "SLFileCell") as! SLFileCell
            cell.lbTitle.text = "十万个为什么.pdf"
            cell.lbSubTitle.text = "老师名 | 2020-8-16"
            switch indexPath.row {
                case 0:
                    cell.imgIcon.image = currentImg != nil ? currentImg : UIImage(named: "yxs_file_excel")
                case 1:
                    cell.imgIcon.image = currentImg != nil ? currentImg : UIImage(named: "yxs_file_pdf")
                case 2:
                    cell.imgIcon.image = currentImg != nil ? currentImg : UIImage(named: "yxs_file_ppt")
                default:
                    cell.imgIcon.image = currentImg != nil ? currentImg : UIImage(named: "yxs_file_word")
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
            navigationController?.pushViewController(SLClassFileViewController())
            
        } else {
            // 视频
            let browser = YBImageBrowser()
            let videoData = YBIBVideoData()
//            vedioData.videoPHAsset = PHAsset()//item.model?.asset
            videoData.videoURL = currentVideoUrl
            videoData.autoPlayCount = 1
            browser.dataSourceArray.append(videoData)
            browser.show()
        }
    }

    // MARK: 可编辑Cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER {
            return true
        } else {
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCell.EditingStyle.delete {
//            self.diagnoseArr.removeObject(at: indexPath.row-1)
            //刷新tableview
//            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // MARK: - LazyLoad
    lazy var bottomView: SLClassFileBottomView = {
        let view = SLClassFileBottomView()
//        view.backgroundColor = UIColor.red
        view.isHidden = true
        view.btnFirst.addTarget(self, action: #selector(renameBtnClick(sender:)), for: .touchUpInside)
        view.btnSecond.addTarget(self, action: #selector(moveBtnClick(sender:)), for: .touchUpInside)
        view.btnThird.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)
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


class SLClassFileBottomView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        addSubview(btnFirst)
        addSubview(btnSecond)
        addSubview(btnThird)
        
        btnFirst.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(btnSecond.snp_width)
        })
        
        btnSecond.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(btnFirst.snp_right)
            make.bottom.equalTo(0)
            make.width.equalTo(btnThird.snp_width)
        })
        
        btnThird.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(btnSecond.snp_right)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(btnFirst.snp_width)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var btnFirst: YXSButton = {
        let btn = YXSButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/3.0, height: 60.0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("重命名", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: k575A60Color), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1"), night: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1")), forState: .disabled)
        btn.setMixedImage(MixedImage(normal: "yxs_file_edit_1", night: "yxs_file_edit_1"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_file_edit_2", night: "yxs_file_edit_2"), forState: .disabled)
        btn.yxs_setIconInTopWithSpacing(4)
        return btn
    }()
    
    lazy var btnSecond: YXSButton = {
        let btn = YXSButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/3.0, height: 60.0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("移动", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: k575A60Color), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1"), night: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1")), forState: .disabled)
        btn.setMixedImage(MixedImage(normal: "yxs_file_move", night: "yxs_file_move"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_file_move_2", night: "yxs_file_move_2"), forState: .disabled)
        btn.yxs_setIconInTopWithSpacing(4)
        return btn
    }()
    
    lazy var btnThird: YXSButton = {
        let btn = YXSButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/3.0, height: 60.0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("删除", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: k575A60Color), forState: .normal)
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1"), night: UIColor.yxs_hexToAdecimalColor(hex: "#AEAFC1")), forState: .disabled)
        btn.setMixedImage(MixedImage(normal: "yxs_file_delete", night: "yxs_file_delete"), forState: .normal)
        btn.setMixedImage(MixedImage(normal: "yxs_file_delete_2", night: "yxs_file_delete_2"), forState: .disabled)
        btn.yxs_setIconInTopWithSpacing(4)
        return btn
    }()
    

//    lazy var btnFirst: YXSCustomImageControl = {
//        let btn = YXSCustomImageControl(imageSize: CGSize(width: 22, height: 22), position: YXSImagePositionType.top, padding: 4, insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
////        btn.backgroundColor = UIColor.yellow
//        btn.font = UIFont.systemFont(ofSize: 12)
//        btn.mixedTextColor = MixedColor(normal: k575A60Color, night: k575A60Color)
//        btn.setTitle("重命名", for: .normal)
//        btn.setImage(UIImage(named: "yxs_file_edit_1"), for: .normal)
//        btn.setImage(UIImage(named: "yxs_file_edit_2"), for: .selected)
//        btn.isSelected = false
//        return btn
//    }()
//
//    lazy var btnSecond: YXSCustomImageControl = {
//        let btn = YXSCustomImageControl(imageSize: CGSize(width: 22, height: 22), position: YXSImagePositionType.top, padding: 7, insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
////        btn.backgroundColor = UIColor.green
//        btn.font = UIFont.systemFont(ofSize: 12)
//        btn.mixedTextColor = MixedColor(normal: k575A60Color, night: k575A60Color)
//        btn.setTitle("移动", for: .normal)
//        btn.setImage(UIImage(named: "yxs_file_move"), for: .normal)
//        btn.setImage(UIImage(named: "yxs_file_move"), for: .selected)
//        btn.isSelected = false
//        return btn
//    }()
//
//    lazy var btnThird: YXSCustomImageControl = {
//        let btn = YXSCustomImageControl(imageSize: CGSize(width: 22, height: 22), position: YXSImagePositionType.top, padding: 7, insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
////        btn.backgroundColor = UIColor.gray
//        btn.font = UIFont.systemFont(ofSize: 12)
//        btn.mixedTextColor = MixedColor(normal: k575A60Color, night: k575A60Color)
//        btn.setTitle("删除", for: .normal)
//        btn.setImage(UIImage(named: "yxs_file_delete"), for: .normal)
//        btn.setImage(UIImage(named: "yxs_file_delete"), for: .selected)
//        btn.isSelected = false
//        return btn
//    }()
}
