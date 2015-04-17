//
//  YSMAnimBlockActionScrollVIew.h
//  iKeep
//
//  Created by ysmeng on 14/11/3.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMAnimBlockActionScrollVIew : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(BLOCK_INT_ACTION)callBack;

- (void)setImages:(NSArray *)imagesArray;

@property (nonatomic,copy) BLOCK_INT_ACTION action;

@end
