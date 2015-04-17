//
//  YSMMainHandler.m
//  iKeep
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMainHandler.h"
#import "YSMRequest.h"
#import "NSDate+YSMGetChineseDate.h"
#import "YSMHealthyRecommendCardDataModel.h"
#import "YSMHealthyNewsDataModel.h"
#import "YSMNewsDetailDataModel.h"
#import "YSMMallGoodsListDataModel.h"
#import "YSMHealthyFoodRecommendDataModel.h"

#import <CoreLocation/CoreLocation.h>

static YSMMainHandler *mainHandler = nil;

@interface YSMMainHandler () <CLLocationManagerDelegate>{
    int _page;//保存页码
    NSString *_newsID;//保存新闻ID
}

@property (nonatomic,strong) CLLocationManager *locationManager;//定位管理器
@property (nonatomic,copy) BLOCK_NSSTRING_ACTION locationSuccessAction;//定位成功时回调
@property (nonatomic,copy) BLOCK_NSSTRING_ACTION locationFailAction;//定位失败时回调

@end

@implementation YSMMainHandler

//**********************************
//          类方法
//**********************************
#pragma mark - 类方法
+ (YSMMainHandler *)shareMainHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainHandler = [[YSMMainHandler alloc] init];
    });
    
    return mainHandler;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

//**********************************
//          对象方法
//**********************************
#pragma mark - 定位当前位置
- (void)getCurrentCity:(BLOCK_NSSTRING_ACTION)successAction andFailCallBack:(BLOCK_NSSTRING_ACTION)failAction
{
    //关断定位功能是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        failAction(@"当前无法定位");
        return;
    }
    
    //如果可以定位：设置定位希望的清度，精确度越高，越耗电
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置当前变化后的距离为多少，修改位置信息
    self.locationManager.distanceFilter = 10;
    //请求的权限:iOS8后要求
    [_locationManager requestAlwaysAuthorization];
    //启动定位
    [self.locationManager startUpdatingLocation];
}

//授权定位
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"调用代理");
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
            break;
            
        default:
            
            break;
    }
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        NSLog(@"定位被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"无法获取位置信息");
    }
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //获取当前的位置
    //CLLocation表示位置
    CLLocation *loc = manager.location;
    //获取经伟度
//    CLLocationCoordinate2D point = loc.coordinate;
    NSLog(@"location is :%@",loc);
    
    //如果定位只需要一次，则停止定位服务
    [self.locationManager stopUpdatingLocation];
}

//**********************************
//          封装请求，并进行数据请求
//**********************************
#pragma mark - 外部可以直接访问的三种请求：类型、类型+page、类型+ID
- (void)requestData:(HANDLE_ACTION_TYPE)actionType andAction:(BLOCK_HANDLER_ACTION)action
{
    //过滤类型
    switch (actionType) {
        //广告页请求
        case RequestAvertMessage:
        {
            [self doRequest:advertMessageRequestType andCallBack:^(NSData *data, NSError *error) {
                __block YSMMainHandleDataModel *model = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                if (error) {
                    model.error = error;
                    action(model);
                } else {
                    [self analyzeAvertMessage:data andCallBack:^(NSString *str,CGFloat advertTime){
                        //判断成功或者失败
                        if (str) {
                            //保存广告时间
                            model.AdvertTime = advertTime;
                            
                            [self requestData:RequestAvertImage andPath:str andAction:^(YSMMainHandleDataModel *result) {
                                model.resultFlag = YES;
                                if (result.resultFlag) {
                                    model.result = result.result;
                                } else {
                                    UIImage *resultImage = [UIImage imageNamed:IMAGE_HUD_DEFAULT_BG];
                                    model.result = resultImage;
                                }
                                action(model);
                            }];
                        } else {
                            //失败时，返回一张默认的图片
                            UIImage *resultImage = [UIImage imageNamed:IMAGE_HUD_DEFAULT_BG];
                            model.resultFlag = YES;
                            model.result = resultImage;
                            action(model);
                        }
                    }];
                }
            }];
        }
            break;
            
        //个人主页头信息请求
        case RequestMainHomePersonCardData:
        {
            //首先取得定位信息
            
            //进行请求
            [self doRequest:mainHomePersonCardRequestType andCallBack:^(NSData *data, NSError *error) {
                //请求失败
                __block YSMMainHandleDataModel *model = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //请求成功
                [self analyzePersonHeaderInfo:data andCallBack:^(NSArray *array) {
                    if (array) {
                        model.resultFlag = YES;
                        model.result = array;
                        action(model);
                        return;
                    }
                    
                    //解析数据失败
                    NSError *aError = [self customDataAnalyzeFail];
                    model.error = aError;
                    action(model);
                }];
            }];
            
        }
            break;
            
        //健康推荐信息请求
        case RequestMainHomeHealthyRecommendData:
        {
            [self doRequest:mainHomeHealthyRecommendRequestType andCallBack:^(NSData *data, NSError *error) {
                __block YSMMainHandleDataModel *model
                = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                //请求失败
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //数据解析：失败/成功
                [self analyzeHealthyRecommendData:data andCallBack:^(NSArray *result) {
                    if (nil == result) {
                        //解析数据失败
                        NSError *aError = [self customDataAnalyzeFail];
                        model.error = aError;
                        action(model);
                        return;
                    }
                    
                    //解析数据成功
                    model.resultFlag = YES;
                    model.result = result;
                    action(model);
                }];
            }];
        }
            break;
            
        //推荐健康食品
        case RequestHealthyFoodRecommendData:
        {
            [self doRequest:healthyFoodRecommendDataRequestVegetableType andCallBack:^(NSData *data, NSError *error) {
                YSMMainHandleDataModel *model = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                //请求失败
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //解析数据
                [self ananlyzeHealthyFoodRecommendData:data andCallBack:^(NSDictionary *dict) {
                    //解析失败
                    if (dict == nil) {
                        NSError *aError = [self customDataAnalyzeFail];
                        model.error = aError;
                        action(model);
                        return;
                    }
                    
                    //解析成功
                    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
                    [resultArray addObject:dict];
                    
                    //请求第二阶段的数据
                    [self doRequest:healthyFoodRecommendDataRequestMeetType andCallBack:^(NSData *data, NSError *error) {
                        //荤菜推荐请求失败
                        if (error) {
                            model.result = resultArray;
                            model.resultFlag = YES;
                            action(model);
                            return;
                        }
                        
                        //请求成功-数据解析
                        [self ananlyzeHealthyFoodRecommendData:data andCallBack:^(NSDictionary *meetDict) {
                            //解析失败
                            if (nil == meetDict) {
                                model.result = resultArray;
                                model.resultFlag = YES;
                                action(model);
                                return;
                            }
                            
                            //解析成功
                            [resultArray addObject:meetDict];
                            model.resultFlag = YES;
                            model.result = resultArray;
                            action(model);
                        }];
                    }];
                }];
            }];
        }
            break;
            
        case RequestJieqiHealthyFoodRecommendData:
        {
            //jieqiHealthyFoodRecommendDataRequestType
            [self doRequest:jieqiHealthyFoodRecommendDataRequestType andCallBack:^(NSData *data, NSError *error) {
                YSMMainHandleDataModel *model = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                //请求失败
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //解析数据
                [self ananlyzeJieqiHealthyFoodRecommendData:data andCallBack:^(NSArray *ananlyzeArray) {
                    //解析失败
                    if (ananlyzeArray == nil) {
                        NSError *aError = [self customDataAnalyzeFail];
                        model.error = aError;
                        action(model);
                        return;
                    }
                    
                    //解析成功
                    model.result = ananlyzeArray;
                    model.resultFlag = YES;
                    action(model);
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}

//请求给定面码的数据
- (void)requestData:(HANDLE_ACTION_TYPE)actionType andPage:(int)page andAction:(BLOCK_HANDLER_ACTION)action
{
    switch (actionType) {
        case RequestHealthyNewsTextNewsListData:
        {
            [self doRequest:healthyNewsTextNewsListRequestType andPage:page andCallBack:^(NSData *data, NSError *error) {
                __block YSMMainHandleDataModel *model
                = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                //请求失败
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //数据解析：失败/成功
                [self analyzeHealthyNewsTextData:data andCallBack:^(NSArray *result) {
                    if (nil == result) {
                        //解析数据失败
                        NSError *aError = [self customDataAnalyzeFail];
                        model.error = aError;
                        action(model);
                        return;
                    }
                    
                    //解析数据成功
                    model.resultFlag = YES;
                    model.result = result;
                    action(model);
                }];
            }];
        }
            break;
            
        case RequestHealthyNewsMediaNewsListData:
        {
            [self doRequest:healthyNewsMediaNewsListRequestType andPage:page andCallBack:^(NSData *data, NSError *error) {
                __block YSMMainHandleDataModel *model
                = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                //请求失败
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //数据解析：失败/成功
                [self analyzeHealthyNewsMediaData:data andCallBack:^(NSArray *result) {
                    if (nil == result) {
                        //解析数据失败
                        NSError *aError = [self customDataAnalyzeFail];
                        model.error = aError;
                        action(model);
                        return;
                    }
                    
                    //解析数据成功
                    model.resultFlag = YES;
                    model.result = result;
                    action(model);
                }];
            }];
        }
            break;
        
        //书城数据请求
        case RequestMallListData:
        {
            [self doRequest:mallListDataRequestType andPage:page andCallBack:^(NSData *data, NSError *error) {
                YSMMainHandleDataModel *model
                = [[YSMMainHandleDataModel alloc] init];
                model.resultFlag = NO;
                //请求失败
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //数据解析：失败/成功
                [self analyzeMallData:data andCallBack:^(NSArray *array) {
                    //解析失败
                    if (nil == array) {
                        NSError *aError = [self customDataAnalyzeFail];
                        model.error = aError;
                        action(model);
                        return;
                    }
                    
                    //解析成功
                    model.result = array;
                    model.resultFlag = YES;
                    action(model);
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}

//根据给定的类型及ID请求数据
- (void)requestData:(HANDLE_ACTION_TYPE)actionType andID:(NSString *)objectID andAction:(BLOCK_HANDLER_ACTION)action
{
    switch (actionType) {
        case RequestNewsDetailData:
        {
            _newsID = [NSString stringWithString:objectID];
            YSMMainHandleDataModel *model
            = [[YSMMainHandleDataModel alloc] init];
            model.resultFlag = NO;
            [self doRequest:newsDetailDataRequestType andID:objectID andCallBack:^(NSData *data, NSError *error) {
                //请求失败
                if (error) {
                    model.error = error;
                    action(model);
                    return;
                }
                
                //数据解析
                [self analyzeNewsDetailData:data andCallBack:^(YSMNewsDetailDataModel *resultModel) {
                    //解析失败
                    if (nil == resultModel) {
                        NSError *aError = [self customDataAnalyzeFail];
                        model.error = aError;
                        action(model);
                        return;
                    }
                    
                    //解析成功
                    model.result = resultModel;
                    model.resultFlag = YES;
                    action(model);
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 根据给定的请求类型封装URL信息
//根据请求的类型及路径，将请求返回的处理变成data
- (void)requestData:(HANDLE_ACTION_TYPE)actionType andPath:(NSString *)path andAction:(BLOCK_HANDLER_ACTION)action
{
    switch (actionType) {
        case RequestAvertImage:
        {
            [self doRequest:advertImageRequestType andURL:[NSURL URLWithString:path] andCallBack:^(NSData *data, NSError *error) {
                YSMMainHandleDataModel *model = [[YSMMainHandleDataModel alloc] init];
                if (error) {
                    model.resultFlag = NO;
                    model.error = error;
                    action(model);
                } else {
                    model.resultFlag = YES;
                    UIImage *image = [UIImage imageWithData:data];
                    model.result = image;
                    action(model);
                }
            }];
        }
        
        default:
            break;
    }
}

//根据不同的请求类型，封装url
- (void)doRequest:(REQUEST_TYPE)requestType andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action
{
    switch (requestType) {
        case advertMessageRequestType:
        {
            NSURL *url = [NSURL URLWithString:URL_APP_LOAD_AVERT];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        case mainHomePersonCardRequestType:
            //URL_MAIN_HOME_PERSON_DEADER
        {
            NSURL *url = [NSURL URLWithString:URL_MAIN_HOME_PERSON_DEADER];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        case mainHomeHealthyRecommendRequestType:
        {
            //113.3472203510485 23.18150168334136 date
            NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                                   URL_MAIN_HOME_HEALTHYRECOMMEND_1,
                                   @"23.18150168334136",
                                   URL_MAIN_HOME_HEALTHYRECOMMEND_2,
                                   @"113.3472203510485",
                                   URL_MAIN_HOME_HEALTHYRECOMMEND_3,
                                   [NSDate getCurrentDateString],
                                   URL_MAIN_HOME_HEALTHYRECOMMEND_4];
            NSURL *url = [NSURL URLWithString:urlString];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        case jieqiHealthyFoodRecommendDataRequestType:
        {
            NSURL *url = [NSURL URLWithString:URL_HEALTHY_FOOD_JIEQI_RECOMMEND];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        case healthyFoodRecommendDataRequestVegetableType:
        {
            //先请求素菜数据
            NSURL *url = [NSURL URLWithString:URL_HEALTHY_FOOD_RECOMMEND_VEGETABLE];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        case healthyFoodRecommendDataRequestMeetType:
        {
            //再请求荤菜
            NSURL *url = [NSURL URLWithString:URL_HEALTHY_FOOD_RECOMMEND_MEET];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        default:
            break;
    }
}

//根据不同的请求类型及所需页，封装url
- (void)doRequest:(REQUEST_TYPE)requestType andPage:(int)page andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action
{
    switch (requestType) {
        case healthyNewsTextNewsListRequestType:
        {
            //0 20 40
            //保存page
            _page = page;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_HEALTHY_NEWS,20 * (page - 1)]];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        case healthyNewsMediaNewsListRequestType:
        {
            //保存pag
            _page = page;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_HEALTHY_NEWS_MEDIA,10 * (page - 1)]];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        case mallListDataRequestType:
        {
            NSString *urlString = [NSString stringWithFormat:@"%@%@%@%d%@",URL_MALL_MAIN_LIST_1,@"书 健康",URL_MALL_MAIN_LIST_2,page,URL_MALL_MAIN_LIST_3];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlString];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        default:
            break;
    }
}

//根据不同的请求类型及所需页，封装url
- (void)doRequest:(REQUEST_TYPE)requestType andID:(NSString *)newsID andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action
{
    switch (requestType) {
        case newsDetailDataRequestType:
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_HEALTHY_NEWS_DETAIL,newsID]];
            [self doRequest:requestType andURL:url andCallBack:action];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 根据给定的类型/URL封闭请求tag
//根据给定的请求类型及url，加载请求tag
- (void)doRequest:(REQUEST_TYPE)requestType andURL:(NSURL *)url andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action
{
    switch (requestType) {
        case advertImageRequestType:
            [self doRequest:requestType
                               andURL:url
                               andTag:REQUEST_TAG_ADVERT_IMAGE
                          andCallBack:action];
            break;
            
        case advertMessageRequestType:
        {
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_ADVERT_MESSAGE
                andCallBack:action];
        }
            break;
            
        case mainHomePersonCardRequestType:
        {
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_MAINHOME_HEADER
                andCallBack:action];
        }
            break;
            
        case mainHomeHealthyRecommendRequestType:
        {
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_MAINHOME_HEALTHYRECOMMEND
                andCallBack:action];
        }
            break;
            
        case healthyNewsTextNewsListRequestType:
        {
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_HEALTHYNEWS_TEXTNEWS
                andCallBack:action];
        }
            break;
            
        case healthyNewsMediaNewsListRequestType:
        {
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_HEALTHYNEWS_MEDIANEWS
                andCallBack:action];
        }
            break;
            
        case newsDetailDataRequestType:
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_NEWS_DETAIL
                andCallBack:action];
            break;
            
        case mallListDataRequestType:
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_MALL_LIST
                andCallBack:action];
            break;
            
        case jieqiHealthyFoodRecommendDataRequestType:
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_HEALTHY_RECOMMEND_JIEQI
                andCallBack:action];
            break;
            
        case healthyFoodRecommendDataRequestVegetableType:
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_HEALTHY_RECOMMEND_VEGETABLE
                andCallBack:action];
            break;
            
        case healthyFoodRecommendDataRequestMeetType:
            [self doRequest:requestType
                     andURL:url
                     andTag:REQUEST_TAG_HEALTHY_RECOMMEND_MEET
                andCallBack:action];
            break;
            
        default:
            break;
    }
}

- (void)doRequest:(REQUEST_TYPE)requestType andURL:(NSURL *)url andTag:(NSInteger)tag andCallBack:(BLOCK_REQUEST_CALLBACK_ACTION)action
{
    [YSMRequest doSyncRequest:requestType
                       andURL:url
                       andTag:tag
                  andCallBack:action];
}

/////////////////////////////////////////////////////////////////
//
//                 数据分析及解析
//
/////////////////////////////////////////////////////////////////
#pragma mark - 数据解析
//广告信息数据解析
- (void)analyzeAvertMessage:(NSData *)data andCallBack:(BLOCK_AVERT_MESSAGE_ANALYZE_ACTION)action
{
#if 0
    //解码data
    NSStringEncoding enc =  CFStringConvertEncodingToNSStringEncoding  (kCFStringEncodingGB_18030_2000);
    NSString * myResponseStr = [[NSString alloc]  initWithData:data encoding:enc];
    NSData *resultData = [myResponseStr dataUsingEncoding:NSUTF8StringEncoding];
#endif
    //转为json
    NSDictionary *resultRootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (resultRootDict) {
        NSArray *advertArray = [resultRootDict valueForKey:REQUEST_KEY_ADVERT_ARRAY];
        NSDictionary *advertDict = advertArray[0];
        CGFloat adverTime = [[advertDict valueForKey:REQUEST_KEY_ADVERT_TIME] floatValue];
        
        NSArray *imageArray = [advertDict valueForKey:REQUES_KEY_AVERT_IMAGESARRAY];
        NSString *advertURLString = imageArray[0];
        
        action(advertURLString,adverTime);
    } else {
        action(nil,0);
    }
}

//个人头信息请求
- (void)analyzePersonHeaderInfo:(NSData *)data andCallBack:(BLOCK_ARRAY_ACTION)callBack
{
    NSDictionary *dictOriginal = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (!dictOriginal) {
        callBack(nil);
        return;
    }
    
    //解析
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setObject:[dictOriginal valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_CITY]
                   forKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_CITY];
    [resultDict setObject:[dictOriginal valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY] forKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY];
    [resultDict setObject:[dictOriginal valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TOMORROW] forKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TOMORROW];
    //宜忌解析
    NSDictionary *yijiDict = [dictOriginal valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_YIJI];
    //今日宜数据
    NSArray *yi_Array = [yijiDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_YI];
    NSMutableString *yi_string = [[NSMutableString alloc] init];
    for (int i = 0;i < [yi_Array count];i++) {
        NSDictionary *yi_dict = yi_Array[i];
        [yi_string appendString:
        [yi_dict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_YIJI_TITLE]];
        if (i+1 != [yi_Array count]) {
            [yi_string appendString:@";"];
        }
    }
    [resultDict setObject:yi_string forKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY_YI];
    //今日忌数据
    NSArray *ji_Array = [yijiDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_JI];
    NSMutableString *ji_string = [[NSMutableString alloc] init];
    for (int i = 0;i < [ji_Array count];i++) {
        NSDictionary *ji_dict = ji_Array[i];
        [ji_string appendString:
         [ji_dict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_YIJI_TITLE]];
        if (i+1 != [ji_Array count]) {
            [ji_string appendString:@";"];
        }
    }
    [resultDict setObject:ji_string forKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY_JI];
    
    //回调
    NSArray *resultArray = [NSArray arrayWithObject:resultDict];
    callBack(resultArray);
}

//推荐的健康信息数据解析
- (void)analyzeHealthyRecommendData:(NSData *)data andCallBack:(BLOCK_ARRAY_ACTION)callBack
{
    //取得原始字典
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (nil == originalDict) {
        callBack(nil);
        return;
    }
    
    //主题字典
    NSDictionary *topicDict = [originalDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC];
    if (nil == topicDict) {
        callBack(nil);
        return;
    }
    
    //获取主题数组
    NSArray *topicArray = [topicDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC_ARRAY];
    if (nil == topicArray) {
        callBack(nil);
        return;
    }
    
    //取得主题信息
    NSDictionary *firstTopic;
    NSDictionary *secondTopic;
    if ([topicArray count] == 3) {
        firstTopic = topicArray[0];
        secondTopic = topicArray[2];
    } else if([topicArray count] == 2){
        firstTopic = topicArray[0];
        secondTopic = topicArray[1];
    } else if([topicArray count] < 1){
        callBack(nil);
        return;
    }
    
    NSArray *tempArray = @[firstTopic,secondTopic];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        //数据模型
        YSMHealthyRecommendCardDataModel *model =
        [[YSMHealthyRecommendCardDataModel alloc] init];
        
        NSDictionary *tempDict = tempArray[i];
        model.sceneTitle = [tempDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC_TITLE];
        
        //rows
        NSArray *sectionRows = [tempDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_TOPIC_ROWS];
        NSDictionary *sectionRowsDict = sectionRows[0];
        if (i == 0) {
            if ([sectionRows count] >= 2) {
                sectionRowsDict = sectionRows[1];
            }
        }
        
        NSArray *scenesArray = [sectionRowsDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENES];
        NSDictionary *sceneRowsDict = scenesArray[0];
        if (i == 0) {
            if ([scenesArray count] >= 2) {
                sceneRowsDict = scenesArray[1];
            }
        }
        
        model.sceneID = [sceneRowsDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENEID];
        model.sceneAboveImageURL = [sceneRowsDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENE_ABOVEIMAGEURL];
        model.sceneGBImageURL = [sceneRowsDict valueForKey:REQUEST_KEY_MAINHOME_HEALTHYRECOMMEND_SCENE_BGIMAGEURL];
        model.sceneAboveImage = [UIImage imageWithData:[
                                 NSData dataWithContentsOfURL:
                                [NSURL URLWithString:model.sceneAboveImageURL]]];
        model.sceneBGImage = [UIImage imageWithData:[
                                NSData dataWithContentsOfURL:
                            [NSURL URLWithString:model.sceneGBImageURL]]];
        model.des = [sceneRowsDict valueForKey:@"sceneDescription"];
        [resultArray addObject:model];
    }
    
    callBack(resultArray);
}

//健康新闻：文本新闻数据解析
- (void)analyzeHealthyNewsTextData:(NSData *)data andCallBack:(BLOCK_ARRAY_ACTION)callBack
{
    //原始字典
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (nil == originalDict) {
        callBack(nil);
        return;
    }
    
    //原始消息数组
    NSArray *originalArray = [originalDict valueForKey:@"T1414389941036"];
    if (nil == originalArray) {
        callBack(nil);
        return;
    }
    
    //暂时保存消息数组
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    
    //解析数据
    for (int i = 0; i < [originalArray count]; i++) {
        //取得消息字典
        NSDictionary *tempDict = originalArray[i];
        YSMHealthyNewsDataModel *model = [[YSMHealthyNewsDataModel alloc] init];
        
        //第一个健康信息是头条
        if (i == 0 && _page == 1) {
            model.modelType = TextHealthyHeaderNews;
            model.newsID = [tempDict valueForKey:@"docid"];
            model.title = [tempDict valueForKey:@"title"];
            model.detail = [tempDict valueForKey:@"digest"];
            NSURL *tempURL = [NSURL URLWithString:[tempDict valueForKey:@"imgsrc"]];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:tempURL]];
            model.headerImage = image;
            
            [tempResultArray addObject:model];
            continue;
        }
        
        //是否图片消息
        NSArray *imagesNews = [tempDict valueForKey:@"imgextra"];
        if (imagesNews) {
            model.modelType = ImageHealthyNews;
            model.newsID = [tempDict valueForKey:@"docid"];
            model.title = [tempDict valueForKey:@"title"];
            model.commentCount = [NSString stringWithFormat:@"%d跟帖",[[tempDict valueForKey:@"replyCount"] intValue]];
            NSURL *first_tempURL = [NSURL URLWithString:[tempDict valueForKey:@"imgsrc"]];
            UIImage *firstImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:first_tempURL]];
            NSMutableArray *tempImages = [[NSMutableArray alloc] init];
            [tempImages addObject:firstImage];
            for (NSDictionary *tempImagesDict in imagesNews) {
                NSURL *second_tempURL = [NSURL URLWithString:[tempImagesDict valueForKey:@"imgsrc"]];
                UIImage *tempImageObj = [UIImage imageWithData:[NSData dataWithContentsOfURL:second_tempURL]];
                [tempImages addObject:tempImageObj];
            }
            model.imagesArray = tempImages;
            
            [tempResultArray addObject:model];
            continue;
        }
        
        //普通消息
        model.modelType = TextHealthyNews;
        model.newsID = [tempDict valueForKey:@"docid"];
        model.title = [tempDict valueForKey:@"title"];
        model.commentCount = [NSString stringWithFormat:@"%d跟帖",[[tempDict valueForKey:@"replyCount"] intValue]];
        NSURL *tempURL = [NSURL URLWithString:[tempDict valueForKey:@"imgsrc"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:tempURL]];
        model.headerImage = image;
        model.detail = [tempDict valueForKey:@"digest"];
        [tempResultArray addObject:model];
    }
    
    NSArray *resultArray = [NSArray arrayWithArray:tempResultArray];
    callBack(resultArray);
}

//健康新闻：视屏新闻数据解析
- (void)analyzeHealthyNewsMediaData:(NSData *)data andCallBack:(BLOCK_ARRAY_ACTION)callBack
{
    //原始数据
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (nil == originalDict) {
        callBack(nil);
        return;
    }
    
    //取得数据
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    //取得视屏数组
    NSArray *originalArray = [originalDict valueForKey:@"00850FRB"];
    for (NSDictionary *obj in originalArray) {
        YSMHealthyNewsDataModel *model = [[YSMHealthyNewsDataModel alloc] init];
        model.modelType = MediaHealthyNews;
        model.newsID = [obj valueForKey:@"vid"];
        model.m3u8RUL = [NSURL URLWithString:[obj valueForKey:@"m3u8_url"]];
        model.headerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[obj valueForKey:@"cover"]]]];
        model.title = [obj valueForKey:@"sectiontitle"];
        model.subTitle = [obj valueForKey:@"title"];
        NSString *pDateString = [obj valueForKey:@"ptime"];
        model.updateTime = [NSString stringWithFormat:@"%@更新",[pDateString substringWithRange:NSMakeRange(5, 5)]];
        
        [resultsArray addObject:model];
    }
    
    NSArray *returnArray  = [NSArray arrayWithArray:resultsArray];
    callBack(returnArray);
}

- (void)analyzeNewsDetailData:(NSData *)data andCallBack:(BLOCK_NEWSDETAIL_ACTION)callBack
{
    //原始json
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (nil == originalDict) {
        callBack(nil);
        return;
    }
    
    //数据json
    NSDictionary *dataDict = [originalDict valueForKey:_newsID];
    if (nil == dataDict) {
        callBack(nil);
        return;
    }
    
    //解析数据
    YSMNewsDetailDataModel *model = [[YSMNewsDetailDataModel alloc] init];
    model.newsID = [dataDict valueForKey:@"docid"];
    model.commentMessage = [NSString stringWithFormat:@"%@跟帖", [[dataDict valueForKey:@"replyCount"] stringValue]];
    
    //请求回来的数据
    NSString *title = [dataDict valueForKey:@"title"];
    NSString *comeFrom = [dataDict valueForKey:@"source"];
    NSString *newsTime = [dataDict valueForKey:@"ptime"];
    NSString *pDate = [NSString stringWithFormat:@"%@ %@",[newsTime substringWithRange:NSMakeRange(5, 5)],[newsTime substringWithRange:NSMakeRange(11, 5)]];
    NSString *guideString = [dataDict valueForKey:@"digest"];
    NSString *body = [dataDict valueForKey:@"body"];
    NSMutableString *bodyString = [[NSMutableString alloc] initWithString:body];
    NSArray *originalImagesArray = [dataDict valueForKey:@"img"];
    
    //临时字符串
    NSMutableString *resultTempString = [[NSMutableString alloc] init];
    
    //封装为HTML数据
    NSString *titleHTML = [NSString stringWithFormat:@"<p style=\"color:black; text-align:center; font-size:16px;margin:20px;font-size:20px; font-weight:bold\">%@</p>",title];
    [resultTempString appendString:titleHTML];
    
    //235 235 235 = #ebebeb
    //如果有导语，则添加
    if (guideString && [guideString length] > 1) {
        NSString *guideHTML = [NSString stringWithFormat:@"<p style=\"background-color:#ebebeb; margin:10px\">%@</p>",guideString];
        [resultTempString appendString:guideHTML];
    }
    
    //判断是否有来源，有则添加
    //245 - #fa
    if (comeFrom) {
        NSString *sourceHTML = [NSString stringWithFormat:@"<p style=\"width:200px;height:15px;margin-left:10px;margin-top:5px;font-color:#fafafa ; font-size:12px\">%@      %@</p>",comeFrom,pDate];
        [resultTempString appendString:sourceHTML];
    } else if (pDate) {
        NSString *pDateHTML = [NSString stringWithFormat:@"<p style=\"width:80px;height:15px;margin-left:10px;margin-top:5px;font-color:#fafafa ; font-size:12px\">%@</p>",pDate];
        [resultTempString appendString:pDateHTML];
    }
    
    //查看是否有图片，有则添加
    if ([originalImagesArray count] >= 1) {
        for (NSDictionary *obj in originalImagesArray) {
            NSString *keyPoint = [obj valueForKey:@"ref"];
            NSString *sizeImage = [obj valueForKey:@"pixel"];
            NSArray *sizeArray = [sizeImage componentsSeparatedByString:@"*"];
            float width = [sizeArray[0] floatValue];
            float height = [sizeArray[1] floatValue];
            if (width > 300.0f) {
                CGFloat scaleFloat = 300.0f / width;
                width = 300.0f;
                height = scaleFloat * height;
            }
            if (height > 300.0f) {
                CGFloat scaleFloat = 300.0f / height;
                height = 300.0f;
                width = scaleFloat * width;
            }
            int setIntWidth = (int)width;
            int setIntHeight = (int)height;
            NSString *imageString = [NSString stringWithFormat:@"<p style=\"margin:10px\"><div align='center'><img style=\"width:%dpx;height:%dpx\" src='%@'></img></div></p>",setIntWidth,setIntHeight,[obj valueForKey:@"src"]];
            //替换
            [bodyString replaceCharactersInRange:[bodyString rangeOfString:keyPoint] withString:imageString];
        }
    }
    
    //修改body的风格
    NSRange tempRange = [bodyString rangeOfString:@"<p>"];
    do {
        [bodyString replaceCharactersInRange:tempRange withString:@"<p style=\"margin:10px;font-color:#f6f6f6; font-size:14px\">"];
        tempRange = [bodyString rangeOfString:@"<p>"];
    } while (tempRange.length >= 3);
    
    //添加新闻主体
    [resultTempString appendString:bodyString];
    
    
    NSString *resultString = [NSString stringWithString:resultTempString];
    model.details = resultString;
    callBack(model);
}

//书城数据解析
- (void)analyzeMallData:(NSData *)data andCallBack:(BLOCK_ARRAY_ACTION)callBack
{
    //初始数据
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (nil == originalDict) {
        callBack(nil);
        return;
    }
    
    //商品列表
    NSArray *goodsOriginalArray = [originalDict valueForKey:@"itemsArray"];
    if (nil == goodsOriginalArray) {
        callBack(nil);
        return;
    }
    
    //解析数据
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *obj in goodsOriginalArray) {
        YSMMallGoodsListDataModel *model = [[YSMMallGoodsListDataModel alloc] init];
        model.goodsID = [obj valueForKey:@"item_id"];
        model.title = [obj valueForKey:@"title"];
        model.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[obj valueForKey:@"pic_path"]]]];
        model.buyedCount = [NSString stringWithFormat:@"%@人付款",[obj valueForKey:@"sold"]];
        NSString *price = [obj valueForKey:@"price"];
        if ([price floatValue] <= 0.5) {
            model.price = @"免费";
        } else {
            model.price = [NSString stringWithFormat:@"￥%@",price];
        }
        NSString *fastPostFee = [obj valueForKey:@"fastPostFee"];
        if ([fastPostFee floatValue] <= 0.5) {
            model.fastPostFee = @"免运费";
        } else {
            model.fastPostFee = [NSString stringWithFormat:@"运费 ￥%@",fastPostFee];
        }
        NSString *sellerLoc = [obj valueForKey:@"sellerLoc"];
        if (sellerLoc) {
            model.sellerLoc = [sellerLoc substringWithRange:NSMakeRange([sellerLoc length] - 4,4)];
        }
        model.mobileDiscount = [obj valueForKey:@"mobileDiscount"];
        model.storeName = [obj valueForKey:@"nick"];
        model.desScore = [NSString stringWithFormat:@"%.2f", [[obj valueForKey:@"desScore"] floatValue]];
        CGFloat desScroeFloat = [[[obj valueForKey:@"desScore"] substringToIndex:4] floatValue];
        if (desScroeFloat >= 4.0f) {
            model.desScoreLevel = HighDesScore;
        } else if (desScroeFloat >= 3.0f){
            model.desScoreLevel = MiddleDesScore;
        } else {
            model.desScoreLevel = LowDesScore;
        }
        model.commentCount = [NSString stringWithFormat:@"%@条评论",[obj valueForKey:@"commentCount"]];
        
        //添加到数组中
        [resultArray addObject:model];
    }
    
    //回调
    callBack([NSArray arrayWithArray:resultArray]);
}

//推荐健康食材数据解析
- (void)ananlyzeJieqiHealthyFoodRecommendData:(NSData *)data andCallBack:(BLOCK_ARRAY_ACTION)callBack
{
    //取得原数据
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (nil == originalDict) {
        callBack(nil);
        return;
    }
    
    //解析数据
    NSMutableArray *resultTempArray = [[NSMutableArray alloc] init];
    
    //头图片
    UIImage *headerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[originalDict valueForKey:@"sceneImageUrl"]]]];
    [resultTempArray addObject:headerImage];
    
    //标题图片
    UIImage *titleImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[originalDict valueForKey:@"sceneTitleImageUrl"]]]];
    [resultTempArray addObject:titleImage];
    
    //说明信息
    NSString *dest = [originalDict valueForKey:@"sceneDesc"];
    [resultTempArray addObject:dest];
    
    //分享标题
    NSString *shareTitle = [originalDict valueForKey:@"sceneTitle"];
    [resultTempArray addObject:shareTitle];
    
    //他享内容
    NSString *shareAbout = [originalDict valueForKey:@"sceneShareContent"];
    [resultTempArray addObject:shareAbout];
    
    //推荐主题
    NSMutableArray *topicArray = [originalDict valueForKey:@"lists"];
    NSMutableArray *topicTempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in topicArray) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:[obj valueForKey:@"listTitle"] forKey:@"sectionTitle"];
        [tempDict setObject:[obj valueForKey:@"listId"] forKey:@"topicID"];
        
        NSArray *itemArray = [obj valueForKey:@"items"];
        NSMutableArray *tempItempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *itemDict in itemArray) {
            YSMHealthyFoodRecommendDataModel *model =
            [[YSMHealthyFoodRecommendDataModel alloc] init];
            model.name = [itemDict valueForKey:@"itemTitle"];
            model.detail = [itemDict valueForKey:@"itemDesc"];
            model.foodImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemDict valueForKey:@"imageUrl"]]]];
            
            //关键字
            NSArray *tagArray = [itemDict valueForKey:@"itemTags"];
            NSDictionary *tagDict = tagArray[0];
            model.foodType = [tagDict valueForKey:@"tagTitle"];
            model.foodTypeColor = [[tagDict valueForKey:@"tagColor"] intValue];
            
            [tempItempArray addObject:model];
        }
        
        [tempDict setObject:tempItempArray forKey:@"cellModel"];
        
        [topicTempArray addObject:tempDict];
    }
    [resultTempArray addObject:topicTempArray];
    
    //回调
    NSArray *resultArray = [NSArray arrayWithArray:resultTempArray];
    callBack(resultArray);
}

//推荐健康菜谱数据解析
- (void)ananlyzeHealthyFoodRecommendData:(NSData *)data andCallBack:(BLOCK_DICTIONARY_ACTION)callBack
{
    //初始字典
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (nil == originalDict) {
        callBack(nil);
        return;
    }
    
    //主题名字
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:[originalDict valueForKey:@"listTitle"] forKey:@"sectionTitle"];
    
    //主题中的推荐菜
    NSArray *itemsTempArray = [originalDict valueForKey:@"items"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in itemsTempArray) {
        YSMHealthyFoodRecommendDataModel *model = [[YSMHealthyFoodRecommendDataModel alloc] init];
        
        //图片
        UIImage *foodImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[obj valueForKey:@"imageUrl"]]]];
        model.foodImage = foodImage;
        
        //菜的名字
        model.name = [obj valueForKey:@"itemTitle"];
        
        //本菜是属于哪种类型
        NSArray *typeTempArray = [obj valueForKey:@"itemTags"];
        NSDictionary *tagDict = typeTempArray[0];
        model.foodType = [tagDict valueForKey:@"tagTitle"];
        model.foodTypeColor = [[tagDict valueForKey:@"tagColor"] intValue];
        
        [itemsArray addObject:model];
    }
    [tempDict setObject:itemsArray forKey:@"cellModel"];
    
    callBack(tempDict);
}

//**********************************
//      自定义NSError
//**********************************
#pragma mark - 解析数据失败：自定义Error
- (NSError *)customDataAnalyzeFail
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"解析数据失败"                                                                      forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:CUSTOM_ERROR_DOMAIN code:MHPersonHeaderInfoAnalyzeFail userInfo:userInfo];
    
    return aError;
}

@end