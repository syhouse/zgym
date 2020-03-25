//
//  SLMAMapView.m
//  ZLProject
//
//  Created by sl_mac on 2019/6/20.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import "SLMAMapView.h"

@implementation SLMAMapView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.shouldUpdatePOI = YES;
}

@end
