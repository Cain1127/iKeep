//
//  YSMPersonInfoHealthyCard.m
//  iKeep
//
//  Created by ysmeng on 14/10/30.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMPersonInfoHealthyCard.h"

@interface YSMPersonInfoHealthyCard ()

@property (nonatomic,strong) UIImageView *walkIcon;//走路图标
@property (nonatomic,strong) UIImageView *caloriesIcon;//卡路里图标
@property (nonatomic,strong) UILabel *walkLabel;//走路文字
@property (nonatomic,strong) UILabel *caloriesLabel;//卡路里文字
@property (nonatomic,strong) UILabel *walkInfo;//走路的记录信息
@property (nonatomic,strong) UILabel *caloriesInfo;//卡路里记录信息

@end

@implementation YSMPersonInfoHealthyCard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:IMAGE_MAIN_HOME_HEALTHY_INFO];
        
        //创建UI
        [self createPersonInfoSportInfoUI];
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStepCount:) name:@"showStepCount" object:nil];
    }
    
    return self;
}

- (void)createPersonInfoSportInfoUI
{
    //140 x 100
    //走路图标
    self.walkIcon = [[UIImageView alloc]
                     initWithFrame:CGRectMake(5.0f, 5.0f, 40.0f, 40.0f)];
    self.walkIcon.image = [UIImage imageNamed:IMAGE_WALK_DEFAULT_ICON];
    [self addSubview:self.walkIcon];
    
    //卡路里图标
    self.caloriesIcon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(5.0f, 60.0f, 30.0f, 30.0f)];
    self.caloriesIcon.image = [UIImage imageNamed:IMAGE_CALURIES_DEFAULT_ICON];
    [self addSubview:self.caloriesIcon];
    
    //标签label
    self.walkLabel = [[UILabel alloc]
                      initWithFrame:CGRectMake(45.0f, 5.0f, 40.0f, 40.0f)];
    self.walkLabel.font = [UIFont systemFontOfSize:14.0f];
    self.walkLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:156.0f/255.0f blue:205.0f/255.0f alpha:0.8];
    self.walkLabel.text = @"步  行";
    [self addSubview:self.walkLabel];
    
    self.caloriesLabel = [[UILabel alloc]
                      initWithFrame:CGRectMake(45.0f, 55.0f, 45.0f, 40.0f)];
    self.caloriesLabel.font = [UIFont systemFontOfSize:14.0f];
    self.caloriesLabel.textColor = [UIColor redColor];
    self.caloriesLabel.text = @"卡路里";
    [self addSubview:self.caloriesLabel];
    
    //运行信息显示
    self.walkInfo = [[UILabel alloc]
                     initWithFrame:CGRectMake(90.0f, 5.0f, 65.0f, 40.0f)];
    self.walkInfo.font = [UIFont systemFontOfSize:14.0f];
    self.walkInfo.textColor = [UIColor colorWithRed:100.0f/255.0f green:156.0f/255.0f blue:205.0f/255.0f alpha:0.8];
    self.walkInfo.text = @"0 步";
    [self addSubview:self.walkInfo];
    
    self.caloriesInfo = [[UILabel alloc]
                     initWithFrame:CGRectMake(90.0f, 55.0f, 65.0f, 40.0f)];
    self.caloriesInfo.font = [UIFont systemFontOfSize:14.0f];
    self.caloriesInfo.textColor = [UIColor redColor];
    self.caloriesInfo.text = @"0 卡";
    [self addSubview:self.caloriesInfo];
    
}

//**************************************
//      显示当前步数
//**************************************
#pragma mark - 显示当前步数
- (void)showStepCount:(NSNotification *)stepInfo
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSArray *tempArray = [[stepInfo object] componentsSeparatedByString:@"#"];
        self.walkInfo.text = tempArray[0];
        self.caloriesInfo.text = tempArray[1];
    });
}

@end
