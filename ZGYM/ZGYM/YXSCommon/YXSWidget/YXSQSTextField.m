//
//  YXSQSTextField.m
//  qujiyi
//
//  Created by zgjy_mac on 2019/8/7.
//  Copyright © 2019 jason. All rights reserved.
//

#import "YXSQSTextField.h"
@interface YXSQSTextField()<UITextFieldDelegate>
@end

@implementation YXSQSTextField
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(CGRect)adjustRectWithWidthRightView:(CGRect)bounds {
    CGRect paddedRect = bounds;
    paddedRect.size.width -= CGRectGetWidth(self.rightView.frame);
    return paddedRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect paddedRect = UIEdgeInsetsInsetRect(bounds, self.edgeInsets);
    if(self.rightViewMode == UITextFieldViewModeAlways || self.rightViewMode == UITextFieldViewModeUnlessEditing) {
        return[self adjustRectWithWidthRightView:paddedRect];
    }
    return paddedRect;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect paddedRect = UIEdgeInsetsInsetRect(bounds, self.edgeInsets);
    if(self.rightViewMode == UITextFieldViewModeAlways || self.rightViewMode == UITextFieldViewModeUnlessEditing) {
        return[self adjustRectWithWidthRightView:paddedRect];
    }
    return paddedRect;
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect paddedRect = UIEdgeInsetsInsetRect(bounds, self.edgeInsets);
    if(self.rightViewMode == UITextFieldViewModeAlways || self.rightViewMode == UITextFieldViewModeUnlessEditing) {
        return[self adjustRectWithWidthRightView:paddedRect];
    }
    return paddedRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
//    textRect.origin.x -= 10;
    textRect.origin.x += textRect.size.width - self.edgeInsets.right;
    return textRect;
////    return CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}


- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return true;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
