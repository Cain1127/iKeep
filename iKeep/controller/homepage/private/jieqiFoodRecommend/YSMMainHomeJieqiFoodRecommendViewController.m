//
//  YSMMainHomeJieqiFoodRecommendViewController.m
//  iKeep
//
//  Created by ysmeng on 14/11/8.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMMainHomeJieqiFoodRecommendViewController.h"
#import "YSMHealthyFoodRecommendTableViewCell.h"
#import "MJRefresh.h"
#import "YSMMainHandler.h"

#import <objc/runtime.h>

//关联key
static char HeaderImageKey;
static char HeaderTitleImageKey;
static char HeaderFoodsDescriptionKey;
static char TableViewKey;
@interface YSMMainHomeJieqiFoodRecommendViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_foodRecommendSource;//推荐健康菜谱数据源
}

@end

@implementation YSMMainHomeJieqiFoodRecommendViewController

//******************************************
//          初始化/UI搭建
//******************************************
#pragma mark - 初始化/UI搭建
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据源
    _foodRecommendSource = [[NSMutableArray alloc] init];
    
    //创建UI
    [self createHealthyFoodJieqiRecommendUI];
}

//创建UI
- (BOOL)createHealthyFoodJieqiRecommendUI
{
    //底部scrollview
    UIScrollView *rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, -64.0f, self.mainShowView.frame.size.width, self.mainShowView.frame.size.height+64.0f)];
    [self.mainShowView addSubview:rootScrollView];
    rootScrollView.showsHorizontalScrollIndicator = NO;
    rootScrollView.showsVerticalScrollIndicator = NO;
    rootScrollView.delegate = self;
    rootScrollView.backgroundColor = [UIColor whiteColor];
    //568-64=504
    rootScrollView.contentSize = CGSizeMake(rootScrollView.frame.size.width, 580.0f);
    
    //设置导航栏背景颜色
    [self setNavigationViewBackgroundColor:[UIColor clearColor]];
    
    return [self createSubViewsOnScrollView:rootScrollView];
}

//在scrollView上添加子控件
- (BOOL)createSubViewsOnScrollView:(UIView *)view
{
    //头图片：640px × 440px
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 220.0f)];
    headerImage.image = [UIImage imageNamed:IMAGE_JIEQI_HEALTHYFOOD_RECOMMEND_HEADER];
    [view addSubview:headerImage];
    objc_setAssociatedObject(self, &HeaderImageKey, headerImage, OBJC_ASSOCIATION_ASSIGN);
    
    //头图片上面的view
    UIView *headerAboveView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -64.0f, 320.0f, 220.0f)];
    [self.mainShowView addSubview:headerAboveView];
    [self createHeaderSubviews:headerAboveView];
    
    //在scrollView上添加UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 230.0f, 320.0f, view.frame.size.height - 220.0f) style:UITableViewStylePlain];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView addHeaderWithTarget:self action:@selector(requestHealthyFoodJieqiRecommendData)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:tableView];
    [tableView headerBeginRefreshing];
    objc_setAssociatedObject(self, &TableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
    
    return YES;
}

//头图片中的子视图
- (void)createHeaderSubviews:(UIView *)view
{
    //推荐头
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 27.0f, 80.0f, 30.0f)];
    titleLable.text = @"为您推荐";
    titleLable.font = [UIFont boldSystemFontOfSize:14.0f];
    titleLable.textColor = [UIColor whiteColor];
    [view addSubview:titleLable];
    
    //节气图片:220
    UIImageView *jieqiImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 64.0f, 290.0f, 70.0f)];
    jieqiImage.image = [UIImage imageNamed:@"healthy_foods_recommend_jieqi_header_jieqi"];
    [view addSubview:jieqiImage];
    objc_setAssociatedObject(self, &HeaderTitleImageKey, jieqiImage, OBJC_ASSOCIATION_ASSIGN);
    
    //说明view220-144=76
    UIImageView *jieqiDesImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 134.0f, 300.0f, 76.0f)];
    jieqiDesImage.image = [UIImage imageNamed:@"healthy_foods_recommend_header_des_bg"];
    [view addSubview:jieqiDesImage];
    
    //说明label
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 290.0f, 76.0f)];
    desLabel.text = @"立冬补冬是千年风俗，现代“虚者补之，寒者温之”即可。怕冷、易感冒的人增加营养，平日就鱼肉不断或体内湿气、火气重的人，以清淡易消化为主，反而有益脾胃。";
    desLabel.numberOfLines = 4;
    desLabel.textColor = [UIColor whiteColor];
    desLabel.font = [UIFont systemFontOfSize:14.0f];
    objc_setAssociatedObject(self, &HeaderFoodsDescriptionKey, desLabel, OBJC_ASSOCIATION_ASSIGN);
    [jieqiDesImage addSubview:desLabel];
}

//******************************************
//             scrollView代理方法
//******************************************
#pragma mark - scrollView代理方法

//视图滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滚动时头图片动画变大变小
    if (scrollView.contentOffset.y <= 0) {
        UIImageView *headerImage = objc_getAssociatedObject(self, &HeaderImageKey);
        CGFloat ypoint = scrollView.contentOffset.y;
        CGFloat xpoint = -(((-ypoint)/220.0f)*320.0f/2.0f);
        headerImage.frame = CGRectMake(xpoint, ypoint, 320.0f+2*(-xpoint), 220.0f+(-ypoint));
        headerImage.bounds = CGRectMake(xpoint, ypoint, 320.0f+2*(-xpoint), 220.0f+(-ypoint));
    }
}

//******************************************
//             tableView数据源
//******************************************
#pragma mark - tableView数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *useCellName = @"useCellName";
    YSMHealthyFoodRecommendTableViewCell *useCell =
    [tableView dequeueReusableCellWithIdentifier:useCellName];
    if (nil == useCell) {
        useCell = [[YSMHealthyFoodRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:useCellName];
    }
    useCell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSMHealthyFoodRecommendDataModel *model = [_foodRecommendSource[indexPath.section] valueForKey:@"cellModel"][indexPath.row];
    [useCell updateUIWithModel:model];
    return useCell;
}

//返回有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_foodRecommendSource count];
}

//返回每个section有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_foodRecommendSource[section] valueForKey:@"cellModel"] count];
}

//返回每一行section的标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 160.0f, 30.0f)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = [_foodRecommendSource[section] valueForKey:@"sectionTitle"];
    [view addSubview:titleLabel];
    return view;
}

//返回每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSMHealthyFoodRecommendDataModel *model = [_foodRecommendSource[indexPath.section] valueForKey:@"cellModel"][indexPath.row];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    CGSize labelSize = [model.detail boundingRectWithSize:CGSizeMake(220.0, 999.0) options:NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    if (labelSize.height > 20.0f) {
        return 80.0f + labelSize.height;
    }
    return 80.0f;
}

//返回section的高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

//******************************************
//             请求数据
//******************************************
#pragma mark - 请求数据
- (void)requestHealthyFoodJieqiRecommendData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        YSMMainHandler *manager = [YSMMainHandler shareMainHandler];
        HANDLE_ACTION_TYPE foodType = RequestJieqiHealthyFoodRecommendData;
        if (self.foodsType == JieqiHealthyFoodsRecommendType) {
            foodType = RequestJieqiHealthyFoodRecommendData;
        } else if (self.foodsType == HealthyFoodsRecommendType){
            foodType = RequestHealthyFoodRecommendData;
        }
        [manager requestData:foodType andAction:^(YSMMainHandleDataModel *result) {
            //请求失败
            if (!result.resultFlag) {
                [self alertWrongMessage:nil andMessage:@"数据请求失败"];
                return;
            }
            
            //请求成功更新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self updateHealthyFoodRecommendUI:result.result];
            });
        }];
    });
}

//更新UI
- (void)updateHealthyFoodRecommendUI:(NSArray *)array
{
    if (self.foodsType == JieqiHealthyFoodsRecommendType) {
        UIImageView *headerImage = objc_getAssociatedObject(self, &HeaderImageKey);
        headerImage.image = array[0];
        
        UIImageView *headerJieqi = objc_getAssociatedObject(self, &HeaderTitleImageKey);
        headerJieqi.image = array[1];
        
        UILabel *desLabel = objc_getAssociatedObject(self, &HeaderFoodsDescriptionKey);
        desLabel.text = array[2];
    }
    
    UITableView *tableView = objc_getAssociatedObject(self, &TableViewKey);
    [_foodRecommendSource removeAllObjects];
    if (self.foodsType == JieqiHealthyFoodsRecommendType) {
        [_foodRecommendSource addObjectsFromArray:array[5]];
    } else {
        [_foodRecommendSource addObjectsFromArray:array];
    }
    [tableView headerEndRefreshing];
    [tableView reloadData];
}

//菜谱时需要设置背景图片的数据
- (void)loadJieqiFoodData:(NSArray *)array
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImageView *headerImage = objc_getAssociatedObject(self, &HeaderImageKey);
        headerImage.image = array[0];
        
        UIImageView *headerJieqi = objc_getAssociatedObject(self, &HeaderTitleImageKey);
        headerJieqi.image = array[1];
        
        //重调说明的父view
        UILabel *desLabel = objc_getAssociatedObject(self, &HeaderFoodsDescriptionKey);
        desLabel.text = array[2];
        
        UIView *view = desLabel.superview;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 160.0f, 44.0f);
        desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, 140.0f, 40.0f);
    });
}

@end
