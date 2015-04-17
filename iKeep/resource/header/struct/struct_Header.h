//
//  struct_Header.h
//  iKeep
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#ifndef iKeep_struct_Header_h
#define iKeep_struct_Header_h

#if 0
typedef struct
{
    UIColor __unsafe_unretained *bgColor;
    UIColor __unsafe_unretained *titleNormalColor;
    UIColor __unsafe_unretained *titleHightedColor;
    UIColor __unsafe_unretained *titleSelectedColor;
    UIColor __unsafe_unretained *borderColor;
    float borderWith;
    float cornerRadio;
    NSString __unsafe_unretained *imagesNormal;
    NSString __unsafe_unretained *imagesHighted;
    NSString __unsafe_unretained *imagesSelected;
}BUTTON_STYLE_STRUCT;
#endif

typedef struct
{
    void *bgColor;
    void *titleNormalColor;
    void *titleHightedColor;
    void *titleSelectedColor;
    void *borderColor;
    float borderWith;
    float cornerRadio;
    void *imagesNormal;
    void *imagesHighted;
    void *imagesSelected;
}BUTTON_STYLE_STRUCT;

#endif
