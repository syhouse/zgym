//
//  YXSPhotoBrowserTool.m
//  ZGYM
//
//  Created by yanlong on 2020/3/23.
//  Copyright © 2020 hmym. All rights reserved.
//

#import "YXSPhotoBrowserTool.h"
#import "LFPhotoEditingController.h"
#import "ZGYM-Swift.h"

@interface YXSPhotoBrowserTool () <LFPhotoEditingControllerDelegate>
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) NSArray<NSNumber *> *durations;
@end

@implementation YXSPhotoBrowserTool

@synthesize yb_currentData = _yb_currentData;
@synthesize yb_containerView = _yb_containerView;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentOrientation = _yb_currentOrientation;

- (void)yb_containerViewIsReadied {
    [self.yb_containerView addSubview:self.editButton];
    CGSize size = self.yb_containerSize(self.yb_currentOrientation());
    self.editButton.center = CGPointMake(size.width / 2.0, size.height - 80);
}

- (void)yb_hide:(BOOL)hide {
    self.editButton.hidden = YES;
}

- (void)yb_pageChanged {
    self.editButton.hidden = NO;
    [self updateViewOriginButtonSize];
}

- (void)yb_orientationChangeAnimationWithExpectOrientation:(UIDeviceOrientation)orientation {
    // 旋转的效果自行处理了
}

#pragma mark - private

- (void)updateViewOriginButtonSize {
    CGSize size = self.editButton.intrinsicContentSize;
    self.editButton.bounds = (CGRect){CGPointZero, CGSizeMake(size.width + 15, size.height)};
}

#pragma mark - Action
- (void)clickEditButton:(UIButton *)sender {
//    LFPhotoEditingController *editVC = [[LFPhotoEditingController alloc] init];
//    editVC.delegate = self;
////    [editVC setEditImage:self.image durations:self.durations];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:editVC];
//    [navi setNavigationBarHidden:YES];
//    [UIUtil.curruntNav presentViewController:navi animated:YES completion:nil];
}

#pragma mark - LFPhotoEditingControllerDelegate
- (void)lf_PhotoEditingControllerDidCancel:(LFPhotoEditingController *)photoEditingVC {
    [UIUtil.TopViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didFinishPhotoEdit:(LFPhotoEdit *)photoEdit {
    [UIUtil.TopViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_editButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _editButton.backgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.75];
        _editButton.layer.cornerRadius = 5.0;
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

@end
