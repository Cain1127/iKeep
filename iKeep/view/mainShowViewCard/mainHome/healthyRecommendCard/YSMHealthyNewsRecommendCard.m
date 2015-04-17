//
//  YSMHealthyNewsRecommendCard.m
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMHealthyNewsRecommendCard.h"
#import "YSMMainHandler.h"
#import "YSMHealthyRecommendCardDataModel.h"
#import "YSMBlockActionImageView.h"
#import "YSMMainHomeJieqiFoodRecommendViewController.h"
#import "UIImage+YSMImageCategory.h"

@interface YSMHealthyNewsRecommendCard (){
    NSMutableArray *_healthyFoodArray;//健康食谱相关信息数组
}

@property (nonatomic,strong) UIImageView *jiqiTopicView;
@property (nonatomic,strong) UIImageView *healthyFoodsView;

@end

@implementation YSMHealthyNewsRecommendCard

//***********************************
//      初始化
//***********************************
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //用户交互
        self.userInteractionEnabled = YES;
        
        //背景图片
//        self.image = [UIImage imageNamed:IMAGE_MAIN_HOME_HEALTHY_RECOMMEND_DEFAULT_BG];
        
        //创建UI
        BOOL UIFlag = [self createHealthyRecommendCardUI];
        
        //创建UI完成后，进行数据请求
        if (UIFlag) {
            [self requestHealthyRecommendData];
        }
    }
    
    return self;
}

- (BOOL)createHealthyRecommendCardUI
{
    //scrollview
    UIScrollView *bottomScrollView = [[UIScrollView alloc]
                                      initWithFrame:CGRectMake(0.0f, 0.0f,
                                self.frame.size.width, self.frame.size.height)];
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.showsVerticalScrollIndicator = NO;
    bottomScrollView.contentSize = CGSizeMake(bottomScrollView.frame.size.width, bottomScrollView.frame.size.height + 10.0f);
    [self addSubview:bottomScrollView];
    
    //299 x 140
    CGRect jiqiFrame = CGRectMake(5.0f, 0.0f, 130.0f, 140.0f);
    CGRect foodFrame = CGRectMake(5.0f, 155.0f, 130.0f, 140.0f);
    
    //初始化上下两个主题view
    self.jiqiTopicView = [UIImageView createYSMBlockActionImageView:jiqiFrame andCallBack:^{
        if (self.showRecommendVC) {
            YSMMainHomeJieqiFoodRecommendViewController *src =
            [[YSMMainHomeJieqiFoodRecommendViewController alloc] init];
            src.foodsType = JieqiHealthyFoodsRecommendType;
            self.showRecommendVC(src);
        }
    }];
    self.jiqiTopicView.userInteractionEnabled = YES;
    [bottomScrollView addSubview:self.jiqiTopicView];
    
    //创建节气美食view
    [self createJiqiTopicView:self.jiqiTopicView];
    
    self.healthyFoodsView = [UIImageView createYSMBlockActionImageView:foodFrame andCallBack:^{
        if (self.showRecommendVC) {
            YSMMainHomeJieqiFoodRecommendViewController *src =
            [[YSMMainHomeJieqiFoodRecommendViewController alloc] init];
            src.foodsType = HealthyFoodsRecommendType;
            [src loadJieqiFoodData:_healthyFoodArray];
            self.showRecommendVC(src);
        }
    }];
    self.healthyFoodsView.userInteractionEnabled = YES;
    [bottomScrollView addSubview:self.healthyFoodsView];
    [self createJiqiTopicView:self.healthyFoodsView];
    
    return YES;
}

//为每个主题view添加子视图
- (void)createJiqiTopicView:(UIImageView *)view
{
    //130 x 140
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 60.0f, 30.0f)];
    titleLabel.text = @"霜降节气";
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor orangeColor];
    [view addSubview:titleLabel];
    
    //分隔线
    UIImageView *sepView = [[UIImageView alloc] initWithFrame:CGRectMake(65.0f, 19.0f, 60.0f, 2.0f)];
    sepView.image = [UIImage imageNamed:IMAGE_MAIN_HOME_HEALTHY_RECOMMEND_SEP];
    [view addSubview:sepView];
    
    //topic view:100 90-45 120 (比例300 200)
    UIImageView *topicFirstView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 40.0f, 120.0f, 80.0f)];
    topicFirstView.userInteractionEnabled = YES;
    topicFirstView.image = [UIImage imageNamed:IMAGE_MAIN_HOME_HEALTHY_RECOMMEND_TOPIC_DEFAULT_BG];
    [view addSubview:topicFirstView];
    
    UIImageView *bgFirstAbove = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 80.0f)];
    bgFirstAbove.image = [UIImage imageNamed:IMAGE_MAIN_HOME_HEALTHY_RECOMMEND_TOPIC_DEFAULT_BG_AB];
    [topicFirstView addSubview:bgFirstAbove];
}

//**********************************
//      请求数据
//**********************************
#pragma mark - 请求数据
- (void)requestHealthyRecommendData
{
    //开启异步线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //申请主管理器进行数据请求
        YSMMainHandler *manager = [YSMMainHandler shareMainHandler];
        [manager requestData:RequestMainHomeHealthyRecommendData andAction:^(YSMMainHandleDataModel *result) {
            //请求失败
            if (!result.resultFlag) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (self.alertMessage) {
                        //返回主视图弹出说明信息
                        NSString *alertMessage =
                        [NSString stringWithFormat:@"健康推荐信息请求失败：%@",result.error];
                        if (self.alertMessage) {
                            self.alertMessage(alertMessage);
                        }
                    }
                });
                return;
            }
            
            //请求成功：更新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self updateHealthyRecommendView:result.result];
            });
        }];
    });
}

//***************************************
//      更新视图
//***************************************
#pragma mark - 更新视图
- (void)updateHealthyRecommendView:(NSArray *)dataSource
{
    NSArray *viewArray = @[self.jiqiTopicView,self.healthyFoodsView];
    for (int i = 0; i < 2; i++) {
        YSMHealthyRecommendCardDataModel *model
        = dataSource[i];
        UIView *view = viewArray[i];
        for (UIView *obj in [view subviews]) {
            //标题栏
            if ([obj isKindOfClass:[UILabel class]]) {
                ((UILabel *)obj).text = model.sceneTitle;
            }
            
            //图片栏
            if ([obj isKindOfClass:[UIImageView class]]) {
                CGFloat width = ((UIImageView *)obj).frame.size.width;
                if (width == 120.0f) {
                    ((UIImageView *)obj).image = model.sceneBGImage;
                    UIImageView *aboveView = [((UIImageView *)obj)subviews][0];
                    aboveView.image = model.sceneAboveImage;
                }
            }
        }
    }
    
#if 1
    //保存第二个主题美食信息
    if (nil == _healthyFoodArray) {
        _healthyFoodArray = [[NSMutableArray alloc] init];
    }
    [_healthyFoodArray removeAllObjects];
    YSMHealthyRecommendCardDataModel *model = dataSource[1];
    [_healthyFoodArray addObject:model.sceneBGImage];
    //300 x 200 = 124
    UIImage *tempImage = model.sceneAboveImage;
    tempImage = [tempImage getSubImage:CGRectMake(10.0f, 80.0f, 290.0f, 90.0f)];
    [_healthyFoodArray addObject:tempImage];
    [_healthyFoodArray addObject:model.des];
#endif
}

@end
