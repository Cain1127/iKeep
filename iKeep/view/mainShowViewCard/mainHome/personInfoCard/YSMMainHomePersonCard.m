//
//  YSMMainHomePersonCard.m
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMainHomePersonCard.h"
#import "YSMPersonInfoHealthyCard.h"
#import "YSMPersonInfoTipsCard.h"
#import "YSMMainHandler.h"

@interface YSMMainHomePersonCard ()

@property (nonatomic,strong) UILabel *locationLabel;//当前位置label
@property (nonatomic,strong) UIImageView *todayWeatherImage;//当天天气图标
@property (nonatomic,strong) UILabel *todayWeatherLabel;//当天天气说明
@property (nonatomic,strong) UILabel *todayWeatherTemLabel;//当天气温
@property (nonatomic,strong) UIImageView *towWeatherImage;//明天天气图标
@property (nonatomic,strong) UILabel *towWeatherLabel;//明天天气说明
@property (nonatomic,strong) UILabel *towWeatherTemLabel;//明天气温
@property (nonatomic,strong) YSMPersonInfoTipsCard *tipsImageView;//当天健康提醒
@property (nonatomic,strong) YSMPersonInfoHealthyCard *healthyInfoView;//健康信息

@end

@implementation YSMMainHomePersonCard

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //开启用户交互
        self.userInteractionEnabled = YES;
        
        //设置透明度
//        self.alpha = 0.6f;
        
        //加载默认图片
        self.image = [UIImage imageNamed:IMAGE_MAIN_HOME_DEFAULT_HEADER];
        
        //创建UI
        BOOL IUFlag =  [self createMainHomePersonHeaderCardUI];
        
        //创建UI后才进行数据请求
        if (IUFlag) {
            [self startAsyDataRequest];
        }
    }
    return self;
}

- (BOOL)createMainHomePersonHeaderCardUI
{
    //name label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 55.0f, 20.0f)];
    [self addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"我在：";
    
    //当前位置label
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(67.0f, 15.0f, 40.0f, 20.0f)];
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.text = @"广州";
    self.locationLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.locationLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.locationLabel];
    
    //当天天气图标
    self.todayWeatherImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(15.0f, 50.0f, 40.0f, 40.0f)];
    self.todayWeatherImage.image = [UIImage imageNamed:IMAGE_WEATHER_SUN_DAY];
    [self addSubview:self.todayWeatherImage];
    
    //当天天气说明
    self.todayWeatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 55.0f, 30.0f, 15.0f)];
    self.todayWeatherLabel.text = @"晴";
    self.todayWeatherLabel.font = [UIFont systemFontOfSize:12.0f];
    self.todayWeatherLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.todayWeatherLabel];
    
    //当天温度
    self.todayWeatherTemLabel = [[UILabel alloc]
                                 initWithFrame:CGRectMake(60.0f, 70.0f, 70.0f, 15.0f)];
    self.todayWeatherTemLabel.font = [UIFont systemFontOfSize:12.0f];
    self.todayWeatherTemLabel.text = @"21℃ / 31℃";
    self.todayWeatherTemLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.todayWeatherTemLabel];
    
    //明天气图标
    self.towWeatherImage = [[UIImageView alloc]
                              initWithFrame:CGRectMake(15.0f, 95.0f, 40.0f, 40.0f)];
    self.towWeatherImage.image = [UIImage imageNamed:IMAGE_WEATHER_SUN_DAY];
    [self addSubview:self.towWeatherImage];
    
    //明天气说明
    self.towWeatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 100.0f, 50.0f, 15.0f)];
    self.towWeatherLabel.text = @"明天晴";
    self.towWeatherLabel.font = [UIFont systemFontOfSize:12.0f];
    self.towWeatherLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.towWeatherLabel];
    
    //明天温度
    self.towWeatherTemLabel = [[UILabel alloc]
                                 initWithFrame:CGRectMake(60.0f, 115.0f, 70.0f, 15.0f)];
    self.towWeatherTemLabel.font = [UIFont systemFontOfSize:12.0f];
    self.towWeatherTemLabel.text = @"21℃ / 31℃";
    self.towWeatherTemLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.towWeatherTemLabel];
    
    //运动信息
    self.healthyInfoView = [[YSMPersonInfoHealthyCard alloc]
                            initWithFrame:CGRectMake(self.frame.size.width - 180.0f,
                                                     15.0f, 160.0f, 100.0f)];
    [self addSubview:self.healthyInfoView];
    
    //健康提示
    self.tipsImageView = [[YSMPersonInfoTipsCard alloc]
                          initWithFrame:CGRectMake(15.0f, 140.0f,
                                                   self.frame.size.width - 30.0f,
                                                   40.0f)];
    [self addSubview:self.tipsImageView];
    
    return YES;
}

#pragma mark - 进行数据请求
- (void)startAsyDataRequest
{
#if 1
    //开启异步线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求当前位置
        [self getCurrentLocation:^(NSString *string) {
            //返回主线程更新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.locationLabel.text = string;
            });
        }];
        
        //数据请求
        [self getMainHomePersonCardData:^(YSMMainHandleDataModel *result) {
            //返回主线程更新数据
            
            //请求失败
            if (!result.resultFlag) {
                if (self.alertMessageAction) {
                    self.alertMessageAction(@[[NSString stringWithFormat:@"个人头信息请求失败：%@", result.error]]);
                }
                
                return;
            }
            
            //请求成功：返回主线程更新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self updateMainHomePersonCardUIWithData:result.result];
            });
        }];
    });
#endif
}

#pragma mark - 开始定位，并更新当前位置信息
- (void)getCurrentLocation:(BLOCK_NSSTRING_ACTION)callBack
{
    YSMMainHandler *mainHandler = [YSMMainHandler shareMainHandler];
    [mainHandler getCurrentCity:^(NSString *string) {
        callBack(string);
    } andFailCallBack:^(NSString *string) {
        callBack(LOCATION_DEFAULT_CITY);
    }];
}

#pragma mark - 业务数据请求
- (void)getMainHomePersonCardData:(BLOCK_HANDLER_ACTION)callBack
{
    //RequestMainHomePersonCardData
    YSMMainHandler *mainHandler = [YSMMainHandler shareMainHandler];
    [mainHandler requestData:RequestMainHomePersonCardData andAction:^(YSMMainHandleDataModel *result) {
        callBack(result);
    }];
}

#pragma mark - 根据请求返回的数据，更新UI
- (void)updateMainHomePersonCardUIWithData:(id)dataSource
{
    //头信息更新
    NSArray *dataArray = (NSArray *)dataSource;
    NSDictionary *dataDict = dataArray[0];
    
    //更新
    self.locationLabel.text = [dataDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_CITY];
    
    //当天天气
    NSDictionary *todayDict = [dataDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY];
    NSString *todayWeatherTitle = [todayDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_TITLE];
    [self setWeatherImage:self.todayWeatherImage andTitle:todayWeatherTitle];
    self.todayWeatherLabel.text = todayWeatherTitle;
    NSString *todayTem = [NSString stringWithFormat:TEMP_STRING_FORMAT,[todayDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_LOWTEM],[todayDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_HIGHTEM]];
    self.todayWeatherTemLabel.text = todayTem;
    
    //明天天气
    NSDictionary *tomorrowDict = [dataDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TOMORROW];
    NSString *tomorrowWeatherTitle = [tomorrowDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_TITLE];
    [self setWeatherImage:self.towWeatherImage andTitle:tomorrowWeatherTitle];
    self.towWeatherLabel.text = [NSString stringWithFormat:@"明天%@",tomorrowWeatherTitle];
    NSString *tomorrowTem = [NSString stringWithFormat:TEMP_STRING_FORMAT,[tomorrowDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_LOWTEM],[tomorrowDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_WEATHER_HIGHTEM]];
    self.towWeatherTemLabel.text = tomorrowTem;
    
    NSArray *tempArray = @[[dataDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY_YI],[dataDict valueForKey:REQUEST_KEY_MAINHOME_PERSONHEADER_DATAANALYZE_KEY_TODAY_JI]];
    [self.tipsImageView upateTipWithTips:tempArray];
}

- (void)setWeatherImage:(UIImageView *)view andTitle:(NSString *)title
{
    if ([title isEqualToString:@"雾"]) {
        view.image = [UIImage imageNamed:IMAGE_WEATHER_FOG_DAY];
    } else if([title isEqualToString:@"多云"]){
        view.image = [UIImage imageNamed:IMAGE_WEATHER_CLOUD_DAY];
    } else if([title isEqualToString:@"阴"]){
        view.image = [UIImage imageNamed:IMAGE_WEATHER_OVERCAST_DAY];
    } else if ([title isEqualToString:@"小雨"]){
        view.image = [UIImage imageNamed:IMAGE_WEATHER_SMALL_RAIN_DAY];
    }
}

//*************************************
//      显示步数
//*************************************
#pragma mark - 显示当前步数

@end
