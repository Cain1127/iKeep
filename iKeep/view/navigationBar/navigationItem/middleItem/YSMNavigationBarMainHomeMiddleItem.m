//
//  YSMNavigationBarMainHomeMiddleItem.m
//  iKeep
//
//  Created by ysmeng on 14/10/29.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMNavigationBarMainHomeMiddleItem.h"

#import <objc/runtime.h>

//三个子控件的关联
static char TitleViewKey;
static char DateOldViewKey;
static char DateNewViewKey;
@implementation YSMNavigationBarMainHomeMiddleItem

//******************************
//      view的初始化及创建
//******************************
#pragma mark - view的初始化及创建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始创建UI
        [self createMainHomeMiddleItemUI];
    }
    
    return self;
}

- (void)createMainHomeMiddleItemUI
{
    //主标题label
    UILabel *titleLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(0.0f,
                                                    0.0f,
                                                    self.frame.size.width,
                                                    self.frame.size.height / 2.0f)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleViewKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    CGFloat gap = 15.0f;
    
    //农历日期label
    UILabel *oldDateLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(0.0f,
                                                    self.frame.size.height / 2.0f,
                                                    (self.frame.size.width-gap)/2.0f,
                                                    self.frame.size.height / 2.0f)];
    oldDateLabel.textAlignment = NSTextAlignmentRight;
    oldDateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    oldDateLabel.textColor = [UIColor whiteColor];
    [self addSubview:oldDateLabel];
    objc_setAssociatedObject(self, &DateOldViewKey, oldDateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //新历日期label
    UILabel *newDateLabel = [[UILabel alloc]
                initWithFrame:CGRectMake((self.frame.size.width-gap)/2.0f + gap,
                                          self.frame.size.height / 2.0f,
                                          (self.frame.size.width-gap)/2.0f,
                                          self.frame.size.height / 2.0f)];
    newDateLabel.textAlignment = NSTextAlignmentLeft;
    newDateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    newDateLabel.textColor = [UIColor whiteColor];
    [self addSubview:newDateLabel];
    objc_setAssociatedObject(self, &DateNewViewKey, newDateLabel, OBJC_ASSOCIATION_ASSIGN);
}

//******************************
//      数据源-更新UI
//******************************
#pragma mark - 数据源-更新UI
- (void)updateMiddleItem:(NSArray *)array
{
    if (array[0]) {
        UILabel *titleLabel = objc_getAssociatedObject(self, &TitleViewKey);
        titleLabel.text = array[0];
    }
    
    if (array[1]) {
        UILabel *oldDateLabel = objc_getAssociatedObject(self, &DateOldViewKey);
        oldDateLabel.text = array[1];
    }
    
    if (array[2]) {
        UILabel *newDateLabel = objc_getAssociatedObject(self, &DateNewViewKey);
        newDateLabel.text = array[2];
    }
}

@end
