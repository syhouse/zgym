//
//  SLMAMapView.h
//  ZLProject
//
//  Created by sl_mac on 2019/6/20.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLMAMapView : MAMapView
@property (nonatomic, assign) BOOL shouldUpdatePOI;
@end

NS_ASSUME_NONNULL_END
