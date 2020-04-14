//
//  TUIVideoViewController.m
//  TXIMSDK_TUIKit_iOS
//
//  Created by annidyfeng on 2019/5/24.
//

#import "TUIVideoViewController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
@import MediaPlayer;
@import AVFoundation;
@import AVKit;

@interface TUIVideoViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *progress;
@property AVPlayerViewController *playerVc;

@property UIImage *saveBackgroundImage;
@property UIImage *saveShadowImage;

@end

@implementation TUIVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImage *img = [UIImage imageNamed:@"back"];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 18)];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.navigationItem.leftBarButtonItem = item;
    
    @weakify(self)
    if (![_data isVideoExist])
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.frame = self.view.bounds;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];

        if (_data.thumbImage == nil) {
            [_data downloadThumb];
        }

        _progress = [[UILabel alloc] initWithFrame:self.view.bounds];
        _progress.textColor = [UIColor whiteColor];
        _progress.font = [UIFont systemFontOfSize:18];
        _progress.textAlignment = NSTextAlignmentCenter;
        _progress.userInteractionEnabled = YES;
        [self.view addSubview:_progress];

        [RACObserve(_data, thumbImage) subscribeNext:^(UIImage *x) {
            @strongify(self)
            self.imageView.image = x;
        }];
        [RACObserve(_data, videoProgress) subscribeNext:^(NSNumber *x) {
            @strongify(self)
            int p = [x intValue];
            self.progress.text = [NSString stringWithFormat:@"%d%%", p];
        }];

        [_data downloadVideo];
    }

    [[[RACObserve(_data, videoPath) filter:^BOOL(NSString *path) {
        return [path length] > 0;
    }] take:1] subscribeNext:^(NSString *path) {
        @strongify(self)
        [self addPlayer:path];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
//    if (parent == nil) {
//        [self.navigationController.navigationBar setBackgroundImage:self.saveBackgroundImage
//                                                      forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.shadowImage = self.saveShadowImage;
//    }
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)addPlayer:(NSString *)path
{
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] initWithNibName:nil bundle:nil];
    vc.player = ({
        AVPlayer *p = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
        p;
    });
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.player play];
    vc.view.frame = self.view.frame;
    self.progress.hidden = YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
