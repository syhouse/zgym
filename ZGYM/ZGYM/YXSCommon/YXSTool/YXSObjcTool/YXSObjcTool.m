//
//  YXSObjcTool.m
//  ZGYM
//
//  Created by zgjy_mac on 2020/1/14.
//  Copyright © 2020 hunanyoumeng. All rights reserved.
//

#import "YXSObjcTool.h"

@implementation YXSObjcTool
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static YXSObjcTool *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[YXSObjcTool alloc] init];
    });
    return _instance;
}

/// 拼接http://或者https://
- (NSString *)getCompleteWebsite:(NSString *)urlStr{

    NSString *returnUrlStr = nil;

    NSString *scheme = nil;

    assert(urlStr != nil);

    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ( (urlStr != nil) && (urlStr.length != 0) ) {

        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];

        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];

            assert(scheme != nil);

            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;

            } else {
                //不支持的URL方案
            }
        }
    }
    return returnUrlStr;
}

//判断此路径是否能够请求成功,直接进行HTTP请求
- (void)urliSAvailable:(NSString *)urlStr{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];

    [request setHTTPMethod:@"HEAD"];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error) {
            NSLog(@"不可用");

        }else{
            NSLog(@"可用");
        }
    }];

    [task resume];
}
@end
