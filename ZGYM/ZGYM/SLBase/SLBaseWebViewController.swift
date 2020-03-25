//
//  QuestionViewController.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/20.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import WebKit
import NightNight

class SLBaseWebViewController: SLBaseViewController, WKNavigationDelegate {

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
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        MBProgressHUD.sl_showLoading(inView: self.view)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.sl_hideHUDInView(view: self.view)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        MBProgressHUD.sl_hideHUDInView(view: self.view)
    }
    
    // MARK: - Setter
    var loadUrl: String? {
        didSet {
            if let url = URL(string: self.loadUrl ?? "") {
                let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
                webView.load(request)
                
            } else {
                MBProgressHUD.sl_showMessage(message: "网页地址无效")
            }
        }
    }
    
    //添加观察者方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            
        //设置进度条
//        if keyPath == "estimatedProgress"{
//            if webView.estimatedProgress >= 1.0 {
//                MBProgressHUD.sl_hideHUDInView(view: self.view)
//            }
//        }
            
       //重设标题
//        else
        if keyPath == "title" {
            self.title = self.title?.count ?? 0 > 0 ? self.title : self.webView.title
        }
    }
    
    override func sl_onBackClick() {
        if webView.canGoBack {
            webView.goBack()
            
        } else {
            self.navigationController?.popViewController()
        }
    }
    
    // MARK: - LazyLoad
    lazy private var webView: WKWebView = {
        let web = WKWebView()
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
