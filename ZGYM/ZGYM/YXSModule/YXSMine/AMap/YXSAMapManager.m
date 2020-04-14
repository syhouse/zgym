//
//  YXSAMapManager.m
//  ZLProject
//
//  Created by zgjy_mac on 2019/6/19.
//  Copyright © 2019 智联技术. All rights reserved.
//

#import "YXSAMapManager.h"
@interface YXSAMapManager()
@property (nonatomic, copy)ZLSearchPOICompletionBlock searchPOIBlock;
@property (nonatomic, copy)ZLSearchCityCoodinateBlock searchCityCoordinateBlock;
@property (nonatomic, assign) CLLocationCoordinate2D tmpCoordinate;
@end

@implementation YXSAMapManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static YXSAMapManager *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[YXSAMapManager alloc] init];
    });
    return _instance;
}

- (void)configured {
    [AMapServices sharedServices].apiKey = @"6ccbb04f7817072692a89d5c456181c7";
    
    self.locationManager = [[AMapLocationManager alloc] init];
    if (self.ssDelegate) {
        self.locationManager.delegate = self.ssDelegate;
        
    } else {
        self.locationManager.delegate = self;
    }
    
    /// 设置定位最小更新距离
    self.locationManager.distanceFilter = 200;
    
    /// 推荐精度
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
//    /// 高精度
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    //   定位超时时间，最低2s，此处设置为10s
//    self.locationManager.locationTimeout =10;
//    //   逆地理请求超时时间，最低2s，此处设置为10s
//    self.locationManager.reGeocodeTimeout = 10;
    
//    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
//    self.geoFenceManager.delegate = self;
//    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
//    self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

#pragma mark -
- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock {
    return [self.locationManager requestLocationWithReGeocode:withReGeocode completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                completionBlock(location, regeocode, error);
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
        
        completionBlock(location, regeocode, error);
    }];
}

- (void)searchPOIKeyword:(NSString *)keyword completionHandler:(ZLSearchPOICompletionBlock)completionHandler {
    
    __weak typeof(self) weakSelf = self;
    [self requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (location && error == nil)
        {
            if (location) {
                weakSelf.tmpCoordinate = location.coordinate;
                [weakSelf searchPOICoordinate:location.coordinate keyword:keyword completionHandler:completionHandler];
            }
        } else {
            completionHandler(nil, CLLocationCoordinate2DMake(0, 0), error);
        }
    }];
}

- (void)searchPOICoordinate:(CLLocationCoordinate2D)coordinate keyword:(NSString *)keyword completionHandler:(ZLSearchPOICompletionBlock)completionHandler {
    self.tmpCoordinate = coordinate;
    self.searchPOIBlock = completionHandler;

    __weak typeof(self) weakSelf = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = keyword;
    request.requireExtension = YES;
    
    [weakSelf.search AMapPOIAroundSearch:request];
}

- (void)searchCityCoordinateKeyword:(NSString *)keyword completionHandler:(ZLSearchCityCoodinateBlock)completionHandler {
    self.searchCityCoordinateBlock = completionHandler;
    
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc] init];
    request.address = keyword;
    request.city = keyword;
    [self.search AMapGeocodeSearch:request];
}

//- (void)amapViewCoordinate:(CLLocationCoordinate2D)coordinate convertCompletionHanlder:(void)block {
//    /// 转换经纬
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc]init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    regeo.requireExtension = YES;
//    [self.search AMapReGoecodeSearch:regeo];
//}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
}

#pragma mark - AMapSearchDelegate
/* POI 搜索周边回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    } else {
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"Name:%@\n Type:%@", obj.name, obj.type);
        }];
        if (self.searchPOIBlock) {
            self.searchPOIBlock(response, self.tmpCoordinate, nil);
        }
    }
    
    //解析response获取POI信息，具体解析见 Demo
}

/* 沿途搜索回调. */
- (void)onRoutePOISearchDone:(AMapRoutePOISearchRequest *)request response:(AMapRoutePOISearchResponse *)response
{
    
    if (response.pois.count == 0)
    {
        return;
    } else {
        [response.pois enumerateObjectsUsingBlock:^(AMapRoutePOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"Name:%@\n", obj.name);
        }];
    }
    
    //解析response获取POI信息，具体解析见 Demo
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (response.geocodes.count == 0)
    {
        return;
        
    } else {
        if (self.searchCityCoordinateBlock) {
            NSArray<AMapGeocode *> *list = response.geocodes;
            AMapGeocode *geo = list.firstObject;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geo.location.latitude, geo.location.longitude);
            self.searchCityCoordinateBlock(coordinate);
        }
    }
}
@end
