//
//  YXSAMapManager.h
//  ZLProject
//
//  Created by zgjy_mac on 2019/6/19.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 高德地图地位
typedef void(^ZLSearchPOICompletionBlock)(AMapPOISearchResponse *response, CLLocationCoordinate2D coordinate, NSError *error);
typedef void(^ZLSearchCityCoodinateBlock)(CLLocationCoordinate2D coordinate);
@interface YXSAMapManager : NSObject <AMapLocationManagerDelegate,AMapGeoFenceManagerDelegate,AMapSearchDelegate>
@property (nonatomic, weak) id<AMapLocationManagerDelegate> ssDelegate;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;
+ (instancetype)shareManager;
- (void)configured;

/// 单次定位
- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock;

/// 搜索周边
- (void)searchPOIKeyword:(NSString *)keyword completionHandler:(ZLSearchPOICompletionBlock)completionHandler;

/// 通过经纬搜索周边
- (void)searchPOICoordinate:(CLLocationCoordinate2D)coordinate
                    keyword:(NSString *)keyword
          completionHandler:(ZLSearchPOICompletionBlock)completionHandler;

/// 搜索城市 返回经纬
- (void)searchCityCoordinateKeyword:(NSString *)keyword completionHandler:(ZLSearchCityCoodinateBlock)completionHandler;
@end

NS_ASSUME_NONNULL_END
