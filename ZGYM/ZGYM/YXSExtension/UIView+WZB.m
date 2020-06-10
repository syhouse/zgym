//
//  UIView+WZB.m
//  WZBListView
//
//  Created by 孙航 on 16/6/13.
//  Copyright © 2016年 江苏银丰. All rights reserved.
//

#import "UIView+WZB.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define WZBTag 155158

@implementation UIView (WZB)
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns keyDatas:(NSArray *)keys valueDatas:(NSArray *)values isLevel:(BOOL)isLevel colorInfo:(NSDictionary *)colorInfo{
    [self wzb_drawListWithRect:rect line:line columns:columns keyDatas:keys valueDatas:values isLevel:isLevel colorInfo:colorInfo lineInfo:nil];
}

- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns keyDatas:(NSArray *)keys valueDatas:(NSArray *)values isLevel:(BOOL)isLevel colorInfo:(NSDictionary *)colorInfo lineInfo:(NSDictionary *)lineInfo {
    [self wzb_drawListWithRect:rect line:line columns:columns keyDatas:keys valueDatas:values isLevel:isLevel colorInfo:colorInfo lineInfo:lineInfo backgroundColorInfo:nil];
}

/**
 * 创建一个表格
 * line：列数
 * columns：行数
 * data：数据
 * colorInfo：颜色信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子文字将会变成红色
 * lineInfo：行信息，传入格式：@{@"0" : @"3"}意味着第一行创建3个格子
 * backgroundColorInfo：行信息，传入格式：@{@"0" : [UIColor redColor]}意味着第一个格子背景颜色变成红色
 */
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns keyDatas:(NSArray *)keys valueDatas:(NSArray *)values isLevel:(BOOL)isLevel colorInfo:(NSDictionary *)colorInfo lineInfo:(NSDictionary *)lineInfo backgroundColorInfo:(NSDictionary *)backgroundColorInfo {
    NSInteger index = 0;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat h = (1.0) * rect.size.height / line;
    NSInteger newLine = 0;
    for (NSInteger i = 0; i < line; i++) {
        
        // 判断合并单元格
        if (lineInfo) {
            for (NSInteger a = 0; a < lineInfo.allKeys.count; a++) {
                
                // 新的列数
                NSInteger newColumn = [lineInfo.allKeys[a] integerValue];
                if (i == newColumn) {
                    newLine = [lineInfo[lineInfo.allKeys[a]] integerValue];
                } else {
                    newLine = line;
                }
            }
        } else {
            newLine = line;
        }
        
        
        for (NSInteger j = 0; j < columns; j++) {
            
            // 线宽
            CGFloat w = (1.0) * rect.size.width / columns;
            CGRect frame = (CGRect){x + w * j, y + h * i, w, h};
            
            
            
            // 创建label
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            
            // 文字居中
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            
            // 判断文字颜色
//            UIColor *textColor = [colorInfo objectForKey:[NSString stringWithFormat:@"%zd", index]];
//            if (!textColor) {
//                textColor = [UIColor grayColor];
//            }
//            label.textColor = textColor;
           
            // 判断背景颜色
//            UIColor *backgroundColor = [backgroundColorInfo objectForKey:[NSString stringWithFormat:@"%zd", index]];
//            if (!backgroundColor) {
//                backgroundColor = [UIColor clearColor];
//            }
//            label.backgroundColor = backgroundColor;
            if (i % 2 == 0) {
                label.textColor = [UIColor grayColor];
                // label文字
                if (isLevel) {
                    NSInteger keyIndex = i / 2 * columns + j;
                    if (keys.count > keyIndex) {
                        label.text = keys[keyIndex];
                    }
                } else {
                    if (j == columns -1) {
                        //最后一列的数值
                        if (i == 0) {
                            label.text = keys.lastObject;
                        } else if (i == line / 2){
                            label.text = values.lastObject;
                        } else {
                            label.text = @"";
                        }
                        
                    } else {
                        NSInteger keyIndex = i / 2 * 3 + j;
                        if (keys.count > keyIndex) {
                            label.text = keys[keyIndex];
                        }
                    }
                }
                
                
               [label setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
            }else{
                // label文字
                if (isLevel) {
                    NSInteger valueIndex = i / 2 * columns + j;
                    if (values.count > valueIndex) {
                        label.text = values[valueIndex];
                    }
                } else {
                    if (j == columns -1) {
                        if (i == line / 2){
                            label.text = values.lastObject;
                        } else {
                            label.text = @"";
                        }
                    } else {
                        NSInteger valueIndex = i / 2 * 3 + j;
                        if (values.count > valueIndex) {
                            label.text = values[valueIndex];
                        }
                    }
                }
                
                label.textColor = [UIColor blackColor];
                [label setBackgroundColor:[UIColor whiteColor]];
            }
            // 字体大小
            label.font = [UIFont systemFontOfSize:16];
            
            if (isLevel) {
                [self wzb_drawRectWithRect:frame];
            } else {
                // 画线
                if (j < newLine - 1 || i == 0) {
                    [self wzb_drawRectWithRect:frame];
                } else {
                    if (i == 1) {
                        if (i == columns - 1) {
                            [self wzb_drawRectWithRect:frame];
                        } else {
                            [self wzb_drawRectWithRect:frame isHorizontalBottom:NO isHorizontalTop:YES];
                        }
                        
                    } else if (i == columns - 1) {
                        [self wzb_drawRectWithRect:frame isHorizontalBottom:YES isHorizontalTop:NO];
                    } else {
                        [self wzb_drawRectWithRect:frame isHorizontalBottom:NO isHorizontalTop:NO];
                    }
                    [label setBackgroundColor:[UIColor whiteColor]];
                    label.textColor = [UIColor blackColor];
                }
            }
            
        
            
            // label的tag值
            label.tag = WZBTag + index;
            index++;
        }
    }
}

- (void)wzb_drawRectWithRect:(CGRect)rect isHorizontalBottom:(BOOL)isHorizontalBottom isHorizontalTop:(BOOL)isHorizontalTop {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = (1.0) * rect.size.width;
    CGFloat h = (1.0) * rect.size.height;
    
    if (((int)(y * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        y += SINGLE_LINE_ADJUST_OFFSET;
    }
    if (((int)(x * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        x += SINGLE_LINE_ADJUST_OFFSET;
    }
    if (isHorizontalTop) {
        [self wzb_drawLineWithFrame:(CGRect){x, y, w, 1} type:1];
    }
    if (isHorizontalBottom) {
        [self wzb_drawLineWithFrame:(CGRect){x, y + h, w, 1} type:1];
    }
    [self wzb_drawLineWithFrame:(CGRect){x + w, y, 1, h} type:2];
    [self wzb_drawLineWithFrame:(CGRect){x, y, 1, h} type:2];
}

- (void)wzb_drawRectWithRect:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = (1.0) * rect.size.width;
    CGFloat h = (1.0) * rect.size.height;
    
    if (((int)(y * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        y += SINGLE_LINE_ADJUST_OFFSET;
    }
    if (((int)(x * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        x += SINGLE_LINE_ADJUST_OFFSET;
    }
    
    [self wzb_drawLineWithFrame:(CGRect){x, y, w, 1} type:1];
    [self wzb_drawLineWithFrame:(CGRect){x + w, y, 1, h} type:2];
    [self wzb_drawLineWithFrame:(CGRect){x, y + h, w, 1} type:1];
    [self wzb_drawLineWithFrame:(CGRect){x, y, 1, h} type:2];
}

- (void)wzb_drawLineWithFrame:(CGRect)frame lineType:(WZBLineType)lineType color:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    
    // 创建贝塞尔曲线
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    
    // 线宽
    linePath.lineWidth = lineWidth;
    
    // 起点
    [linePath moveToPoint:CGPointMake(0, 0)];
    
    // 重点：判断是水平方向还是垂直方向
    [linePath addLineToPoint: lineType == WZBLineHorizontal ? CGPointMake(frame.size.width, 0) : CGPointMake(0, frame.size.height)];
    
    // 创建CAShapeLayer
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    // 颜色
    lineLayer.strokeColor = color.CGColor;
    // 宽度
    lineLayer.lineWidth = lineWidth;
    
    // frame
    lineLayer.frame = frame;
    
    // 路径
    lineLayer.path = linePath.CGPath;
    
    // 添加到layer上
    [self.layer addSublayer:lineLayer];
}

- (void)wzb_drawLineWithFrame:(CGRect)frame type:(NSInteger)type color:(UIColor *)color {
    [self wzb_drawLineWithFrame:frame lineType:type color:color lineWidth:0.7];
}

- (void)wzb_drawLineWithFrame:(CGRect)frame type:(NSInteger)type {
    
    [self wzb_drawLineWithFrame:frame type:type color:[UIColor colorWithRed:196/255.0 green:205/255.0 blue:218/255.0 alpha:1]];
}

/**
 * 创建一个表格
 * line：列数
 * columns：行数
 * data：数据
 */
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns keyDatas:(NSArray *)keys valueDatas:(NSArray *)values isLevel:(BOOL)isLevel{
    [self wzb_drawListWithRect:rect line:line columns:columns keyDatas:keys valueDatas:values isLevel:isLevel colorInfo:nil];
}

/**
 * 创建一个表格
 * line：列数
 * columns：行数
 * data：数据
 * lineInfo：行信息，传入格式：@{@"0" : @"3"}意味着第一行创建3个格子
 */
- (void)wzb_drawListWithRect:(CGRect)rect line:(NSInteger)line columns:(NSInteger)columns keyDatas:(NSArray *)keys valueDatas:(NSArray *)values isLevel:(BOOL)isLevel lineInfo:(NSDictionary *)lineInfo {
    [self wzb_drawListWithRect:rect line:line columns:columns keyDatas:(NSArray *)keys valueDatas:(NSArray *)values isLevel:isLevel colorInfo:nil lineInfo:lineInfo];
}

// 根据tag拿到对应的label
- (UILabel *)getLabelWithIndex:(NSInteger)index {
    
    // 为了防止self的subviews又重复的tag，拿到第一个
    for (UIView *v in self.subviews) {
        
        // 判断是否为label类
        if ([v isKindOfClass:[UILabel class]]) {
            
            // 强制转换
            UILabel *label = (UILabel *)v;
            if (v.tag == index + WZBTag) {
                return label;
            }
        }
    }
    return [self viewWithTag:index + WZBTag];
}

@end






