//
//  SLVideoPlayController.m
//  ZGYM
//
//  Created by yanlong on 2020/2/27.
//  Copyright © 2020 hmym. All rights reserved.
//

#import "SLVideoPlayController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZGYM-Swift.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

@interface SLVideoPlayController ()

@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, assign) BOOL isBack;  //是否返回到上层

@end

@implementation SLVideoPlayController

@synthesize playerView;
@synthesize backImgView;
@synthesize playButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    CLPlayerView *player = [[CLPlayerView alloc] initWithFrame:self.view.bounds];
    playerView = player;
    [self.view addSubview:playerView];

    [playerView updateWithConfigure:^(CLPlayerViewConfigure *configure) {
        //重复播放
        configure.repeatPlay = NO;
        //支持横屏
        configure.isLandscape = NO;
        //支持自动旋转
        configure.autoRotate = NO;
        //按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑
        configure.videoFillMode = VideoFillModeResizeAspect;
        //后台返回是否继续播放
        configure.backPlay = NO;
        //转子颜色
        configure.strokeColor = [UIColor grayColor];
        //工具条消失时间，默认10s
        configure.toolBarDisappearTime = 4;
        //顶部工具条隐藏样式，默认不隐藏
        configure.topToolBarHiddenType = TopToolBarHiddenAlways;
     }];

    NSDictionary *videoDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:YXSPersonDataModel.sharePerson.userModel.account];
    NSString *videoPath = [videoDic objectForKey:self.videoUrl];
    if (videoPath.length) {
        NSString *path = [NSString stringWithFormat:@"%@%@",DocumentPath,videoPath];
        playerView.url = [NSURL fileURLWithPath:path];
        self.savePhotoUrl = [NSURL fileURLWithPath:path];
    }
    else {
        playerView.url = [NSURL URLWithString:self.videoUrl];
        [self downLoadWithURL:self.videoUrl fileDir:@"videoURLPath/" success:^(NSString *path) {
            NSArray *pathArray = [path componentsSeparatedByString:@"Documents"]; //按Documents拆分数组
            if (pathArray.count > 1) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:videoDic];
                [mutDic setValue:pathArray.lastObject forKey:self.videoUrl];
                [[NSUserDefaults standardUserDefaults] setObject:mutDic.copy forKey:YXSPersonDataModel.sharePerson.userModel.account];
//                [[NSUserDefaults standardUserDefaults] setObject:pathArray.lastObject forKey:self.videoUrl];
                self.savePhotoUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",DocumentPath,pathArray.lastObject]];

            }
        } failure:^(NSError *error) {

        }];
    }

    //播放
    [playerView playVideo];
    //返回按钮点击事件回调,小屏状态才会调用，全屏默认变为小屏
    [playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [playerView endPlay:^{
        self.playButton.hidden = NO;
    }];

    //点击工具栏上播放按钮
    
    @weakify(self);
    playerView.clickPlayButtonBlock = ^(BOOL playing) {
        @strongify(self);
        self.playButton.hidden = playing;
    };

    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    gesture.minimumPressDuration = 0.5;
    [playerView addGestureRecognizer:gesture];

    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(Screen_Width * 0.5f - 35, Screen_Height * 0.5f - 35, 70, 70);
    [playButton setBackgroundImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateNormal];
    [playButton setExclusiveTouch:YES];
    [playButton addTarget:self action:@selector(clickPlayButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    playButton.hidden = YES;

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, kStatusBarHeight, 50, 44);
    backButton.adjustsImageWhenHighlighted = NO;
    [backButton setImage:[UIImage imageNamed:@"arrow_48-1"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

//    if (self.isBack == YES) {
        [self.playerView destroyPlayer];
//    }
}

- (void)clickBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longPressView:(UILongPressGestureRecognizer *)gesture {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveVideoToLibrary];
    }]];
     [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clickPlayButton {
    playButton.hidden = YES;
    [playerView playVideo];
}

- (void)pauseVideo {
    playButton.hidden = NO;
    [playerView pausePlay];
}

#pragma mark - 视频下载保存本地
- (NSURLSessionTask *)downLoadWithURL:(NSString *)url fileDir:(NSString *)fileDir success:(void(^)(NSString *path))success failure:(void(^)(NSError *error))failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *_sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //下载进度
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            //拼接缓存目录
            NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
            //打开文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //创建Download目录
            [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
            //拼接文件路径
            NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
            //返回文件位置的URL路径
            return [NSURL fileURLWithPath:filePath];

        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if(failure && error) {failure(error) ; return ;};
            success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;

        }];
        //开始下载
        [downloadTask resume];
        return downloadTask;
}

#pragma mark - 视频保存到相册
- (void)saveVideoToLibrary {
    NSInteger playState = [playerView obtainPlayState];
    if (playState == 0) {
        [self showMessage:@"视频出错，不能保存"];
        return;
    }

    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if (authorStatus == PHAuthorizationStatusAuthorized) {
        if (self.savePhotoUrl == nil) {
            [self showMessage:@"视频下载中，请稍后重试"];
        }
        else {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.savePhotoUrl];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [self showMessage:@"保存视频失败"];
                    }
                    else {
                        [self showMessage:@"保存相册成功"];
                    }
                });
            }];
        }
    }
    else if (authorStatus == PHAuthorizationStatusNotDetermined) {
        //获取用户对是否允许访问相册的操作
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        }];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相册权限已关闭" message:@"是否到相册权限设置界面，进行设置" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
         [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)showMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    [hud hideAnimated:YES afterDelay:1.0];
}

#pragma mark - 获取视频缓存大小
+ (CGFloat)getVideoCacheSize {
    //注释 ios的文件大小以1000为单位,不是以1024作为单位.
    unsigned long long folderSize = 0 ;
    NSString *downloadDir = [DocumentPath stringByAppendingPathComponent:@"videoURLPath/"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //文件是否存在
    BOOL isExist;
    //是否文件夹
    BOOL isFolder;
    isExist  = [fileManager fileExistsAtPath:downloadDir isDirectory:&isFolder ];
    if (!isExist) {
       return 0;
    }
    if (isFolder) {
       //是文件夹
       NSEnumerator * childFileEnumerator = [[fileManager subpathsAtPath:downloadDir] objectEnumerator];
       NSString * fileName;
       while ((fileName = [childFileEnumerator nextObject]) != nil) {
          NSString * fileAbsolutePath = [downloadDir stringByAppendingPathComponent:fileName];
          folderSize += [[fileManager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
//          NSLog(@"%@",fileAbsolutePath);
       }
    }else{
       //不是文件夹
       folderSize = [[fileManager attributesOfItemAtPath:downloadDir error:nil] fileSize];
    }
    NSNumber *numSize = [NSNumber numberWithFloat:folderSize / 1000.0 / 1000.0];
    NSLog(@"视频缓存大小为 %.2f MB",numSize.floatValue);
    return numSize.floatValue;
}

#pragma mark - 清空视频缓存
+ (void)clearVideoCache {
    //删除NSUserDefaults中存储的路径
    NSDictionary *videoDic = [NSDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:videoDic forKey:YXSPersonDataModel.sharePerson.userModel.account];

    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"videoURLPath/"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //删除文件夹下所有文件
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:filePath];
    NSLog(@"删除指定文件夹下所有文件：%@",filePath);
    for (NSString *fileName in enumerator) {
        BOOL success = [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:fileName] error:nil];
        if (!success) {
            NSLog(@"删除单个文件失败：%@",[filePath stringByAppendingPathComponent:fileName]);
        }
    }
}

@end
