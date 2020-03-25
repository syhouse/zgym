//
//  SLCustomTextMessageCell.h
//  ZGYM
//
//  Created by Liu Jie on 2020/3/11.
//  Copyright © 2020 hmym. All rights reserved.
//

#import "TUITextMessageCell.h"
#import "SLCustomTextMessageCellData.h"
#import "MMLayout/UIView+MMLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLCustomTextMessageCell : TUITextMessageCell
@property UILabel *myTextLabel;
@property UILabel *myLinkLabel;
- (void)fillWithData:(SLCustomTextMessageCellData *)data;
@end

NS_ASSUME_NONNULL_END
