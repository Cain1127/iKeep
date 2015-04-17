//
//  YSMHealthyViewController.m
//  iKeep
//
//  Created by ysmeng on 14/10/28.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMHealthyViewController.h"

#import <CoreMotion/CoreMotion.h>
#import <objc/runtime.h>

//关联key
static char HeaderImageKey;
static char WalkButtonKey;
static char CaluriaButtonKey;
static char CalulationLabelKey;

static char HeaderStepCounterKey;
static char HeaderCaluriaInfoKey;

static char TagStepCountLabelKey;
static char TagCaluriaLabelKey;
@interface YSMHealthyViewController (){
    NSInteger _stepCount;//记录步数
    NSString *_stepDistance;//步行距离
    
    NSLengthFormatter *_lengthFormatter;//运动距离格式器
}

@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) CMPedometer *pedometer;

@end

@implementation YSMHealthyViewController

//**************************************
//      初始化及UI搭建
//**************************************
#pragma mark - 初始化及UI搭建
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //开启运动线程;
        [self startPedemeter];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建UI
    [self createHealthyRecordUI];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSportData) name:@"showStepCount" object:nil];
}

//创建UI
- (void)createHealthyRecordUI
{
    //导航栏
    [self setNavigationBarMiddleTitle:@"今天步行"];
    
    //设置背景颜色
    self.mainShowView.backgroundColor = DEDEFAULT_FORWARDGROUND_COLOR;
    
    //步行或能耗背景view
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(60.0f, 10.0f, 200.0f, 200.0f)];
    [self.scrollView addSubview:infoView];
    //创建显示信息视图上的子视图
    [self createInfoSubviews:infoView];
    [self addTapGesture:infoView];
    objc_setAssociatedObject(self, &HeaderImageKey, infoView, OBJC_ASSOCIATION_ASSIGN);
    
    //步行或能耗的同量公式
    UIView *caculor = [[UIView alloc] initWithFrame:CGRectMake(60.0f, 220.0f, 200.0f, 44.0f)];
    [self.scrollView addSubview:caculor];
    [self createCaculationView:caculor];
    
    //步行标签视图
    UIButton *stepTag = [[UIButton alloc] initWithFrame:CGRectMake(40.0f, 274.0f, 90.0f, 90.0f)];
    [self.scrollView addSubview:stepTag];
    [stepTag setImage:[UIImage imageNamed:@"sport_tagview_step_default_bg"] forState:UIControlStateSelected];
    [self createStepTagView:stepTag];
    stepTag.selected = YES;
    [stepTag addTarget:self action:@selector(topicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, &WalkButtonKey, stepTag, OBJC_ASSOCIATION_ASSIGN);
    
    //能耗标签视图：createCaluriaTagView
    UIButton *caluriaTag = [[UIButton alloc] initWithFrame:CGRectMake(190.0f, 274.0f, 90.0f, 90.0f)];
    [self.scrollView addSubview:caluriaTag];
    [caluriaTag setImage:[UIImage imageNamed:@"sport_tagview_caluria_default_bg"] forState:UIControlStateSelected];
    [self createCaluriaTagView:caluriaTag];
    [caluriaTag addTarget:self action:@selector(topicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, &CaluriaButtonKey, caluriaTag, OBJC_ASSOCIATION_ASSIGN);
}

//显示图片信息
- (void)createInfoSubviews:(UIView *)view
{
    //步行view
    UIImageView *stepView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
    stepView.image = [UIImage imageNamed:@"sport_record_step_default_bg"];
    [view addSubview:stepView];
    [self createStepSubviews:stepView];
    
    //能耗view
    UIImageView *caruliaView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
    caruliaView.image = [UIImage imageNamed:@"sport_record_step_carulia_default_bg"];
    [view addSubview:caruliaView];
    [self createCaruliaSubviews:caruliaView];
    
    [view bringSubviewToFront:stepView];
}

//步行view
#pragma mark - 步行/能耗视图创建
- (void)createStepSubviews:(UIView *)view
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 45.0f, 80.0f, 30.0f)];
    title.text = @"步数";
    [view addSubview:title];
    title.font = [UIFont systemFontOfSize:18.0f];
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    //步数
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 85.0f, 120.0f, 30.0f)];
    stepLabel.text = @"0 步";
    [view addSubview:stepLabel];
    stepLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    stepLabel.textColor = [UIColor orangeColor];
    stepLabel.textAlignment = NSTextAlignmentCenter;
    objc_setAssociatedObject(self, &HeaderStepCounterKey, stepLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //目标
    UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 125.0f, 40.0f, 30.0f)];
    targetLabel.text = @"目标";
    [view addSubview:targetLabel];
    targetLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    targetLabel.textColor = [UIColor lightGrayColor];
    targetLabel.textAlignment = NSTextAlignmentCenter;
    
    //目标步数
    UILabel *targetStep = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 125.0f, 50.0f, 30.0f)];
    targetStep.text = @"2384";
    [view addSubview:targetStep];
    targetStep.font = [UIFont systemFontOfSize:18.0f];
    targetStep.textColor = [UIColor lightGrayColor];
    targetStep.textAlignment = NSTextAlignmentCenter;
}

//能耗view
- (void)createCaruliaSubviews:(UIView *)view
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 45.0f, 80.0f, 30.0f)];
    title.text = @"热量消耗";
    [view addSubview:title];
    title.font = [UIFont systemFontOfSize:18.0f];
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    //多少卡:2384 * 0.04 =
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 85.0f, 120.0f, 30.0f)];
    stepLabel.text = @"0.0 卡";
    [view addSubview:stepLabel];
    stepLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    stepLabel.textColor = [UIColor redColor];
    stepLabel.textAlignment = NSTextAlignmentCenter;
    objc_setAssociatedObject(self, &HeaderCaluriaInfoKey, stepLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //目标
    UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 125.0f, 40.0f, 30.0f)];
    targetLabel.text = @"目标";
    [view addSubview:targetLabel];
    targetLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    targetLabel.textColor = [UIColor lightGrayColor];
    targetLabel.textAlignment = NSTextAlignmentCenter;
    
    //目标卡路里
    UILabel *targetStep = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 125.0f, 50.0f, 30.0f)];
    targetStep.text = @"95.36";
    [view addSubview:targetStep];
    targetStep.font = [UIFont systemFontOfSize:18.0f];
    targetStep.textColor = [UIColor lightGrayColor];
    targetStep.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - 计算等量视图创建
- (void)createCaculationView:(UIView *)view
{
    UILabel *cacul = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 7.0f, view.frame.size.width - 20.0f * 2, 30.0f)];
    cacul.text = @"步行 0.0 公里";
    [view addSubview:cacul];
    cacul.textAlignment = NSTextAlignmentCenter;
    objc_setAssociatedObject(self, &CalulationLabelKey, cacul, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 标签视图创建
- (void)createStepTagView:(UIView *)view
{
    //小图标
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 15.0f, 30.0f, 30.0f)];
    [view addSubview:icon];
    icon.image = [UIImage imageNamed:@"walk_default_icon"];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 15.0f, 45.0f, 30.0f)];
    title.text = @"步行";
    title.font = [UIFont boldSystemFontOfSize:16.0f];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor lightGrayColor];
    [view addSubview:title];
    
    //说明
    UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 50.0f, 80.0f, 35.0f)];
    des.text = @"0 步";
    des.font = [UIFont boldSystemFontOfSize:22.0f];
    des.textAlignment = NSTextAlignmentCenter;
    des.textColor = [UIColor orangeColor];
    [view addSubview:des];
    objc_setAssociatedObject(self, &TagStepCountLabelKey, des, OBJC_ASSOCIATION_ASSIGN);
}

- (void)createCaluriaTagView:(UIView *)view
{
    //小图标
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 18.0f, 18.0f, 18.0f)];
    [view addSubview:icon];
    icon.image = [UIImage imageNamed:@"calorie_default_icon"];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 15.0f, 55.0f, 30.0f)];
    title.text = @"卡路里";
    title.font = [UIFont boldSystemFontOfSize:16.0f];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    title.textColor = [UIColor lightGrayColor];
    
    //说明
    UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 50.0f, 80.0f, 35.0f)];
    des.text = @"0 卡";
    des.font = [UIFont boldSystemFontOfSize:22.0f];
    des.textAlignment = NSTextAlignmentCenter;
    [view addSubview:des];
    des.textColor = [UIColor redColor];
    objc_setAssociatedObject(self, &TagCaluriaLabelKey, des, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 图片展示视图点击事件
- (void)addTapGesture:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

//单击手势
- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [self headerViewTapAction:view];
    [self resetButtonSelectedStyle];
}

//交换前后两个视图
- (void)headerViewTapAction:(UIView *)view
{
    [view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

#pragma mark - 两个主题按钮事件
- (void)topicButtonAction:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    //交换
    UIImageView *headerView = objc_getAssociatedObject(self, &HeaderImageKey);
    [self headerViewTapAction:headerView];
    
    //按钮状态修改
    [self resetButtonSelectedStyle];
}

//两个按钮换状态
- (void)resetButtonSelectedStyle
{
    //按钮状态修改
    UIButton *walk = objc_getAssociatedObject(self, &WalkButtonKey);
    UIButton *caluria = objc_getAssociatedObject(self, &CaluriaButtonKey);
    if (walk.selected) {
        walk.selected = NO;
    } else {
        walk.selected = YES;
        [self showCaculatorMessage:[NSString stringWithFormat:@"步行 %@ 公里",_stepDistance]];
    }
    if (caluria.selected) {
        caluria.selected = NO;
    } else {
        caluria.selected = YES;
        [self showCaculatorMessage:[NSString stringWithFormat:@"≈ %.2f 份炸鸡加啤酒",(_stepCount * 0.04f)/850.0f]];
    }
}

//计算显示文本
- (void)showCaculatorMessage:(NSString *)message
{
    UILabel *msg = objc_getAssociatedObject(self, &CalulationLabelKey);
    msg.text = message;
}

//设置个人信息UI
#pragma mark - 设置个人信息UI
- (void)loadFirstUseUI
{
    //175 67.5 65 220 550
    
}

//判断是否第一次进入健康中心
- (BOOL)checkisFirstUse
{
    //默认是第一次进入
    return YES;
}

//***************************************
//      开始记录步行数据
//***************************************
#pragma mark - 开始记录步行数据
- (void)startPedemeter
{
    self.pedometer = [[CMPedometer alloc] init];
    _lengthFormatter = [[NSLengthFormatter alloc] init];
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        if (error) {
            [self alertWrongMessage:nil andMessage:@"此设备不支持运行信息的记录"];
            return;
        }
        _stepCount = [pedometerData.numberOfSteps intValue];
        _stepDistance = [NSString stringWithFormat:@"%.2f", [[_lengthFormatter stringFromMeters:pedometerData.distance.doubleValue] floatValue] / (1000 * 1000)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showStepCount" object:[NSString stringWithFormat:@"%d 步#%@ 卡",[pedometerData.numberOfSteps intValue],[self getCaluria]]];
    }];
}

#pragma mark - 计算卡路里
- (NSString *)getCaluria
{
    //550 + 220 = 770/2 = 335
    return [NSString stringWithFormat:@"%.2f",_stepCount * 0.04f];
}

#pragma mark - 步数更新后同步更新UI
- (void)updateSportData
{
    //信息
    NSString *stepString = [NSString stringWithFormat:@"%ld 步",(long)_stepCount];
    NSString *caluriaString = [NSString stringWithFormat:@"%@ 卡", [self getCaluria]];
    
    //更新头信息
    UILabel *stepLabel = objc_getAssociatedObject(self, &HeaderStepCounterKey);
    stepLabel.text = stepString;
    
    UILabel *caluriaLabel = objc_getAssociatedObject(self, &HeaderCaluriaInfoKey);
    caluriaLabel.text = caluriaString;
    
    //更新标签按钮
    UILabel *tagStep = objc_getAssociatedObject(self, &TagStepCountLabelKey);
    UILabel *tagCaluria = objc_getAssociatedObject(self, &TagCaluriaLabelKey);
    tagStep.text = stepString;
    tagCaluria.text = caluriaString;
    
    //更新提醒信息
    UIButton *stepButton = objc_getAssociatedObject(self, &WalkButtonKey);
    UIButton *caluriaButton = objc_getAssociatedObject(self, &CaluriaButtonKey);
    if (stepButton.selected) {
        [self showCaculatorMessage:[NSString stringWithFormat:@"步行 %@ 公里",_stepDistance]];
    }
    if (caluriaButton.selected) {
        //850 /
        [self showCaculatorMessage:[NSString stringWithFormat:@"≈ %.2f 份炸鸡加啤酒",[caluriaString floatValue]/850.0f]];
    }
}

@end
