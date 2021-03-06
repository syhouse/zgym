//
//  YXSCustomTextMessageCell.m
//  ZGYM
//
//  Created by Liu Jie on 2020/3/11.
//  Copyright © 2020 hmym. All rights reserved.
//

#import "YXSCustomTextMessageCell.h"
#import "ZGYM-Swift.h"

@implementation YXSCustomTextMessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _myLinkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _myLinkLabel.text = @"点击查看 >";
        _myLinkLabel.font = [UIFont systemFontOfSize:15];
        _myLinkLabel.textColor = [UIColor yxs_hexToAdecimalColorWithHex:@"#4E88FF"];//[UIColor blueColor];
        [self.container addSubview:_myLinkLabel];
    }
    return self;
}

- (void)fillWithData:(YXSCustomTextMessageCellData *)data;
{
    TIMElem *elem = [data.innerMessage getElem:0];
    if([elem isKindOfClass:[TIMCustomElem class]]){
        TIMCustomElem *customElem = (TIMCustomElem *)elem;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:customElem.data options:NSJSONReadingMutableContainers error:nil];
        if (dic[@"serviceType"] == nil) {
            _myLinkLabel.hidden = YES;
        }
    }
    [super fillWithData:data];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.myLinkLabel.mm_sizeToFit().mm_left(16).mm_bottom(24);
}
@end
