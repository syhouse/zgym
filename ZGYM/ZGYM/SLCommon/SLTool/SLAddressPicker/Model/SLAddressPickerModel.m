//
//  SLAddresssPickerModel.m
//  ZLProject
//
//  Created by blog.viicat.com on 2019/3/22.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import "SLAddressPickerModel.h"

//#import "ZLAddressRequest.h"

@interface SLAddressPickerModel()
//@property (nonatomic, strong) NSArray<SLAddressProvince *> *province;
//@property (nonatomic, strong) NSArray<SLAddressCity *> *city;
//@property (nonatomic, strong) NSArray<SLAddressDistrict *> *district;
//@property (nonatomic, strong) NSDictionary *dataSrouceOrigin;

@property (nonatomic, strong) NSArray<SLAddressProvince *> *address;    /**<全部数据*/

@property (nonatomic, copy) SLAddressLoadCompleteBlock completionHandler;
@end

@implementation SLAddressPickerModel
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static SLAddressPickerModel *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[SLAddressPickerModel alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self reqeustData];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:nil];
        NSString *contentDetail = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[contentDetail dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [self process:dic];
        
//        let path = Bundle.main.path(forResource: "address", ofType: nil) ?? ""
//        let strAddress = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
//        let dataAddress = strAddress?.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
//        let json = try? JSON(data: dataAddress)
    }
    return self;
}

//- (void)reload {
//    [self reqeustData];
//}
//
//- (void)reqeustData {
////    __weak typeof(self) weakSelf = self;
////    [[ZLURLManager manager] sendRequest:[[ZLAddressRequest alloc] initWithAllArea] complete:^(ZLResponse * _Nullable response) {
////        if (response.status == ZLResponseStatusSuccess) {
////            [weakSelf process:response.content];
////            self.isLoadComplete = YES;
////            if (weakSelf.completionHandler) {
////                weakSelf.completionHandler();
////            }
////        } else {
////            self.isLoadComplete = NO;
////        }
////    }];
//}
//
//- (void)loadDataCompletionHandler:(SLAddressLoadCompleteBlock)completionHandler {
//    self.completionHandler = completionHandler;
//}

- (void)process:(NSDictionary *)dataSrouce {
    /// 省
    NSDictionary *dicProvince = dataSrouce[@"100000"];
    NSArray<NSString *> *provinceOrigin = dicProvince.allKeys;
    NSMutableArray *multProvince = [[NSMutableArray alloc] init];
    [provinceOrigin enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SLAddressProvince *provinceModel = [[SLAddressProvince alloc] init];
        provinceModel.code = obj;
        provinceModel.name = dicProvince[obj];
        
        /// 市
        NSDictionary *dicCitys = dataSrouce[obj];
        NSArray<NSString *> *cityOrigin = dicCitys.allKeys;
        NSMutableArray *multCity = [[NSMutableArray alloc] init];
        [cityOrigin enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SLAddressCity *cityModel = [[SLAddressCity alloc] init];
            cityModel.code = obj;
            cityModel.name = dicCitys[obj];
            
            /// 区
            NSDictionary *dicDistrict = dataSrouce[obj];
            NSArray<NSString *> *arrDistrict = dicDistrict.allKeys;
            NSMutableArray *multDistrict = [[NSMutableArray alloc] init];
            [arrDistrict enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SLAddressDistrict *districtModel = [[SLAddressDistrict alloc] init];
                districtModel.code = obj;
                districtModel.name = dicDistrict[obj];
                
                [multDistrict addObject:districtModel];
            }];
            cityModel.districts = [multDistrict copy];
            [multCity addObject:cityModel];
            
        }];
        provinceModel.citys = [multCity copy];
        [multProvince addObject:provinceModel];
    }];
    self.address = [multProvince copy];

//    self.province = self.address;
//    self.city = self.address.firstObject.citys;
//    self.district = self.address.firstObject.citys.firstObject.disricts;
}

#pragma mark - Other
//- (NSDictionary *)spliteKey:(NSString *)strKey {
//    NSArray *arr = [strKey componentsSeparatedByString:@"-"];
//    NSMutableDictionary *multDic = nil;
//    if (arr.count == 2) {
//        multDic = [[NSMutableDictionary alloc] init];
//        [multDic setValue:arr.firstObject forKey:@"name"];
//        [multDic setValue:arr.lastObject forKey:@"code"];
//    }
//    return multDic;
//}

@end

@implementation SLAddressProvince
@end

@implementation SLAddressCity
@end

@implementation SLAddressDistrict
@end
