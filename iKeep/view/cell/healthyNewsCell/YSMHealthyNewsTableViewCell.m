//
//  YSMHealthyNewsTableViewCell.m
//  iKeep
//
//  Created by ysmeng on 14/11/2.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMHealthyNewsTableViewCell.h"
#import "YSMAnimBlockActionScrollVIew.h"

#import <objc/runtime.h>

@interface YSMHealthyNewsTableViewCell ()

@property (nonatomic,copy) NSString *newsID;

@end

//关联key
static char TextNewsHeaderImageViewKey;
static char TextNewsHeaderTitleLabelKey;

static char TextNewsNormalImageViewKey;
static char TextNewsNormalTitleViewKey;
static char TextNewsNormalDetailViewKey;
static char TextNewsNormalCommentViewKey;

static char MediaNewsImageViewKey;
static char MediaNewsTitleKey;
static char MediaNewsSubTitleKey;
static char MediaNewsUpdateDateKey;

static char MediaNewsHeaderImageKey;

static char ImageNewsTitleKey;
static char ImageNewsCommentsKey;
static char ImageNewsImageKey;

@implementation YSMHealthyNewsTableViewCell

//********************************
//      初始化及UI搭建
//********************************
#pragma mark - 初始化及UI搭建
- (instancetype)initWithNewsType:(HEALTHY_NEWS_TYPE)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        //根据不同的类型进行不同的UI搭建
        switch (style) {
            case MediaHealthyNews:
                [self createMediaNewsCellUI];
                break;
                
            case TextHealthyNews:
                [self createTextNewsCellUI];
                break;
                
            case ImageHealthyNews:
                [self createImageNewsCellUI];
                break;
                
            case TextHealthyHeaderNews:
                [self createTextNewsHeaderCellUI];
                break;
                
            case MediaHealthyNewsHeader:
                [self createMediaNewsHeaderCellUI];
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

- (void)createTextNewsCellUI
{
    //210px × 154px = 70 x 51.3
    
    //根视图
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 70.0f)];
    [self.contentView addSubview:rootView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 70.0f, 51.0f)];
    [rootView addSubview:imageView];
    objc_setAssociatedObject(self, &TextNewsNormalImageViewKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    
    //news title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 0.0f, 220.0f, 20.0f)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    objc_setAssociatedObject(self, &TextNewsNormalTitleViewKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    [rootView addSubview:titleLabel];
    
    //detail label
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 25.0f, 220.0f, 40.0f)];
    detailLabel.font = [UIFont systemFontOfSize:14.0f];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.numberOfLines = 2;
    [rootView addSubview:detailLabel];
    objc_setAssociatedObject(self, &TextNewsNormalDetailViewKey, detailLabel, OBJC_ASSOCIATION_ASSIGN);
    [rootView addSubview:titleLabel];
    
    //comment label
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0f, 55.0f, 60.0f, 15.0f)];
    commentLabel.font = [UIFont systemFontOfSize:12.0f];
    commentLabel.textAlignment = NSTextAlignmentRight;
    commentLabel.textColor = [UIColor lightGrayColor];
    [rootView addSubview:detailLabel];
    objc_setAssociatedObject(self, &TextNewsNormalCommentViewKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
    [rootView addSubview:commentLabel];
}

- (void)createMediaNewsHeaderCellUI
{
    //726px × 289px = 320 x 127.37
    YSMAnimBlockActionScrollVIew *imagesScrollView =
    [[YSMAnimBlockActionScrollVIew alloc]
    initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 127.37f) andCallBack:^(int num) {
        //将当前的视屏下标传出
        if (self.action) {
            self.action(num);
        }
    }];
    [self.contentView addSubview:imagesScrollView];
    objc_setAssociatedObject(self, &MediaNewsHeaderImageKey, imagesScrollView, OBJC_ASSOCIATION_ASSIGN);
}

- (void)createMediaNewsCellUI
{
    //640px × 340px
    //左右图片栏
    UIImageView *imageView = [[UIImageView alloc]
                    initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 159.0f)];
    [self.contentView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, &MediaNewsImageViewKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *titleLabel = [[UILabel alloc]
                        initWithFrame:CGRectMake(10.0f, 174.0f, 260.0f, 15.0f)];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    objc_setAssociatedObject(self, &MediaNewsTitleKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //播放按钮
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.center = imageView.center;
    playButton.bounds = CGRectMake(0.0f,0.0f,60.0f, 60.0f);
    [playButton setImage:[UIImage imageNamed:@"media_default_play_button"] forState:UIControlStateNormal];
    [self.contentView addSubview:playButton];
    
    //视屏标题
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 189.0f, 200.0f, 15.0f)];
    subTitle.textColor = [UIColor lightGrayColor];
    subTitle.textAlignment = NSTextAlignmentLeft;
    subTitle.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:subTitle];
    objc_setAssociatedObject(self, &MediaNewsSubTitleKey, subTitle, OBJC_ASSOCIATION_ASSIGN);
    
    //更新时间
    UILabel *updateDate = [[UILabel alloc] initWithFrame:CGRectMake(210.0f, 189.0f, 100.0f, 15.0f)];
    updateDate.textColor = [UIColor lightGrayColor];
    updateDate.textAlignment = NSTextAlignmentRight;
    updateDate.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:updateDate];
    objc_setAssociatedObject(self, &MediaNewsUpdateDateKey, updateDate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)createImageNewsCellUI
{
    //240px × 168px = 280 = 282/3 = 94 x 56
    
    //标题栏
    UILabel *titleLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(10.0f, 10.0f, 260.0f, 20.0f)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    objc_setAssociatedObject(self, &ImageNewsTitleKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //评论label
    UILabel *commentLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(250.0f, 15.0f, 60.0f, 15.0f)];
    commentLabel.textAlignment = NSTextAlignmentRight;
    commentLabel.font = [UIFont systemFontOfSize:14.0f];
    commentLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:commentLabel];
    objc_setAssociatedObject(self, &ImageNewsCommentsKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //图片视图的底图
    UIView *imageRootView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 35.0f, 300.0f, 56.0f)];
    [self.contentView addSubview:imageRootView];
    objc_setAssociatedObject(self, &ImageNewsImageKey, imageRootView, OBJC_ASSOCIATION_ASSIGN);
    
    //三个imageview
    for (int i = 0; i < 3; i++) {
        UIImageView *tempView = [[UIImageView alloc]
                initWithFrame:CGRectMake(i * (94.0f+9.0f), 0.0f, 94.0f, 56.0f)];
        [imageRootView addSubview:tempView];
    }
}

- (void)createTextNewsHeaderCellUI
{
    //640 375-187.5
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 187.5f)];
    [self.contentView addSubview:imageView];
    objc_setAssociatedObject(self, &TextNewsHeaderImageViewKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    
    //title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 192.5f, 260.0f, 20.0f)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.contentView addSubview:titleLabel];
    objc_setAssociatedObject(self, &TextNewsHeaderTitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
}

//********************************
//      根据给定的model更新UI
//********************************
#pragma mark - 根据给定的model更新UI
- (void)updateHealthyNewsCellWithModel:(YSMHealthyNewsDataModel *)model
{
    self.newsID = [NSString stringWithString:model.newsID];
    
    //按类更新UI
    switch (model.modelType) {
        case TextHealthyNews:
            [self updateTextNewsNormal:model];
            break;
            
        case TextHealthyHeaderNews:
            [self updateTextNewsHeaderUI:model];
            break;
            
        case ImageHealthyNews:
            [self updateImagesNews:model];
            break;
            
        case MediaHealthyNewsHeader:
            [self updateMediaNewsHeader:model];
            break;
            
        case MediaHealthyNews:
            [self updateMediaNews:model];
            break;
            
        default:
            break;
    }
}

//文本新闻列表更新
- (void)updateTextNewsNormal:(YSMHealthyNewsDataModel *)model
{
    //图片
    UIImageView *imageView = objc_getAssociatedObject(self, &TextNewsNormalImageViewKey);
    imageView.image = model.headerImage;
    
    //标题
    UILabel *titleLabel = objc_getAssociatedObject(self, &TextNewsNormalTitleViewKey);
    titleLabel.text = model.title;
    
    //详情
    UILabel *detailLabel = objc_getAssociatedObject(self, &TextNewsNormalDetailViewKey);
    detailLabel.text = model.detail;
    
    //跟帖
    UILabel *commentLabel = objc_getAssociatedObject(self, &TextNewsNormalCommentViewKey);
    commentLabel.text = model.commentCount;
}

//文本新闻中，头条新联更新
- (void)updateTextNewsHeaderUI:(YSMHealthyNewsDataModel *)model
{
    UIImageView *imageView = objc_getAssociatedObject(self, &TextNewsHeaderImageViewKey);
    imageView.image = model.headerImage;
    
    UILabel *titleLabel = objc_getAssociatedObject(self, &TextNewsHeaderTitleLabelKey);
    titleLabel.text = model.title;
}

//图片新闻UI更新
- (void)updateImagesNews:(YSMHealthyNewsDataModel *)model
{
    //标题label
    UILabel *titleLabel = objc_getAssociatedObject(self, &ImageNewsTitleKey);
    titleLabel.text = model.title;
    
    //跟帖label
    UILabel *commentLabel = objc_getAssociatedObject(self, &ImageNewsCommentsKey);
    commentLabel.text = model.commentCount;
    
    //图片
    if ([model.imagesArray count] == 3) {
        UIView *imagesView = objc_getAssociatedObject(self, &ImageNewsImageKey);
        int i = 0;
        for (UIImageView *obj in [imagesView subviews]) {
            obj.image = model.imagesArray[i];
            i++;
        }
    }
}

- (void)updateMediaNewsHeader:(YSMHealthyNewsDataModel *)model
{
    YSMAnimBlockActionScrollVIew *view = objc_getAssociatedObject(self, &MediaNewsHeaderImageKey);
    [view setImages:model.imagesArray];
}

- (void)updateMediaNews:(YSMHealthyNewsDataModel *)model
{
    UIImageView *imageView = objc_getAssociatedObject(self, &MediaNewsImageViewKey);
    imageView.image = model.headerImage;
    
    UILabel *titleLabel = objc_getAssociatedObject(self, &MediaNewsTitleKey);
    titleLabel.text = model.title;
    
    UILabel *subTitle = objc_getAssociatedObject(self, &MediaNewsSubTitleKey);
    subTitle.text = model.subTitle;
    
    UILabel *updateDate = objc_getAssociatedObject(self, &MediaNewsUpdateDateKey);
    updateDate.text = model.updateTime;
}

@end
