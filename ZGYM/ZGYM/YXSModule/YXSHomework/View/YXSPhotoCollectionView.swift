//
//  YXSPhotoCollectionView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/11.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import Photos

enum RecordingStyle: Int {
    case readyRecord
    case Recording
    case RecordingFinish
}



let kYXSPhotoCollectionViewDimiss = "YXSPhotoCollectionViewDimiss"
let kYXSPhotoCollectionViewFinish = "YXSPhotoCollectionViewFinish"
let kYXSPhotoCollectionViewChoseLocal = "YXSPhotoCollectionViewChoseLocal"

class YXSPhotoCollectionView: UIView {
    //  最常视频录制时间，单位 秒
    fileprivate let MaxVideoRecordTime = 300
    fileprivate var captureSession: AVCaptureSession! //负责输入和输出设备之间的连接会话
    fileprivate var captureDeviceInput: AVCaptureDeviceInput! // 输入源
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer! //捕获到的视频呈现的layer
    fileprivate var audioMicInput: AVCaptureDeviceInput! //麦克风输入
    fileprivate var videoConnection: AVCaptureConnection! //视频录制连接
    fileprivate var captureMovieFileOutput: AVCaptureMovieFileOutput! //视频输出流
    fileprivate var mode: AVCaptureDevice.FlashMode! //设置聚焦曝光
    fileprivate var captureDevice: AVCaptureDevice! // 输入设备
    fileprivate var position: AVCaptureDevice.Position!
    
    //  表示当时是否在录像中
    fileprivate let timerTool = YXSCountDownTool()
    
    fileprivate var recordingStyle = RecordingStyle.readyRecord
    
    fileprivate var vedioUrl: URL!
    
    ///当前正在导出视频
    fileprivate var isVedioExport: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCapture()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initCapture(){
        //初始化会话对象
        captureSession = AVCaptureSession()
        //        if captureSession.canSetSessionPreset(.hd1920x1080){
        //            captureSession.sessionPreset = .hd1920x1080
        //        }
        //获取视频输入对象
        captureDevice = cameraDevice(with: .back)
        if captureDevice == nil{
            SLLog("取得后置摄像头时出现问题")
            return
        }
        
        captureDeviceInput = try? AVCaptureDeviceInput.init(device: captureDevice)
        if captureDeviceInput == nil{
            SLLog("取得视频设备输入对象时出错")
            return
        }
        //获取音频输入对象
        let audioCatureDevice = AVCaptureDevice.devices(for: AVMediaType.audio).first
        if let audioDevice = audioCatureDevice{
            audioMicInput = try? AVCaptureDeviceInput.init(device: audioDevice)
        }
        if audioMicInput == nil{
            SLLog("取得音频设备输入对象时出错")
            return
        }
        //初始化设备输出对象
        captureMovieFileOutput = AVCaptureMovieFileOutput()
        
        //将设备输入添加到会话中
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
        }
        if captureSession.canAddInput(audioMicInput) {
            captureSession.addInput(audioMicInput)
        }
        
        //防抖功能
        let captureConnection = captureMovieFileOutput.connection(with: AVMediaType.audio)
        if captureConnection?.isVideoStabilizationSupported ?? false {
            captureConnection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto;
        }
        
        //将设备输出添加到会话中
        if captureSession.canAddOutput(captureMovieFileOutput) {
            captureSession.addOutput(captureMovieFileOutput)
        }
        
        //创建视频预览图层
        previewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        self.layer.masksToBounds = true
        previewLayer.frame = self.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.layer.addSublayer(previewLayer)
//        self.layer.insertSublayer(previewLayer, below: <#T##CALayer?#>)
        
        
        //添加自定义控件
        initUI()
        
        //添加点按聚焦手势
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapScreen))
//        self.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func initUI(){
        self.addSubview(captureButton)
        self.addSubview(resetButton)
        self.addSubview(choseButton)
        self.addSubview(selectFileButton)
//        self.addSubview(cameraSideButton)
        self.addSubview(cancleButton)
        captureButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 74, height: 74))
            make.bottom.equalTo(-kSafeBottomHeight - 20.5)
        }

        resetButton.snp.makeConstraints { (make) in
            make.left.equalTo(26)
            make.size.equalTo(CGSize.init(width: 58, height: 58))
            make.bottom.equalTo(-kSafeBottomHeight - 30)
        }
        

        choseButton.snp.makeConstraints { (make) in
            make.right.equalTo(-26)
            make.size.equalTo(CGSize.init(width: 58, height: 58))
            make.bottom.equalTo(-kSafeBottomHeight - 30)
        }

        selectFileButton.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
            make.centerY.equalTo(cancleButton)
        }
        

//        cameraSideButton.snp.makeConstraints { (make) in
//            make.right.equalTo(-25)
//            make.size.equalTo(CGSize.init(width: 60, height: 60))
//            make.top.equalTo(25 + kSafeTopHeight)
//        }
        
        
        cancleButton.snp.makeConstraints { (make) in
            make.left.equalTo(53.5)
            make.size.equalTo(CGSize.init(width: 42, height: 25))
            make.bottom.equalTo(-kSafeBottomHeight - 45.5)
        }
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 64, height: 26))
            make.bottom.equalTo(captureButton.snp.top).offset(-30.5)
        }
//        self.addSubview(progressView)
//        progressView.snp.makeConstraints { (make) in
//            make.bottom.left.right.equalTo(0)
//            make.height.equalTo(8)
//        }
        
//        self.addSubview(focusCursor)
        //        focusCursor.snp.makeConstraints { (make) in
        //            make.size.equalTo(CGSize.init(width: 40, height: 40))
        //            make.center.equalTo(self)
        //        }
        changeUI()
    }
    
    // MARK: -public
    public func stopRunning(){
        self.captureSession?.stopRunning()
    }
    
    public func startRunning(){
        self.captureSession?.startRunning()
    }
    public func getVedioUrl() -> URL{
        return vedioUrl
    }
    // MARK: -action
    
    @objc fileprivate func cancelClick(){
        self.next?.yxs_routerEventWithName(eventName: kYXSPhotoCollectionViewDimiss)
    }
    
    @objc fileprivate func restart(){
        //        timerTool
        timerTool.yxs_cancelTimer()
        recordingStyle = .readyRecord
        changeUI()
    }
    
    @objc fileprivate func choseFile(){
        self.next?.yxs_routerEventWithName(eventName: kYXSPhotoCollectionViewChoseLocal)
    }
    
    @objc fileprivate func choseClick(){
        if isVedioExport{
            return
        }
        if let fileUrl = vedioUrl{
            //保存至相册
            var localIdentifier:String!
            isVedioExport = true
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)
                localIdentifier = request?.placeholderForCreatedAsset?.localIdentifier
                request?.creationDate = Date()
            }, completionHandler: { success, error in
                DispatchQueue.main.async(execute: {
                    self.isVedioExport = false
                    if success {
                        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).firstObject
                        if let asset = asset{
                            DispatchQueue.main.async {
                                self.next?.yxs_routerEventWithName(eventName: kYXSPhotoCollectionViewFinish, info: [kEventKey: asset])
                            }
                        } else {
                            print("视频出错")
                            
                        }
                        
                    } else if error != nil {
                        print("保存视频出错:\(error?.localizedDescription ?? "")")
                        
                    }
                })
            })
        }
        
    }
    
    
    @objc fileprivate func captureChangeStates(){
        captureButton.isSelected = !captureButton.isSelected
        if captureButton.isSelected{
            startCapture()
        }else{
            timerTool.yxs_cancelTimer()
            stopCapture()
        }
    }
    
    //  调整摄像头
    @objc fileprivate func changeCamera() {
        cameraSideButton.isSelected = !cameraSideButton.isSelected
        captureSession.stopRunning()
        //  首先移除所有的 input
        if let  allInputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in allInputs {
                captureSession.removeInput(input)
                
            }
        }
        
        changeCameraAnimate()
        
        //  添加音频输出
        let audioCatureDevice = AVCaptureDevice.devices(for: AVMediaType.audio).first
        if let audioDevice = audioCatureDevice{
            audioMicInput = try? AVCaptureDeviceInput.init(device: audioDevice)
        }
        
        if cameraSideButton.isSelected {
            captureDevice = cameraDevice(with: .front)
            if let input = try? AVCaptureDeviceInput(device: captureDevice) {
                captureSession.addInput(input)
            }
        } else {
            captureDevice = cameraDevice(with: .back)
            if let input = try? AVCaptureDeviceInput(device: captureDevice) {
                captureSession.addInput(input)
            }
        }
    }
    
    @objc fileprivate func tapScreen(tap: UITapGestureRecognizer){
        let point = tap.location(in: self)
        
        //将界面point对应到摄像头point
        let cameraPoint = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
        
        //设置聚光动画
        focusCursor.center = point
        focusCursor.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        focusCursor.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: {
            self.focusCursor.transform = CGAffineTransform.identity
        }) { finished in
            self.focusCursor.alpha = 0.0
            
        }
        
        //设置聚光点坐标
        self.focus(with: AVCaptureDevice.FocusMode.autoFocus, exposureMode: AVCaptureDevice.ExposureMode.autoExpose, at: cameraPoint)
        
    }
    
    
    
    // MARK: -privte
    func focus(with focusMode: AVCaptureDevice.FocusMode, exposureMode: AVCaptureDevice.ExposureMode, at point: CGPoint) {
        
        let captureDevice = captureDeviceInput.device
        //设置设备属性必须先解锁 然后加锁
        do {
            try captureDevice.lockForConfiguration()
            if captureDevice.isFocusModeSupported(focusMode) {
                captureDevice.focusMode = focusMode
            }
            if captureDevice.isFocusPointOfInterestSupported{
                captureDevice.focusPointOfInterest = point
            }
            
            //加锁
            captureDevice.unlockForConfiguration()
        } catch {
            
        }
    }
    
    fileprivate func  changeUI(){
        switch recordingStyle {
        case .readyRecord:
            cameraSideButton.isHidden = false
            captureButton.isHidden = false
            cancleButton.isHidden = false
            selectFileButton.isHidden = false
            timeLabel.isHidden = true
            
            choseButton.isHidden = true
            resetButton.isHidden = true
            progressView.isHidden = true
            
        case .Recording:
            
            progressView.isHidden = false
            captureButton.isHidden = false
            timeLabel.isHidden = false
            
            choseButton.isHidden = true
            resetButton.isHidden = true
            cameraSideButton.isHidden = true
            cancleButton.isHidden = true
            selectFileButton.isHidden = true
            
        case .RecordingFinish:
            resetButton.isHidden = false
            choseButton.isHidden = false
            
            progressView.isHidden = true
            captureButton.isHidden = true
            progressView.isHidden = true
            cameraSideButton.isHidden = true
            cancleButton.isHidden = true
            selectFileButton.isHidden = true
            timeLabel.isHidden = true
        }
        
    }
    
    fileprivate func startCapture(){
        let captureConnection = captureMovieFileOutput.connection(with: .video)
        captureConnection?.videoOrientation = previewLayer.connection?.videoOrientation ?? AVCaptureVideoOrientation.portrait
        // MARK: -视频存储地址
        
        let filePath: String = NSUtil.yxs_cachePath(file: "\(Date()).mp4", directory: kMediaDirectory)
        SLLog(filePath)
        captureMovieFileOutput.startRecording(to: URL(fileURLWithPath: filePath), recordingDelegate: self)
        recordingStyle = .Recording
        changeUI()
        
        YXSPlayerMediaSingleControlTool.share.pauseCompetitionPlayer()
    }
    
    fileprivate func stopCapture(){
        if captureMovieFileOutput.isRecording {
            captureMovieFileOutput.stopRecording()
        }
        recordingStyle = .RecordingFinish
        timerTool.yxs_cancelTimer()
        changeUI()
    
        YXSPlayerMediaSingleControlTool.share.resumeCompetitionPlayer()
    }
    
    //  切换动画
    fileprivate func changeCameraAnimate() {
        let changeAnimate = CATransition()
        changeAnimate.delegate = self
        changeAnimate.duration = 0.4
        changeAnimate.type = CATransitionType(rawValue: "oglFlip")
        changeAnimate.subtype = CATransitionSubtype.fromRight
        previewLayer.add(changeAnimate, forKey: "changeAnimate")
    }
    
    
    fileprivate func cameraDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let cameras = AVCaptureDevice.devices(for: .video)
        for camera in cameras {
            if camera.position == position {
                return camera
            }
        }
        return nil
    }
    
    // MARK: - getter&setter
    lazy var captureButton: CaptureControl = {
        let button = CaptureControl()
        button.addTarget(self, action: #selector(captureChangeStates), for: .touchUpInside)
        return button
    }()
    
    lazy var resetButton: YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("重录", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setBackgroundImage(UIImage.yxs_image(with:  UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)), for: .normal)
        button.cornerRadius = 29
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(restart), for: .touchUpInside)
        return button
    }()
    
    lazy var choseButton: YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = kBlueColor
        button.cornerRadius = 29
        button.addTarget(self, action: #selector(choseClick), for: .touchUpInside)
        return button
    }()
    
    lazy var cancleButton: YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return button
    }()
    
    lazy var selectFileButton: YXSCustomImageControl = {
        let selectFileButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 21, height: 21), position: .top, padding: 9.5)
        selectFileButton.font = UIFont.boldSystemFont(ofSize: 15)
        selectFileButton.textColor = UIColor.white
        selectFileButton.title = "选择视频"
        selectFileButton.locailImage = "yxs_publish_select_vedio"
        selectFileButton.addTarget(self, action: #selector(choseFile), for: .touchUpInside)
        return selectFileButton
    }()
    
    lazy var cameraSideButton: YXSButton = {
        let cameraSideButton = YXSButton()
        cameraSideButton.setBackgroundImage(UIImage(named: "iw_cameraSide"), for: .normal)
        cameraSideButton.addTarget(self, action: #selector(changeCamera), for: .touchUpInside)
        return cameraSideButton
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = UIColor.red
        progressView.trackTintColor = kBackgroundColor
        return progressView
    }()
    
    lazy var timeLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#222222", alpha: 0.6)
        label.text = "00:\(kVedioLength)"
        label.cornerRadius = 5
        label.textAlignment = .center
        return label
    }()
    
    lazy var focusCursor: UIView = {
        let focusCursor = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        focusCursor.backgroundColor = UIColor.clear
        focusCursor.layer.borderWidth = 1
        focusCursor.alpha = 0
        focusCursor.layer.borderColor = UIColor.yellow.cgColor
        return focusCursor
    }()
}

extension YXSPhotoCollectionView: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        SLLog("开始录制")
        timerTool.yxs_startKeepTime {[weak self] (time) in
            guard let strongSelf = self else { return }
            let secend = Int(time) % 60
            DispatchQueue.main.async {
                strongSelf.timeLabel.text = "00:\(String.init(format: "%02d", kVedioLength - secend))"
//                self.progressView.progress = Float(time)/Float(self.MaxVideoRecordTime)
                if time >= kVedioLength{
                    strongSelf.stopCapture()
                    strongSelf.makeToast("视频不能超过\(kVedioLength)秒钟")
                }
            }
        }
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil{
            vedioUrl = outputFileURL
        }
    }
}

// MARK: - CAAnimationDelegate
extension YXSPhotoCollectionView: CAAnimationDelegate {
    /// 动画开始
    func animationDidStart(_ anim : CAAnimation) {
        captureSession.startRunning()
    }
    
    /// 动画结束
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
}


class CaptureControl: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(midView)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool{
        didSet{
            setNeedsLayout()
        }
    }
    
    lazy var midView: UIView = {
        let midView = UIView()
        midView.backgroundColor = kBlueColor
        midView.isUserInteractionEnabled = false
        return midView
    }()
    
    lazy var aniLayer: CALayer = {
        let aniLayer = CAShapeLayer()
        aniLayer.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#A8C0FE").cgColor
        aniLayer.position = CGPoint(x: 37, y: 1.5)
        aniLayer.bounds = CGRect(x: 0, y: 0, width: 14, height: 3)
        aniLayer.cornerRadius = 2
        self.layer.addSublayer(aniLayer)
        return aniLayer
    } ()
    
    override func draw(_ rect: CGRect) {
        
        
        aniLayer.isHidden = true
        aniLayer.removeAllAnimations()
        
        let size = rect.size
        let arcCenter = CGPoint(x: size.width*0.5, y: size.height*0.5)
        let radius = min(size.width, size.height)*0.5 - 1.5
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2 , clockwise: false)
        path.lineWidth = 3//设置线宽
        path.lineCapStyle = CGLineCap.round//设置线样式
        UIColor.white.set()
        path.stroke()
        
        if isSelected{
            aniLayer.isHidden = false
            aniLayer.yxs_circleCircleAnimal(size: rect.size)
            midView.size = CGSize.init(width: 26, height: 26)
            midView.cornerRadius = 2.5
        }else{
            midView.size = CGSize.init(width: 55, height: 55)
            midView.cornerRadius = 27.5
            midView.center = self.center
        }
        midView.yxs_left = (rect.size.width - midView.size.width)/2
        midView.yxs_top = (rect.size.height - midView.size.height)/2
        
    }
}
