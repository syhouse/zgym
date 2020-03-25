//
//  SLInputViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/6.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLInputViewController: SLBaseViewController {

    var completionHandler: ((_ text:String, _ vc:SLInputViewController)->())?
    private var maxLength:Int = 11
    
    init(maxLength:Int, completionHandler:(((_ text:String, _ vc:SLInputViewController)->()))?) {
        super.init()
        self.maxLength = maxLength
        self.completionHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(contentView)
        
        self.contentView.addSubview(self.tfText)
        self.contentView.addSubview(self.btnDone)
        layout()
    }
    
    func layout() {
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }

        self.contentView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        self.tfText.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(49)
        })
        
        self.btnDone.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tfText.snp_bottom).offset(42)
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.width.equalTo(318)
            make.height.equalTo(49)
            make.bottom.equalTo(0)
        })
    }
    
    // MARK: - Other
    @objc func accountDidChange(sender: UITextField) {
        guard let _:UITextRange = sender.markedTextRange else {
            //记录当前光标的位置，后面需要进行修改
            let cursorPostion = sender.offset(from: sender.endOfDocument, to: sender.selectedTextRange!.end)

            var str = sender.text!
            //限制最大输入长度
            if str.count > maxLength {
                str = String(str.prefix(maxLength))
            }
            sender.text = str
            //让光标停留在正确的位置
            let targetPosion = sender.position(from: sender.endOfDocument, offset: cursorPostion)!
            sender.selectedTextRange = sender.textRange(from: targetPosion, to: targetPosion)
            return
        }
//        if sender.text!.count > maxLength {
//            let subStr = sender.text!.prefix(maxLength)
//            sender.text = String(subStr)
//
//        } else {
//
//        }
    }
    
    @objc func doneClick(sender: SLButton) {
        self.view.endEditing(true)
        self.completionHandler?(self.tfText.text ?? "", self)
    }
    
    // MARK: - LazyLoad
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.mixedBackgroundColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#F2F5F9"), night: kNightBackgroundColor)
        return scrollView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tfText: SLQSTextField = {
        let tf = SLQSTextField()
        tf.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)//sl_hexToAdecimalColor(hex: "#F2F5F9")
        tf.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tf.mixedTextColor = MixedColor(normal: 0x575A60, night: 0xffffff)
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.clearButtonMode = .whileEditing
        tf.sl_addLine(position: LinePosition.bottom, color: UIColor.sl_hexToAdecimalColor(hex: "#CFD8E1"))
        tf.addTarget(self, action: #selector(accountDidChange(sender:)), for: .editingChanged)
        return tf
    }()
    
    lazy var btnDone: SLButton = {
        let btn = SLButton()
        btn.setTitle("确认", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setMixedTitleColor(MixedColor(normal: 0xFEFEFF, night: 0xffffff), forState: .normal)
        btn.sl_gradualBackground(frame: CGRect(x: 0, y: 0, width: 318, height: 49), startColor: UIColor.sl_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.sl_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24)
        if NightNight.theme == .normal{
            btn.sl_shadow(frame: CGRect(x: 0, y: 0, width: 318, height: 49), color: UIColor.gray, cornerRadius: 24, offset: CGSize(width: 4, height: 4))
        }
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
        return btn
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
