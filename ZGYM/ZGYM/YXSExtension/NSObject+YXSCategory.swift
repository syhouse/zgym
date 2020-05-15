//
//  NSObject+SLCategory.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/6.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation

extension NSObject{
    
    var yxs_user: YXSEducationUserModel {
        get{
            YXSPersonDataModel.sharePerson.userModel
        }
    }
    
    var yxs_childrenClassList: [[String: Int]]{
        get{
            var childrenClassList = [[String: Int]]()
            if let children = yxs_user.children{
                for model in children{
                    if model.classId != nil{
                        let info = ["classId": model.classId ?? 0,"childrenId": model.id ?? 0]
                        childrenClassList.append(info)
                    }
                    
                }
            }
            return childrenClassList
        }
    }
    
    func yxs_startTime(_ currentDate: Date = Date(), currentDay: String? = nil) -> String{
        let dateFormatter = DateFormatter()
        if let currentDay = currentDay{
            
            dateFormatter.dateFormat = "yyyy-MM"
            
            
            var currentStr = dateFormatter.string(from: currentDate)
            currentStr += "-\(currentDay) 00:00:00"
            return currentStr
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var currentStr = dateFormatter.string(from: currentDate)
            currentStr += " 00:00:00"
            return currentStr
        }
        
    }
    
    func yxs_dealList(list:[YXSHomeListModel],childId: Int?, isAgenda: Bool) -> [YXSHomeListModel]{
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            return list
        }
        var newList = [YXSHomeListModel]()
        for model in list{
            if isAgenda{
                for info in self.yxs_childrenClassList{
                    if model.classId == info["classId"]{
                        if model.childrenId == nil{
                            model.childrenId = info["childrenId"]
                            if model.commitState == 2{
                                model.childrenId = nil
                            }else{
                                newList.append(model)
                            }
                            
                        }else{
                            let newModel = model.copy()
                            if let newModel = newModel as? YXSHomeListModel{
                                newModel.childrenId = info["childrenId"]
                                if newModel.commitState == 2{
                                    newModel.childrenId = nil
                                }else{
                                    newList.append(newModel)
                                }
                            }
                            
                        }
                    }
                }
                
            }else{
                model.childrenId = childId
                newList.append(model)
            }
            
        }
        return newList
    }
    
    func yxs_dealList(list:[YXSSolitaireModel],childId: Int?, isAgenda: Bool) -> [YXSSolitaireModel]{
        if isAgenda{
            for model in list{
                if model.state == nil{
                    model.state = 10
                }
            }
            return list
        }
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER{
            return list
        }
        var newList = [YXSSolitaireModel]()
        for model in list{
            model.childrenId = childId
            newList.append(model)
        }
        return newList
    }
    
    func yxs_dealList(list:[YXSPunchCardModel],childId: Int?, isAgenda: Bool) -> [YXSPunchCardModel]{
        if YXSPersonDataModel.sharePerson.personRole == .TEACHER || isAgenda{
            return list
        }
        var newList = [YXSPunchCardModel]()
        for model in list{
            model.childrenId = childId
            newList.append(model)
        }
        return newList
    }
    
    func yxs_weakText(periodList: [Int]?) -> String{
        var weakText = "周期:"
        if let periodList = periodList{
            if periodList.count == 7{
                weakText += "每天"
            }else{
                var texts = [String]()
                for model in periodList{
                    switch model {
                    case 2:
                        texts.append("一")
                    case 3:
                        texts.append("二")
                    case 4:
                        texts.append("三")
                    case 5:
                        texts.append("四")
                    case 6:
                        texts.append("五")
                    case 7:
                        texts.append("六")
                    case 1:
                        texts.append("七")
                    default: break
                        
                    }
                }
                weakText += texts.joined(separator: "/")
            }
            return weakText
        }
        return ""
    }
    
    //当前时间 和传入的date比较
    func yxs_isToDay(_ currentDate: Date = Date(), compareDate: Date? = Date(),currentDay dayCount: String? = nil) -> YXSCalendarDateCompare{
        var currentDay = "1"
        let dateFormatter = DateFormatter()
        var currentYear = ""
        var currentMonth = ""
        if let dayCount = dayCount{
            
            dateFormatter.dateFormat = "yyyy-MM"
            
            let currentStr = dateFormatter.string(from: currentDate)
            currentYear = String(currentStr.split(separator: "-").first ?? "")
            currentMonth = String(currentStr.split(separator: "-").last ?? "")
            currentDay = dayCount
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentStr = dateFormatter.string(from: currentDate)
            currentYear = String(currentStr.split(separator: "-").first ?? "")
            currentMonth = String(currentStr.split(separator: "-")[1] )
            currentDay = String(currentStr.split(separator: "-").last ?? "")
        }
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayStr = dateFormatter.string(from: compareDate ?? Date())
        let todayYear = String(todayStr.split(separator: "-").first ?? "")
        let todayMonth = String(todayStr.split(separator: "-")[1] )
        let todayDay = String(todayStr.split(separator: "-").last ?? "")
        
        let yearCount = Int(currentYear)! - Int(todayYear)!
        let monthCount = Int(currentMonth)! - Int(todayMonth)!
        let dayCount = Int(currentDay)! - Int(todayDay)!
        if  yearCount > 0  || (yearCount == 0 && monthCount > 0)  || (yearCount == 0 && monthCount == 0 && dayCount > 0)
        {
            return .Big
        }else if yearCount == 0 && monthCount == 0 && dayCount == 0{
            return .Today
        }
        return .Small
        
    }
    
    //    func removeItems<T: Any>(items:[T],sources:[T],(()->(_ complet: ))){
    //        for model in items{
    //            for source in sources{
    //
    //            }
    //        }
    //    }
    
    // MARK: -二维码
    //MARK: -传进去字符串,生成二维码图片
    public func yxs_setupQRCodeImage(_ text: String, image: UIImage?) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
            //如果有一个头像的话，将头像加入二维码中心
            if let image = image {
                //给头像加一个白色圆边（如果没有这个需求直接忽略）
//                image = circleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
                //合成图片
                let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 60, height: 60)
                
                return newImage
            }
            
            return qrCodeImage
        }
        
        return UIImage()
    }
    
    //image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
    private func syntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage{
        //开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        //绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        let bezierPath = UIBezierPath.init(roundedRect: CGRect(x: x, y: y, width: width, height: height), cornerRadius: 5)
        bezierPath.addClip()
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
    //MARK: -生成高清的UIImage
    private func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    //生成边框
    private func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width:sourceImage.size.height) * 0.5
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// MARK: - 通知
extension NSObject{
    
    /// 限制文字输入长度
    /// - Parameters:
    ///   - obj: 键盘通知
    ///   - length: 输入框最大长度
    @objc func greetingTextFieldChanged(obj:Notification, length: Int = 10) {
        if let textField = obj.object as? UITextField{
            guard let _:UITextRange = textField.markedTextRange else {
                //记录当前光标的位置，后面需要进行修改
                let cursorPostion = textField.offset(from: textField.endOfDocument, to: textField.selectedTextRange!.end)
                //判断非中文的正则表达式
                //            let pattern = "[^A-Za-z\\u4E00-\\u9FA5]"
                //替换后的字符串(已过滤非中文字符) subjectField.text!.yxs_pregReplace(pattern: pattern, with: "")
                var str = textField.text!
                //限制最大输入长度
                if str.count > length {
                    str = String(str.prefix(length))
                }

                textField.text = str
                //让光标停留在正确的位置
                let targetPosion = textField.position(from: textField.endOfDocument, offset: cursorPostion)!
                textField.selectedTextRange = textField.textRange(from: targetPosion, to: targetPosion)
                return
            }
        }
    }
    
    /// 限制字符输入长度
    /// - Parameters:
    ///   - obj: 键盘通知
    ///   - length: 输入框最大长度
    @objc func greetingTextFieldChanged(obj:Notification, charslength: Int = 10) {
        if let textField = obj.object as? UITextField{
            guard let _:UITextRange = textField.markedTextRange else {
                //记录当前光标的位置，后面需要进行修改
                let cursorPostion = textField.offset(from: textField.endOfDocument, to: textField.selectedTextRange!.end)
                //判断非中文的正则表达式
                //            let pattern = "[^A-Za-z\\u4E00-\\u9FA5]"
                //替换后的字符串(已过滤非中文字符) subjectField.text!.yxs_pregReplace(pattern: pattern, with: "")
                var str = textField.text!
                //限制最大输入长度
                if str.yxs_numberOfChars() > charslength {
                    str = str.yxs_lengtToChars(length: charslength)
                }

                textField.text = str
                //让光标停留在正确的位置
                let targetPosion = textField.position(from: textField.endOfDocument, offset: cursorPostion)!
                textField.selectedTextRange = textField.textRange(from: targetPosion, to: targetPosion)
                return
            }
        }
    }
}
