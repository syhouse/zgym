//
//  SLSearchBar.m
//  ZLProject
//
//  Created by sl_mac on 2019/6/28.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import "SLSearchBar.h"
#import <Masonry/Masonry.h>

@implementation SLSearchBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
        [self createUI];
    }
    return self;
}

- (void)config {
    self.font = [UIFont systemFontOfSize:11.0f];
    self.textColor = UIColor.blackColor;
}

- (void)createUI {
    self.clipsToBounds = YES;
    self.leftViewMode = UITextFieldViewModeNever;
    self.rightViewMode = UITextFieldViewModeNever;
    self.backgroundColor = [UIColor whiteColor];
    self.returnKeyType = UIReturnKeySearch;
    
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = [UIImage imageNamed:@"search"];
    [self addSubview:leftImage];
    //    leftImage.frame = CGRectMake(8, 7.5, 15, 15);
    __weak typeof(self) weakSelf = self;
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(8));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.equalTo(@(12));
    }];
    
    UIView *splitLine = [[UIView alloc] init];
    splitLine.backgroundColor = UIColor.blackColor;
    [self addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImage.mas_right).offset(3);
        make.top.equalTo(weakSelf.mas_top).offset(6);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-6);
        make.width.equalTo(@(1));
    }];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super textRectForBounds:bounds];
    iconRect.origin.x += 30;
    iconRect.size.width -= 60;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super editingRectForBounds:bounds];
    iconRect.origin.x += 30;
    iconRect.size.width -= 60;
    return iconRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
