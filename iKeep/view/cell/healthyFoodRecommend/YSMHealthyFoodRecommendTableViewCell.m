//
//  YSMHealthyFoodRecommendTableViewCell.m
//  iKeep
//
//  Created by ysmeng on 14/11/8.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMHealthyFoodRecommendTableViewCell.h"

#import <objc/runtime.h>

//关联key
static char ImageViewKey;
static char TitleLabelKey;
static char TypeColorViewKey;
static char TypeLabelKey;
static char DescriptionKey;
@implementation YSMHealthyFoodRecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建UI
        [self createHealthyFoodRecommendUI];
    }
    
    return self;
}

- (void)createHealthyFoodRecommendUI
{
    //底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 60.0f)];
    [self.contentView addSubview:rootView];
    [self createSubviews:rootView];
}

- (void)createSubviews:(UIView *)view
{
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    imageView.image = [UIImage imageNamed:@"healthy_food_cell_default_image"];
    [view addSubview:imageView];
    objc_setAssociatedObject(self, &ImageViewKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 0.0f, 220.0f, 25.0f)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"黍米";
    [view addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //类型
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(70.0f, 30.0f, 60.0f, 20.0f)];
    typeView.backgroundColor = [UIColor greenColor];
    typeView.layer.cornerRadius = 6.0f;
    [view addSubview:typeView];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 20.0f)];
    typeLabel.text = @"气郁质";
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [typeView addSubview:typeLabel];
    objc_setAssociatedObject(self, &TypeLabelKey, typeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //描述
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 55.0f, 220.0f, 20.0f)];
    desLabel.font = [UIFont systemFontOfSize:14.0f];
    desLabel.textColor = [UIColor lightGrayColor];
    desLabel.numberOfLines = 0;
    desLabel.hidden = YES;
    [view addSubview:desLabel];
    objc_setAssociatedObject(self, &DescriptionKey, desLabel, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 根据数据模型更新UI
- (void)updateUIWithModel:(YSMHealthyFoodRecommendDataModel *)model
{
    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleLabelKey);
    titleLabel.text = model.name;
    
    UIView *foodTypeView = objc_getAssociatedObject(self, &TypeColorViewKey);
    if (model.foodTypeColor == 1) {
        foodTypeView.backgroundColor = [UIColor greenColor];
    } else {
        foodTypeView.backgroundColor = [UIColor orangeColor];
    }
    
    UILabel *foodType = objc_getAssociatedObject(self, &TypeLabelKey);
    foodType.text = model.foodType;
    
    UIImageView *imageView = objc_getAssociatedObject(self, &ImageViewKey);
    imageView.image = model.foodImage;
    
    //判断是否有说明信息
    if (model.detail) {
        UILabel *desLabel = objc_getAssociatedObject(self, &DescriptionKey);
        //重新计算高度
        NSDictionary *attribute = @{NSFontAttributeName:desLabel.font};
        CGSize labelSize = [model.detail boundingRectWithSize:CGSizeMake(220.0, 999.0) options:NSStringDrawingTruncatesLastVisibleLine |
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, desLabel.frame.size.width, labelSize.height);
        desLabel.text = model.detail;
        
        desLabel.hidden = NO;
    }
}

@end
