//
//  YSMMallGoodsListDataModel.h
//  iKeep
//
//  Created by ysmeng on 14/11/4.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMMallGoodsListDataModel : NSObject

@property (nonatomic,copy) NSString *goodsID;//商品ID
@property (nonatomic,copy) NSString *title;//商品标题
@property (nonatomic,copy) UIImage *image;//商品图片
@property (nonatomic,copy) NSString *buyedCount;//多少人付款
@property (nonatomic,copy) NSString *price;//商品价格
@property (nonatomic,copy) NSString *fastPostFee;//运费
@property (nonatomic,copy) NSString *sellerLoc;//卖家地址
@property (nonatomic,copy) NSString *mobileDiscount;//手机购买省的钱
@property (nonatomic,copy) NSString *storeName;//商店名
@property (nonatomic,copy) NSString *desScore;//评分
@property (nonatomic,copy) NSString *commentCount;//评价
@property (nonatomic,assign) GOODS_DESSCORE_LEVEL desScoreLevel;//评分等级

@end
