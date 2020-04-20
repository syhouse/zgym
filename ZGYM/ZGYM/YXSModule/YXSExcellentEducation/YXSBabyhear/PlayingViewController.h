//
//  PlayingViewController.h
//  sdkDemo
//
//  Created by nali on 15/6/29.
//  Copyright (c) 2015年 nali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMSDK.h"

@interface PlayingViewController : UIViewController<XMTrackPlayerDelegate,XMLivePlayerDelegate>

@property (nonatomic,strong)XMTrack *track;
@property (nonatomic,strong)NSArray *trackList;

@property (nonatomic,strong)XMRadio *radio;
@property (nonatomic,strong)NSArray *programList;
@property (nonatomic,strong)XMRadioSchedule *radioSchedule;
@end
