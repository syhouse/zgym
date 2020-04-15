//
//  YXSCustomTextMessageCellData.m
//  ZGYM
//
//  Created by Liu Jie on 2020/3/11.
//  Copyright © 2020 hmym. All rights reserved.
//

#import "YXSCustomTextMessageCellData.h"

@implementation YXSCustomTextMessageCellData
- (CGSize)contentSize
{
    CGSize size = [super contentSize];
    TIMElem *elem = [self.innerMessage getElem:0];
    if([elem isKindOfClass:[TIMCustomElem class]]){
        TIMCustomElem *customElem = (TIMCustomElem *)elem;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:customElem.data options:NSJSONReadingMutableContainers error:nil];
        if (dic[@"serviceType"] == nil) {
            return size;
        }
    }
    return CGSizeMake(size.width, size.height + DETAIL_BUTTON_H);
}

@end
