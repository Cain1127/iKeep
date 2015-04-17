//
//  YSMButtonStyleDataModel.m
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMButtonStyleDataModel.h"

@implementation YSMButtonStyleDataModel

//**************************************
//          清空风格
//**************************************
#pragma mark - 清空风格
- (void)clearButtonStyle
{
     self.bgColor = nil;
     self.titleNormalColor = nil;
     self.titleHightedColor = nil;
     self.titleSelectedColor = nil;
     self.borderColor = nil;
     self.borderWith = 0.0f;
     self.cornerRadio = 0.0f;
     self.imagesNormal = nil;
     self.imagesHighted = nil;
     self.imagesSelected = nil;
     self.titleFont = nil;
     self.aboveImage = nil;
}

@end