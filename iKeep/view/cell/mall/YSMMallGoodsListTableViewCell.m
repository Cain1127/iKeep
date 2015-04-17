//
//  YSMMallGoodsListTableViewCell.m
//  iKeep
//
//  Created by ysmeng on 14/11/4.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMallGoodsListTableViewCell.h"
#import "YSMBlockActionButton.h"
#import "YSMMallGoodsListDataModel.h"

#import <objc/runtime.h>

//运行时关联key
static char ImageViewKey;
static char TitleLabelKey;
static char PriceLabelKey;
static char FastPostFeeKey;
static char PayCountKey;
static char SellerLocationKey;
static char MobileDiscountRootViewKey;
static char MobileDiscountLabelKey;
static char StoreNameKey;
static char DesScoreKey;
static char CommentCountKey;
@implementation YSMMallGoodsListTableViewCell

//**************************************
//      初始化/UI搭建
//**************************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建UI
        [self createMallGoodInfoCellUI];
    }
    
    return self;
}

//创建UI
- (void)createMallGoodInfoCellUI
{
    //底view
    UIView *rootView = [[UIView alloc]
            initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 75.0f)];
    [self.contentView addSubview:rootView];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 60.0f, 60.0f)];
    [rootView addSubview:imageView];
    objc_setAssociatedObject(self, &ImageViewKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 0.0f, 220.0f, 30.0f)];
    titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 2;
    [rootView addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //price label
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 30.0f, 60.0f, 15.0f)];
    priceLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [rootView addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceLabelKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //运费
    UILabel *fastPrice = [[UILabel alloc] initWithFrame:CGRectMake(135.0f, 30.0f, 60.0f, 15.0f)];
    fastPrice.font = [UIFont systemFontOfSize:12.0f];
    fastPrice.textColor = [UIColor lightGrayColor];
    fastPrice.textAlignment = NSTextAlignmentLeft;
    [rootView addSubview:fastPrice];
    objc_setAssociatedObject(self, &FastPostFeeKey, fastPrice, OBJC_ASSOCIATION_ASSIGN);
    
    //付款人数
    UILabel *payCount = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 45.0f, 80.0f, 15.0f)];
    payCount.font = [UIFont systemFontOfSize:12.0f];
    payCount.textColor = [UIColor lightGrayColor];
    payCount.textAlignment = NSTextAlignmentLeft;
    [rootView addSubview:payCount];
    objc_setAssociatedObject(self, &PayCountKey, payCount, OBJC_ASSOCIATION_ASSIGN);
    
    //发货地
    UILabel *sellerLoc = [[UILabel alloc] initWithFrame:CGRectMake(155.0f, 45.0f, 60.0f, 15.0f)];
    sellerLoc.font = [UIFont systemFontOfSize:12.0f];
    sellerLoc.textColor = [UIColor lightGrayColor];
    sellerLoc.textAlignment = NSTextAlignmentRight;
    [rootView addSubview:sellerLoc];
    objc_setAssociatedObject(self, &SellerLocationKey, sellerLoc, OBJC_ASSOCIATION_ASSIGN);
    
    //手机端节省的钱
    UIView *mobileDisCountRootView = [[UIView alloc] initWithFrame:CGRectMake(70.0f, 60.0f, 80.0f, 15.0f)];
    mobileDisCountRootView.backgroundColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    [rootView addSubview:mobileDisCountRootView];
    objc_setAssociatedObject(self, &MobileDiscountRootViewKey, mobileDisCountRootView, OBJC_ASSOCIATION_ASSIGN);
    mobileDisCountRootView.hidden = YES;
    
    //mobile icon
    UIImageView *mobileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 2.5f, 7.0f, 10.0f)];
    mobileIcon.image = [UIImage imageNamed:IMAGE_MALL_DEFAULT_PHONE_ICON];
    [mobileDisCountRootView addSubview:mobileIcon];
    
    //discount label
    UILabel *discount = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 100.0f, 15.0f)];
    discount.font = [UIFont systemFontOfSize:12.0f];
    discount.textAlignment = NSTextAlignmentLeft;
    discount.textColor = [UIColor whiteColor];
    [mobileDisCountRootView addSubview:discount];
    objc_setAssociatedObject(self, &MobileDiscountLabelKey, discount, OBJC_ASSOCIATION_ASSIGN);
    
    //其他信息底view
    UIView *otherInfoView = [[UIView alloc] initWithFrame:CGRectMake(70.0f, 75.0f, 230.0f, 80.0f)];
    otherInfoView.alpha = 0.0f;
    otherInfoView.backgroundColor = [UIColor whiteColor];
    [rootView addSubview:otherInfoView];
    
    //其他信息按钮
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.imagesNormal = IMAGE_MALL_DEFAULT_MORE;
    buttonStyle.imagesHighted = IMAGE_MALL_DEFAULT_MORE_HIGH;
    UIButton *otherButton = [UIButton createYSMBlockActionButton:CGRectMake(255.0f, 55.0f, 25.0f, 25.0f) andTitle:nil andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        if (otherInfoView.frame.origin.y == 75.0f) {
            [UIView animateWithDuration:0.3 animations:^{
                otherInfoView.frame = CGRectMake(70.0f, 0.0f, 230.0f, 75.0f);
                otherInfoView.alpha = 1.0f;
            }];
        }
    }];
    [rootView addSubview:otherButton];
    [rootView bringSubviewToFront:otherInfoView];
    
    //其他信息页上的关闭按钮
    buttonStyle.imagesNormal = IMAGE_MALL_DEFAULT_CLOSE;
    buttonStyle.imagesHighted = IMAGE_MALL_DEFAULT_CLOSE_HIGH;
    UIButton *closeButton = [UIButton createYSMBlockActionButton:CGRectMake(200.0f, 55.0f, 20.0f, 20.0f) andTitle:nil andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        [UIView animateWithDuration:0.3 animations:^{
            otherInfoView.frame = CGRectMake(70.0f, 75.0f, 230.0f, 75.0f);
            otherInfoView.alpha = 0.0f;
        }];
    }];
    [otherInfoView addSubview:closeButton];
    
    //商家名字
    UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 220.0f, 20.0f)];
    storeName.font = [UIFont boldSystemFontOfSize:14.0f];
    storeName.textAlignment = NSTextAlignmentLeft;
    storeName.textColor = [UIColor lightGrayColor];
    [otherInfoView addSubview:storeName];
    objc_setAssociatedObject(self, &StoreNameKey, storeName, OBJC_ASSOCIATION_ASSIGN);
    
    //分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 29.0f, 230.0f, 2.0f)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];
    [otherInfoView addSubview:sepLabel];
    
    //描述相符
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 35.0f, 55.0f, 15.0f)];
    desLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    desLabel.textAlignment = NSTextAlignmentLeft;
    desLabel.textColor = [UIColor lightGrayColor];
    desLabel.text = @"描述相符";
    [otherInfoView addSubview:desLabel];
    
    //评分
    UILabel *desScore = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 35.0f, 40.0f, 15.0f)];
    desScore.font = [UIFont boldSystemFontOfSize:12.0f];
    desScore.textAlignment = NSTextAlignmentLeft;
    desScore.textColor = [UIColor redColor];
    [otherInfoView addSubview:desScore];
    objc_setAssociatedObject(self, &DesScoreKey, desScore, OBJC_ASSOCIATION_ASSIGN);
    
    //评分高/中/低：不做
    
    //评论
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 50.0f, 120.0f, 15.0f)];
    commentLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.textColor = [UIColor lightGrayColor];
    [otherInfoView addSubview:commentLabel];
    objc_setAssociatedObject(self, &CommentCountKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
}

//**************************************
//      根据数据模型刷新UI
//**************************************
#pragma mark - 根据数据模型刷新UI
- (void)updateMallListGoodUI:(YSMMallGoodsListDataModel *)model
{
    UIImageView *imageView = objc_getAssociatedObject(self, &ImageViewKey);
    imageView.image = model.image;
    
    UILabel *titeLabel = objc_getAssociatedObject(self, &TitleLabelKey);
    titeLabel.text = model.title;
    
    UILabel *priceLabel = objc_getAssociatedObject(self, &PriceLabelKey);
    priceLabel.text = model.price;
    
    UILabel *fastPost = objc_getAssociatedObject(self, &FastPostFeeKey);
    fastPost.text = model.fastPostFee;
    
    UILabel *payCount = objc_getAssociatedObject(self, &PayCountKey);
    payCount.text = model.buyedCount;
    
    UILabel *sellLoc = objc_getAssociatedObject(self, &SellerLocationKey);
    sellLoc.text = model.sellerLoc;
    
    if (model.mobileDiscount) {
        UIView *mobileDisCountRootView = objc_getAssociatedObject(self, &MobileDiscountRootViewKey);
        mobileDisCountRootView.hidden = NO;
        
        UILabel *mobileDiscount = objc_getAssociatedObject(self, &MobileDiscountLabelKey);
        mobileDiscount.text = model.mobileDiscount;
    }
    
    UILabel *desScore = objc_getAssociatedObject(self, &DesScoreKey);
    desScore.text = model.desScore;
    
    UILabel *comm = objc_getAssociatedObject(self, &CommentCountKey);
    comm.text = model.commentCount;
    
    UILabel *storeName = objc_getAssociatedObject(self, &StoreNameKey);
    storeName.text = model.storeName;
}

@end
