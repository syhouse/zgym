//
//  YXSRecordAudioView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class SLAudioModel: NSObject, NSCoding{
    
    /// 播放路径
    var path:String?
    
    /// 服务器路径
    var servicePath:String?
    
    /// 长度
    var time: Int!
    
    /// 名称
    var fileName: String?
    
    override init() {
        super.init()
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        time = aDecoder.decodeObject(forKey: "time") as? Int
        path = aDecoder.decodeObject(forKey: "path") as? String
        fileName = aDecoder.decodeObject(forKey: "fileName") as? String
        servicePath = aDecoder.decodeObject(forKey: "servicePath") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if time != nil{
            aCoder.encode(time, forKey: "time")
        }
        if let path = path{
            aCoder.encode(path, forKey: "path")
        }
        if let fileName = fileName{
            aCoder.encode(fileName, forKey: "fileName")
        }
        if let servicePath = servicePath{
            aCoder.encode(servicePath, forKey: "servicePath")
        }
        
    }
}

enum RecordStatus{
    ///准备录音
    case redayRecord
    ///录音中
    case Recording
    ///录音结束准备预览当前录音
    case redayShow
    ///正在播放当前录音
    case Showing
}

class YXSRecordAudioView: UIView {
    @discardableResult static func showRecord(audio:SLAudioModel? = nil, complete:((_ model: SLAudioModel) ->())? = nil) -> YXSRecordAudioView{
        let view = YXSRecordAudioView.init(audio: audio)
        view.complete = complete
        view.beginAnimation()
        return view
    }
    
    public var sourceDirectory: YXSCacheDirectory = .HomeWork
    //    public var publishId: String
    
    private var complete:((_ model: SLAudioModel) ->())?
    private var session: AVAudioSession!
    
    private var filePathCaf: String!
    private var filePathMp3: String!
    private var recordFileUrl: URL!
    private var recorder: AVAudioRecorder!
    private var timerTool = YXSCountDownTool()
    private var status:RecordStatus = .redayRecord
    private var audioModel: SLAudioModel!
    
    // MARK: -UI相关
    init(audio:SLAudioModel? = nil) {
        super.init(frame: CGRect.zero)
        addSubview(recordTotalLabel)
        addSubview(recordTipsLabel)
        addSubview(playerControl)
        addSubview(cancelButton)
        addSubview(certainButton)
        addSubview(refreshRecordButton)
        
        
        recordTotalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(27.5)
            make.centerX.equalTo(self)
        }
        playerControl.snp.makeConstraints { (make) in
            make.top.equalTo(70)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        recordTipsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-37 - kSafeBottomHeight)
            make.centerX.equalTo(self)
        }
        refreshRecordButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playerControl)
            make.width.equalTo(35)
            make.left.equalTo(35)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.right.equalTo(-20)
            make.size.equalTo(CGSize.init(width: 39, height: 20))
        }
        certainButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playerControl)
            make.right.equalTo(-26)
            make.size.equalTo(CGSize.init(width: 58, height: 58))
        }
        
        audioModel = audio
        if audioModel != nil {
            status = .redayShow
            setRedayShowUI()
        }else{
            audioModel = SLAudioModel()
            setRedayStartUI()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setRedayStartUI(){
        cancelButton.isHidden = false
        certainButton.isHidden = true
        refreshRecordButton.isHidden = true
        
        recordTotalLabel.isHidden = false
        
        recordTotalLabel.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        recordTotalLabel.text = "建议录音时长不超过5分钟"
        recordTipsLabel.text = "点击开始录音"
        
        playerControl.status = status
    }
    
    private func setRecordingUI(){
        cancelButton.isHidden = true
        certainButton.isHidden = true
        refreshRecordButton.isHidden = true
        
        recordTotalLabel.isHidden = false
        
        recordTotalLabel.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        recordTotalLabel.text = "正在录音 0:00"
        recordTipsLabel.text = "点击完成录音"
        
        playerControl.status = status
    }
    private func setRedayShowUI(){
        cancelButton.isHidden = false
        certainButton.isHidden = false
        refreshRecordButton.isHidden = false
        
        recordTotalLabel.isHidden = true
        recordTipsLabel.text = "点击预览"
        
        playerControl.status = status
    }
    
    private func setShowingUI(){
        cancelButton.isHidden = false
        certainButton.isHidden = false
        refreshRecordButton.isHidden = false
        
        recordTotalLabel.isHidden = true
        recordTipsLabel.text = "点击预览"
        
        playerControl.status = status
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func beginAnimation() {
        UIUtil.RootController().view.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight383E56)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(250.5 + kSafeBottomHeight)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -tool
    private func startRecord(){
        session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try? session.setActive(true)
        }catch{
            SLLog(error)
        }
        
        //1.获取cache文件地址
        filePathCaf = NSUtil.yxs_recordCachePath(.HomeWork, "Record\(1).caf")
        filePathMp3 = NSUtil.yxs_recordCachePath(.HomeWork, "Record\(1).mp3")
        audioModel.fileName = "\(sourceDirectory.rawValue)Record\(Date().toString())"
        
        //2.获取文件路径
        recordFileUrl = URL(fileURLWithPath: filePathCaf)
        
        //设置参数
        let recordSetting = [
            //线性采样位数  8、16、24、32
            AVLinearPCMBitDepthKey: NSNumber(value: 16 as Int32),
            //设置录音格式  AVFormatIDKey == kAudioFormatLinearPCM(Mp3，Wav)
            //设置录音格式  AVFormatIDKey == kAudioFormatMPEG4AAC(AAC)
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM as UInt32),
            //录音通道数  1 或 2
            AVNumberOfChannelsKey: NSNumber(value: 2 as Int32),
            //设置录音采样率(Hz) 如：AVSampleRateKey == 8000/44100/96000（影响音频的质量）
            AVSampleRateKey: NSNumber(value: 8000 as Float),
            //录音质量
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.high.rawValue)
        ]
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord)
        } catch {
            
        }
        try? session.setActive(true)
        
        recorder = try? AVAudioRecorder(url: recordFileUrl, settings: recordSetting)
        if recorder != nil {
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
            recorder.record()
        } else {
            print("音频格式和文件存储格式不匹配,无法初始化Recorder")
        }
        
        timerTool.yxs_startKeepTime { [weak self](time) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let min = time/60
                let sec = time%60
                strongSelf.recordTotalLabel.text = "正在录音 \(min):" + String.init(format: "%02d", sec)
                if time >= 300{
                    MBProgressHUD.yxs_showMessage(message: "录音最大时长为5分钟")
                    strongSelf.stopRecord()
                    strongSelf.playerClick()
                }
                
            }
        }
    }
    
    private func stopRecord(){
        if recorder.isRecording {
            recorder.stop()
        }
        //        YXSConvertAudioFile.sharedInstance()?.conventToMp3(withCafFilePath: filePathCaf, mp3FilePath: filePathMp3, sampleRate: Int32(11025.0)){ (result) in
        //
        //        }
        YXSConvertAudioFile.conventToMp3(withCafFilePath: filePathCaf, mp3FilePath: filePathMp3, sampleRate: Int32(8000)){ (result) in
            if result{
                SLLog("mp3 file compression sucesss")
                self.audioModel.path = self.filePathMp3
                
                //如果当前是服务器的 删掉
                self.audioModel.servicePath = nil
            }
        }
        audioModel.path = filePathCaf
        audioModel.time = timerTool.keepTime
        
        timerTool.yxs_cancelTimer()
    }
    
    @objc private func didEnterBackground(){
        if status == .Recording{
            playerClick()
        }
    }
    
    private func play() {
        //            var path
        var playerUrl: URL
        if let path = audioModel.path{
            playerUrl = URL.init(fileURLWithPath: path)
        }else{
            playerUrl = URL.init(string: audioModel.servicePath ?? "")!
        }
        YXSSSAudioPlayer.sharedInstance.play(url: playerUrl, loop: 1, cacheAudio: true) {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.status = .redayShow
            strongSelf.setRedayShowUI()
        }
        
    }
    
    private func cleanPlayer(){
        YXSSSAudioPlayer.sharedInstance.stopVoice()
        try? AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.none)
    }
    
    // MARK: -event
    @objc private  func refreshRecordClick(){
        cleanPlayer()
        status = .redayRecord
        setRedayStartUI()
    }
    
    @objc private func certainClick(){
        if audioModel.time < 1{
            MBProgressHUD.yxs_showMessage(message: "语音录制过短,请重录")
            return
        }
        complete?(audioModel)
        dismiss()
    }
    
    @objc private  func playerClick(){
        switch status {
        case .redayRecord:
            status = .Recording
            startRecord()
            setRecordingUI()
            YXSXMPlayerGlobalControlTool.share.pauseCompetitionPlayer()
        case .Recording:
            status = .redayShow
            stopRecord()
            setRedayShowUI()
            YXSXMPlayerGlobalControlTool.share.resumeCompetitionPlayer()
        case .redayShow:
            status = .Showing
            play()
            setShowingUI()
        case .Showing:
            status = .redayShow
            YXSSSAudioPlayer.sharedInstance.stopVoice()
            setRedayShowUI()
        }
    }
    
    @objc public func dismiss(){
        cleanPlayer()
        timerTool.yxs_cancelTimer()
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }
    
    // MARK: -getter
    lazy var recordTotalLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        label.text = "建议录音时长不超过5分钟"
        //正在录音 0:05   #575A60
        return label
    }()
    
    lazy var recordTipsLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        label.text = "点击开始录音"
        //点击完成录音
        return label
    }()
    
    lazy var playerControl: RecordPayerControl = {
        let playerControl = RecordPayerControl.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        playerControl.layer.cornerRadius = 50
        playerControl.clipsToBounds = true
        playerControl.addTarget(self, action: #selector(playerClick), for: .touchUpInside)
        return playerControl
    }()
    
    lazy var refreshRecordButton: YXSCustomImageControl = {
        let refreshRecordButton = YXSCustomImageControl.init(imageSize: CGSize.init(width: 26, height: 26), position: .top, padding: 9.5)
        refreshRecordButton.font = UIFont.systemFont(ofSize: 16)
        refreshRecordButton.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        refreshRecordButton.title = "重录"
        refreshRecordButton.locailImage = "yxs_publish_audio_refresh"
        refreshRecordButton.addTarget(self, action: #selector(refreshRecordClick), for: .touchUpInside)
        return refreshRecordButton
    }()
    
    lazy var certainButton: YXSButton = {
        let certainButton = YXSButton()
        certainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        certainButton.backgroundColor = kBlueColor
        certainButton.layer.cornerRadius = 29
        certainButton.setMixedTitleColor(MixedColor(normal: UIColor.white, night: UIColor.white), forState: .normal)
        certainButton.setTitle("确定", for: .normal)
        certainButton.clipsToBounds = true
        certainButton.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return certainButton
    }()
    
    lazy var cancelButton: YXSButton = {
        let cancelButton = YXSButton()
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white), forState: .normal)
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return cancelButton
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        //        view.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return view
    }()
    
}

class RecordPayerControl: UIControl{
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        self.backgroundColor = kBlueColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var status: RecordStatus = .redayRecord {
        didSet{
            setNeedsDisplay()
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_publish_player"))
        return imageView
    }()
    
    lazy var aniLayer: CALayer = {
        let aniLayer = CAShapeLayer()
        aniLayer.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#A8C0FE").cgColor
        aniLayer.position = CGPoint(x: 50, y: 3.75)
        aniLayer.bounds = CGRect(x: 0, y: 0, width: 14, height: 7.5)
        aniLayer.cornerRadius = 2
        self.layer.addSublayer(aniLayer)
        return aniLayer
    } ()
    
    
    override func draw(_ rect: CGRect) {
        
        aniLayer.isHidden = true
        aniLayer.removeAllAnimations()
        
        //设置进度圆显示数字样式
        let size = rect.size
        
        let arcCenter = CGPoint(x: size.width*0.5, y: size.height*0.5)
        let radius = min(size.width, size.height)*0.5
        
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2 , clockwise: false)
        
        path.lineWidth = 15//设置线宽
        path.lineCapStyle = CGLineCap.round//设置线样式
        
        UIColor.yxs_hexToAdecimalColor(hex: "#EDF2FF").set()
        //绘制路径
        //镂空型
        path.stroke()
        switch status {
        case .Recording:
            aniLayer.isHidden = false
            aniLayer.yxs_circleCircleAnimal(size: rect.size)
            imageView.image = UIImage.init(named: "yxs_publish_stop")
        case .redayRecord:
            imageView.image = UIImage.init(named: "yxs_publish_player")
        case .Showing:
            aniLayer.isHidden = false
            aniLayer.yxs_circleCircleAnimal(size: rect.size)
            imageView.image = UIImage.init(named: "yxs_publish_stop")
        case .redayShow:
            imageView.image = UIImage.init(named: "yxs_publish_player")
        }
        
    }
}
