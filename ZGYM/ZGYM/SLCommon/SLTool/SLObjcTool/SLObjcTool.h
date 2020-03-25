//
//  SLObjcTool.h
//  ZGYM
//
//  Created by sl_mac on 2020/1/14.
//  Copyright © 2020 hunanyoumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLObjcTool : NSObject
+ (instancetype)shareInstance;
/// 拼接 加入http
- (NSString *)getCompleteWebsite:(NSString *)urlStr;

//判断此路径是否能够请求成功,直接进行HTTP请求
- (void)urliSAvailable:(NSString *)urlStr;
@end

NS_ASSUME_NONNULL_END
