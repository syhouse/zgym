//
//  SLVideoPlayController.h
//  ZGYM
//
//  Created by yanlong on 2020/2/27.
//  Copyright © 2020 hmym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#define iPhoneX ([UIScreen mainScreen].bounds.size.height >= 812)
#define kStatusBarHeight            (iPhoneX ? [[UIApplication sharedApplication] statusBarFrame].size.height : 20.f)

@interface SLVideoPlayController : UIViewController

@property (nonatomic, copy) NSString *videoUrl;   //网络视频地址
@property (nonatomic, copy) NSURL *savePhotoUrl;    //保存到相册url

@property (nonatomic, weak) CLPlayerView *playerView;

/// 获取缓存视频大小
+ (CGFloat)getVideoCacheSize;

/// 清空视频缓存  路径地址为 Documents/videoURLPath
+ (void)clearVideoCache;

@end

NS_ASSUME_NONNULL_END
