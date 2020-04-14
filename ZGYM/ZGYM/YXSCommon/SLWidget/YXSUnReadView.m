//
//  YXSUnReadView.m
//  HNYMEducation
//
//  Created by zgjy_mac on 2020/1/14.
//  Copyright © 2020 hunanyoumeng. All rights reserved.
//

#import "YXSUnReadView.h"

@implementation YXSUnReadView

- (void)setupViews
{
    self.unReadLabel = [[UILabel alloc] init];
    self.unReadLabel.text = @"11";
    self.unReadLabel.font = [UIFont systemFontOfSize:12];
    self.unReadLabel.textColor = [UIColor whiteColor];
    self.unReadLabel.textAlignment = NSTextAlignmentCenter;
    [self.unReadLabel sizeToFit];
    [self addSubview:self.unReadLabel];

    self.layer.cornerRadius = (self.unReadLabel.frame.size.height + 2*0.5)/2.0;
//    self.layer.cornerRadius = (self.unReadLabel.frame.size.height)/2.0;
    [self.layer masksToBounds];
    self.backgroundColor = [UIColor redColor];
    self.hidden = YES;
}

- (void)defaultLayout
{
    [self.unReadLabel sizeToFit];
    CGFloat width = self.unReadLabel.frame.size.width + 2*1;
    CGFloat height =  self.unReadLabel.frame.size.height + 2*0.5;
    if(width < height){
        width = height;
    }
    self.bounds = CGRectMake(0, 0, width, height);
    self.unReadLabel.frame = self.bounds;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
