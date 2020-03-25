//
//  SLAddresssPickerModel.h
//  ZLProject
//
//  Created by blog.viicat.com on 2019/3/22.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SLAddressDistrict : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@end

@interface SLAddressCity : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray<SLAddressDistrict *> *districts;
@end

@interface SLAddressProvince : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray<SLAddressCity *> *citys;
@end

typedef void(^SLAddressLoadCompleteBlock)(void);

@interface SLAddressPickerModel : NSObject
+ (instancetype)shareInstance;
@property (nonatomic, strong, readonly) NSArray<SLAddressProvince *> *address; /**<全部数据*/

//@property (nonatomic, strong, readonly) NSArray<SLAddressProvince *> *province;
//@property (nonatomic, strong, readonly) NSArray<SLAddressCity *> *city;
//@property (nonatomic, strong, readonly) NSArray<SLAddressDistrict *> *district;

//@property (nonatomic, assign) BOOL isLoadComplete;

//- (void)loadDataCompletionHandler:(SLAddressLoadCompleteBlock)completionHandler;
//- (void)reload;
@end

NS_ASSUME_NONNULL_END
