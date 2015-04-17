//
//  UIImage+YSMImageCategory.m
//  iKeep
//
//  Created by mac on 14-10-20.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "UIImage+YSMImageCategory.h"

@implementation UIImage (YSMImageCategory)

- (UIImage*)getSubImage:(CGRect)rect
{    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
