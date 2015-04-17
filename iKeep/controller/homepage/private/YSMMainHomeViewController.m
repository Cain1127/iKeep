//
//  YSMMainHomeViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMainHomeViewController.h"
#import "YSMNavigationBarMainHomeMiddleItem.h"
#import "NSDate+YSMGetChineseDate.h"
#import "YSMMainHomePersonCard.h"
#import "YSMShareAboutCard.h"
#import "YSMHealthyNewsRecommendCard.h"
#import "YSMGoodsRecommendCard.h"
#import "YSMXMPPManager.h"
#import "YSMMainHomeJieqiFoodRecommendViewController.h"
#import "YSMHealthyViewController.h"

#import <objc/runtime.h>

//关联key
static char PersonPrivateInfoKey;
@interface YSMMainHomeViewController ()

@end

@implementation YSMMainHomeViewController

//*****************************************
//      view加载/UI搭建
//*****************************************
#pragma mark - view加载/UI搭建
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建UI
    [self createMainHomeUI];
    
    //绑定消息提醒
    [self addMessageTips];
}

- (void)createMainHomeUI
{
    //扩展scrollview
    if (!(IS_PHONE568)) {
        self.scrollView.contentSize =
        CGSizeMake(self.scrollView.frame.size.width,
        534.0f);
    }
    
    //navigation middle view
    __block YSMNavigationBarMainHomeMiddleItem *middleView =
    [[YSMNavigationBarMainHomeMiddleItem alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f)];
    [self createMainHomeMiddleViewData:^(NSArray *array){
        [middleView updateMiddleItem:array];
    }];
    [self setNavigationBarMiddleView:middleView];
    
    //个人主题信息页
    YSMMainHomePersonCard *personInfoCard = [[YSMMainHomePersonCard alloc]
                            initWithFrame:CGRectMake(5.0f, -15.0f,
                                    self.scrollView.frame.size.width-10.0f,
                                                     190.0f)];
    personInfoCard.alertMessageAction = ^(NSArray *array){
        if (array) {
            [self alertWrongMessage:nil andMessage:array[0]];
        }
    };
    [self.scrollView addSubview:personInfoCard];
    objc_setAssociatedObject(self, &PersonPrivateInfoKey, personInfoCard, OBJC_ASSOCIATION_ASSIGN);
    
    //分享说说页
    YSMShareAboutCard *shareAboutCard = [[YSMShareAboutCard alloc]
                                initWithFrame:CGRectMake(5.0f, 180.0f,
                                320.0 - 155.0f,
                                160.0f)];
    shareAboutCard.tapActionCallBack = ^(id obj){
        [self.navigationController pushViewController:obj animated:YES];
    };
    [self.scrollView addSubview:shareAboutCard];
    
    //商城页 294 - 160 134
    YSMGoodsRecommendCard *goodsCard =
    [[YSMGoodsRecommendCard alloc] initWithFrame:
     CGRectMake(5.0f, 345.0f, 320.0 - 155.0f, 134.0f)];
    [self.scrollView addSubview:goodsCard];
    
    //健康推荐504 200 304
    YSMHealthyNewsRecommendCard *healthyCard =
    [[YSMHealthyNewsRecommendCard alloc] initWithFrame:
     CGRectMake(320.0f - 145.0f, 180.0f, 140.0f, 299.0f)];
    healthyCard.alertMessage = ^(NSString *string){
        [self alertWrongMessage:nil andMessage:string];
    };
    healthyCard.showRecommendVC = ^(id src){
        [self.navigationController pushViewController:src animated:YES];
    };
    [self.scrollView addSubview:healthyCard];
}

- (void)createMainHomeMiddleViewData:(BLOCK_ARRAY_ACTION)callBack
{
    NSString *newDate = [NSDate getCurrentDateString];
    [newDate substringWithRange:NSMakeRange(4, 2)];
    NSString *newDateString = [NSString stringWithFormat:@"%@月%@日", [newDate substringWithRange:NSMakeRange(4, 2)],[newDate substringWithRange:NSMakeRange(6, 2)]];
    
    //农历信息
    NSDictionary *oldDateDict = [NSDate getChineseCalenderInfo];
    NSString *oldDateString = [NSString stringWithFormat:@"农历%@%@",
                               [oldDateDict valueForKey:YSMCHINESEDATE_KEY_MONTH],
                               [oldDateDict valueForKey:YSMCHINESEDATE_KEY_DATE]];
    NSArray *array = @[APP_NAME,oldDateString,newDateString];
    callBack(array);
}

- (void)addMessageTips
{
//    YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
    
}

//**************************************
//实时显示步数
//**************************************
#pragma mark - 实时显示步数


@end
