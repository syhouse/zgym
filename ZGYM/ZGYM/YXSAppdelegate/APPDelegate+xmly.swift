//
//  APPDelegate+xmly.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

extension AppDelegate: XMReqDelegate{
    func didXMInitReqOK(_ result: Bool) {
        SLLog("didXMInitReqOK:\(result ? "sucess" : "fail")")
    }
    
    func didXMInitReqFail(_ respModel: XMErrorModel!) {
        SLLog("didXMInitReqFail")
    }
    
    func registerXMLY(){
        XMReqMgr.sharedInstance()?.registerXMReqInfo(withKey: "aa31bbbe88a2d9ddc002588815f957d0", appSecret: "16b176443f1df1df86b0a56dc4fd9f76")
        XMReqMgr.sharedInstance()?.delegate = self
    }
}
