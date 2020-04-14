//
//  YXSMAMapView.m
//  ZLProject
//
//  Created by zgjy_mac on 2019/6/20.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import "YXSMAMapView.h"

@implementation YXSMAMapView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.shouldUpdatePOI = YES;
}

@end
