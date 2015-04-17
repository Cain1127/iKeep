//
//  YSMButtonStyleDataModel.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMButtonStyleDataModel : NSObject

/*
 UIColor *bgColor;
 UIColor *titleNormalColor;
 UIColor *titleHightedColor;
 UIColor *titleSelectedColor;
 UIColor *borderColor;
 CGFloat borderWith;
 CGFloat cornerRadio;
 NSString *imagesNormal;
 NSString *imagesHighted;
 NSString imagesSelected;
 */
@property (nonatomic,retain) UIColor *bgColor;
@property (nonatomic,retain) UIColor *titleNormalColor;
@property (nonatomic,retain) UIColor *titleHightedColor;
@property (nonatomic,retain) UIColor *titleSelectedColor;
@property (nonatomic,retain) UIColor *borderColor;
@property (nonatomic,assign)  CGFloat borderWith;
@property (nonatomic,assign) CGFloat cornerRadio;
@property (nonatomic,copy) NSString *imagesNormal;
@property (nonatomic,copy) NSString *imagesHighted;
@property (nonatomic,copy) NSString *imagesSelected;
@property (nonatomic,copy) UIFont *titleFont;
@property (nonatomic,copy) NSString *aboveImage;

//**************************************
//          清空风格
//**************************************
- (void)clearButtonStyle;

@end
