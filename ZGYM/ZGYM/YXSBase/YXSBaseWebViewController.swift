//
//  QuestionViewController.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/20.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import WebKit
import NightNight

class YXSBaseWebViewController: YXSBaseViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)//WKScriptMessage对象
        print(message.name) //name : nativeMethod
        print(message.body) //js回传参数
    }
    var onBackBlock:(()->())?
    var isCache: Bool = false
    var scriptKey: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        YXSMusicPlayerWindowView.setView(hide: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController?.viewControllers.first is YXSExcellentEducationVC{
            YXSMusicPlayerWindowView.setView(hide: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x181A23)
        webView.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x181A23)
        // Do any additional setup after loading the view.
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.webView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        if URL(string: self.loadUrl ?? "") != nil {
            MBProgressHUD.yxs_showLoading(inView: self.view)
        }
    }

    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler(self.scriptKey)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if URL(string: self.loadUrl ?? "") != nil {
//            MBProgressHUD.yxs_showLoading(inView: self.view)
//        }
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if URL(string: self.loadUrl ?? "") != nil {
//            MBProgressHUD.yxs_showLoading(inView: self.view)
//        }
//    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        MBProgressHUD.yxs_showLoading(inView: self.view)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.yxs_hideHUDInView(view: self.view)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        MBProgressHUD.yxs_hideHUDInView(view: self.view)
    }
    
    // MARK: - Setter
    var loadUrl: String? {
        didSet {
            if let tmp = self.loadUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: tmp) {
                    if isCache {
                        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                        webView.load(request)
                    } else {
                        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
                        webView.load(request)
                    }
                    
                    
                    
                    
                } else {
                    MBProgressHUD.yxs_showMessage(message: "网页地址无效")
                }
                
            }
        }
    }
    
    //添加观察者方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            
        //设置进度条
//        if keyPath == "estimatedProgress"{
//            if webView.estimatedProgress >= 1.0 {
//                MBProgressHUD.yxs_hideHUDInView(view: self.view)
//            }
//        }
            
       //重设标题
//        else
        if self.title?.count ?? 0 <= 0 {
            if keyPath == "title" {
                self.title = self.title?.count ?? 0 > 0 ? self.title : self.webView.title
            }
        }
        
    }
    
    override func yxs_onBackClick() {
        if webView.canGoBack {
            webView.goBack()
            
        } else {
            onBackBlock?()
            self.navigationController?.popViewController()
        }
    }
    
    
    
    // MARK: - LazyLoad
    lazy private var webView: WKWebView = {
        let web = WKWebView()
        web.uiDelegate = self
        web.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x181A23)
//        web.backgroundColor = UIColor.white
        return web
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
