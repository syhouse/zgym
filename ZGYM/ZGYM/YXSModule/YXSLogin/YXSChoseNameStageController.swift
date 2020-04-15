//
//  YXSChoseNameStageController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/19.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight
/// 输入称呼 和 选学段

class YXSChoseNameStageController: YXSBaseViewController {
 
    private var role: PersonRole?
    var stageIndex: Int = 0
    var currentStageName: String = "幼儿园"
    
    var yxs_completionHandler: ((_ text:String,_ index:Int, _ vc:YXSChoseNameStageController)->())?
    
    init(role: PersonRole?, completionHandler: ((_ text:String,_ index:Int, _ vc:YXSChoseNameStageController)->())? = nil) {
        super.init()
        self.yxs_completionHandler = completionHandler
        self.role = role ?? .PARENT
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = role == PersonRole.TEACHER ? "我是老师" : "我是家长"

        self.view.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x20232F)
        // Do any additional setup after loading the view.
//        self.fd_prefersNavigationBarHidden = true
//        self.fd_interactivePopDisabled = true
//        view.addSubview(customNav)
//        customNav.snp.makeConstraints { (make) in
//            make.left.right.top.equalTo(0)
//        }

        self.view.addSubview(lbTitle1)
        self.view.addSubview(tfInput)
        self.view.addSubview(btnDone)
        self.view.addSubview(lineView)
        
        if role == .TEACHER {
            self.view.addSubview(lbTitle2)
            self.view.addSubview(btnStage1)
            self.view.addSubview(btnStage2)
            self.view.addSubview(btnStage3)
        }
        
        lbTitle1.snp.makeConstraints({ (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            } else {
                // Fallback on earlier versions
                make.top.equalTo(0)
            }
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.height.equalTo(40)
        })
        
        tfInput.snp.makeConstraints({ (make) in
            make.top.equalTo(lbTitle1.snp_bottom)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.height.equalTo(49)
        })
        
        if role == .TEACHER {
            lbTitle2.snp.makeConstraints({ (make) in
                make.top.equalTo(tfInput.snp_bottom).offset(17)
                make.left.equalTo(15)
            })
            
            btnStage1.snp.makeConstraints({ (make) in
                make.top.equalTo(lbTitle2.snp_bottom).offset(17)
                make.left.equalTo(15)
                make.height.equalTo(34)
            })
            
            btnStage2.snp.makeConstraints({ (make) in
                make.top.equalTo(btnStage1.snp_top)
                make.left.equalTo(btnStage1.snp_right).offset(15)
                make.height.equalTo(btnStage1.snp_height)
                make.width.equalTo(btnStage1.snp_width)
            })
            
            btnStage3.snp.makeConstraints({ (make) in
                make.top.equalTo(btnStage1.snp_top)
                make.left.equalTo(btnStage2.snp_right).offset(15)
                make.right.equalTo(-15)
                make.height.equalTo(btnStage1.snp_height)
                make.width.equalTo(btnStage2.snp_width)
            })
            
            btnDone.snp.makeConstraints({ (make) in
                make.top.equalTo(btnStage1.snp_bottom).offset(70)
                make.centerX.equalTo(self.view.snp_centerX)
                make.width.equalTo(318)
                make.height.equalTo(49)
            })
            
        } else {
            btnDone.snp.makeConstraints({ (make) in
                make.top.equalTo(tfInput.snp_bottom).offset(70)
                make.centerX.equalTo(self.view.snp_centerX)
                make.width.equalTo(318)
                make.height.equalTo(49)
            })
        }

        lineView.snp.makeConstraints({ (make) in
            make.top.equalTo(tfInput.snp_bottom)
            make.left.equalTo(0).offset(0)
            make.right.equalTo(0).offset(0)
            make.height.equalTo(10)
        })

    }
    
    @objc func yxs_stageClick(sender: YXSButton) {
        self.btnStage1.isSelected = false
        self.btnStage1.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x282C3B)
//        self.btnStage1.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        self.btnStage2.isSelected = false
        self.btnStage2.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x282C3B)
//        self.btnStage2.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        self.btnStage3.isSelected = false
        self.btnStage3.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x282C3B)
//        self.btnStage3.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        
        sender.isSelected = true
        sender.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#4E87FF")
        stageIndex = sender.tag
        currentStageName = sender.titleLabel?.text ?? "幼儿园"
    }
    
    @objc func yxs_doneClick(sender: YXSButton) {
        self.view.endEditing(false)
        if tfInput.text?.count == 0 {
            MBProgressHUD.yxs_showMessage(message: "称呼不能为空")
            return
        }
        
        if role == .TEACHER {
            let alert = YXSConfirmationAlertView.showIn(target: self.view) { [weak self](sender, view) in
                guard let weakSelf = self else {return}
                if sender.titleLabel?.text == "确认" {
                    weakSelf.yxs_completionHandler?(weakSelf.tfInput.text ?? "", weakSelf.stageIndex, weakSelf)
                    view.close()
                } else {
                    /// 取消
                }
            }
            alert.lbTitle.text = ""
            alert.lbContent.text = "您当前选择的是\(currentStageName)学段选择后暂时不可更换，是否确认继续？"
            
        } else {
            self.yxs_completionHandler?(tfInput.text ?? "", stageIndex, self)
        }
    }
    
    lazy var lbTitle1: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "    输入您的称呼"
        lb.font = UIFont.systemFont(ofSize: 15)
//        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
//        lb.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        lb.mixedBackgroundColor = MixedColor(normal: 0xF2F5F9, night: 0x181A23)
        lb.mixedTextColor = MixedColor(normal: 0x898F9A, night: 0xBCC6D4)

        return lb
    }()

    lazy var tfInput: YXSQSTextField = {
        let view = YXSQSTextField()
        view.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let ph = role == PersonRole.TEACHER ? "比如：张三老师" : "比如：张三的爸爸"
        view.setPlaceholder(ph: ph)
        view.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x20232F)
        view.mixedTextColor = MixedColor(normal: 0x575A60, night: 0xFFFFFF)
//        view.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#575A60")
        return view
    }()
    
    lazy var lbTitle2: YXSLabel = {
        let lb = YXSLabel()
        lb.text = "请选择您工作所在学段"
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#898F9A")
        return lb
    }()
    
    lazy var btnStage1: YXSButton = {
        let btn = YXSButton()
        btn.tag = 0
        btn.isSelected = true
        btn.setTitle("幼儿园", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
//        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.clipsToBounds = true
//        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#4E87FF")
        btn.setTitleColor(NightNight.theme == .night ? UIColor.white : UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btn.mixedBackgroundColor = MixedColor(normal: 0x4E87FF, night: 0x4E87FF)
        btn.layer.cornerRadius = 2.5
        btn.addTarget(self, action: #selector(yxs_stageClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnStage2: YXSButton = {
        let btn = YXSButton()
        btn.tag = 1
        btn.setTitle("小学", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(NightNight.theme == .night ? UIColor.white : UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btn.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x282C3B)
//        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.clipsToBounds = true

//        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        btn.layer.cornerRadius = 2.5
        btn.addTarget(self, action: #selector(yxs_stageClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnStage3: YXSButton = {
        let btn = YXSButton()
        btn.tag = 2
        btn.setTitle("中学", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
//        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.clipsToBounds = true
//        btn.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9")
        btn.setTitleColor(NightNight.theme == .night ? UIColor.white : UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), for: .normal)
        btn.mixedBackgroundColor = MixedColor(normal: 0xF3F5F9, night: 0x282C3B)
        btn.layer.cornerRadius = 2.5
        btn.addTarget(self, action: #selector(yxs_stageClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("确认", for: .normal)
        btn.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xFEFEFF), forState: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: kBlueShadowColor, cornerRadius: 24, offset: CGSize(width: 2, height: 2))
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(yxs_doneClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: 0xF2F5F9, night: 0x181A23)
//        view.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9")
        return view
    }()
    
//    lazy var customNav: YXSCustomNav = {
//        let customNav = YXSCustomNav()
//        customNav.title = role == PersonRole.TEACHER ? "我是老师" : "我是学生"
//        customNav.backImageButton.isHidden = true
//        customNav.hasRightButton = false
//        return customNav
//    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
