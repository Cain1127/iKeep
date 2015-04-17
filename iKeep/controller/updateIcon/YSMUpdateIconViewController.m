//
//  YSMUpdateIconViewController.m
//  iKeep
//
//  Created by ysmeng on 14/11/4.
//  Copyright (c) 2014年 YangShengmeng. All rights reserved.
//

#import "YSMUpdateIconViewController.h"
#import "YSMBlockActionButton.h"
#import "YSMXMPPManager.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

@interface YSMUpdateIconViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

//关联key
static char IconImageViewKey;
@implementation YSMUpdateIconViewController

//***********************************
//      初始化/UI搭建
//***********************************
#pragma mark - 初始化/UI搭建
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建UI
    [self createUpadeIconUI];
}

- (void)createUpadeIconUI
{
    //标题
    [self setNavigationBarMiddleTitle:@"上传头像"];
    
    //图片框
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(80.0f, 20.0f, 160.0f, 160.0f)];
    [self.mainShowView addSubview:iconView];
    iconView.backgroundColor = [UIColor orangeColor];
    objc_setAssociatedObject(self, &IconImageViewKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    //头像修成圆image view
    UIImageView *iconBGView = [[UIImageView alloc]
                    initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 160.0f)];
    iconBGView.image = [UIImage imageNamed:IMAGE_LOGIN_MAIN_ICON_DEFAULT_BG];
    [iconView addSubview:iconBGView];
    
    //按钮风格
    YSMButtonStyleDataModel *buttonStyle = [[YSMButtonStyleDataModel alloc] init];
    buttonStyle.titleNormalColor = BLUE_BUTTON_TITLECOLOR_NORMAL;
    buttonStyle.titleHightedColor = BLUE_BUTTON_TITLECOLOR_HIGHTLIGHTED;
    
    //重新选择/或者拍照
    UIButton *loadButton = [UIButton createYSMBlockActionButton:CGRectMake(30.0f, 190.0f, 260.0f, 44.0f) andTitle:@"上传" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        //取得管理器
        YSMXMPPManager *manager = [YSMXMPPManager shareXMPPManager];
        [manager updatePersonHeaderIcon:iconView.image andCallBack:^(YSMvCardDataModel *model) {
            //更新成功后返回，并通知上一页面刷新
            if (self.updateSuccessCallBack) {
                self.updateSuccessCallBack();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [self.mainShowView addSubview:loadButton];
    
    UIButton *repickButton = [UIButton createYSMBlockActionButton:CGRectMake(30.0f, 244.0f, 260.0f, 44.0f) andTitle:@"从相册选择" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        [self repickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [self.mainShowView addSubview:repickButton];
    
    UIButton *repCameraButton = [UIButton createYSMBlockActionButton:CGRectMake(30.0f, 298.0f, 260.0f, 44.0f) andTitle:@"拍照" andStyle:buttonStyle andCallBalk:^(UIButton *button) {
        [self repickImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [self.mainShowView addSubview:repCameraButton];
}

//***********************************
//      重新选择/拍照
//***********************************
#pragma mark - 重新选择/拍照
- (void)repickImageWithSourceType:(UIImagePickerControllerSourceType)type
{
    if (type == UIImagePickerControllerSourceTypeCamera) {
        //拍照：如果是要准备进行拍照，一定要判断设备是否支持拍照
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]) {
            //如果是拍照
            [self loadImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            //如果不支持拍照，弹出说明窗口
            [self alertWrongMessage:nil andMessage:TITLE_PICK_CAMARA_CHECK_WRONG];
        }
    } else if(type == UIImagePickerControllerSourceTypePhotoLibrary) {
        //取本地相册
        //需要判断是否支持取本地相册
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            //如果支持取本地相册：则调用本地相册
            [self loadImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        } else {
            //如果不支持拍照，弹出说明窗口
            [self alertWrongMessage:nil andMessage:TITLE_PICK_PICTURE_CHECK_WRONG];
        }
    }
}

- (void)loadImageWithSourceType:(UIImagePickerControllerSourceType)type
{
    //根据不同的资源类型，加载不同的界面
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.delegate = self;
    pickVC.sourceType = type;
    pickVC.allowsEditing = YES;//允许编辑
    
    //用模式跳转窗体
    [self presentViewController:pickVC animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //相册里存有很多资源，一般会有相片，视频，所以需要判断当前取的是哪种资源
    /*
     将图片转化成NSData 存入应用的沙盒中
     */
    NSString *sourceType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImageView *imageView = objc_getAssociatedObject(self, &IconImageViewKey);
        imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//***********************************
//      显示选择的头像
//***********************************
#pragma mark - 将选择或拍照的图片加载显示
- (void)loadNewsIcon:(NSData *)imageData
{
    UIImageView *iconView = objc_getAssociatedObject(self, &IconImageViewKey);
    iconView.image = [UIImage imageWithData:imageData];
}

@end
