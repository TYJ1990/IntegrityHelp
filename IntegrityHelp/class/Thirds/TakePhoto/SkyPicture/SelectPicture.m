//
//  SelectPicture.m
//  xmrbApp
//
//  Created by HelloWorld on 14-8-21.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "SelectPicture.h"
#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+ViewController.h"
#import "MLImageCrop.h"

@interface SelectPicture () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate, UIAlertViewDelegate,MLImageCropDelegate>

@property (nonatomic, strong) UIActionSheet *myActionSheet;
@property (nonatomic, strong) QBImagePickerController *imagePickerController;

@end

@implementation SelectPicture

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addTarget:self action:@selector(clickAddImgButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(clickAddImgButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickAddImgButton:(UIButton *)sendor
{
    self.myActionSheet = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                          otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [self.myActionSheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == self.myActionSheet.cancelButtonIndex) {
        NSLog(@"取消");
    }
    
    switch (buttonIndex) {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        //[self.navigationController pushViewController:picker animated:YES];
        UIViewController *viewController = self.viewController;
        [viewController presentViewController:picker animated:YES completion:NULL];
    } else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIViewController *viewController = self.viewController;
    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.imagePickerController];
    [viewController presentViewController:self.imagePickerController animated:YES completion:NULL];
}

- (QBImagePickerController *) imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = ({
            QBImagePickerController *imagePickerController = [QBImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.mediaType = QBImagePickerMediaTypeImage;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.showsNumberOfSelectedAssets = YES;
            imagePickerController.maximumNumberOfSelection = self.maxImageCount <= 0?5:self.maxImageCount;
            imagePickerController;
        });
    }
    return _imagePickerController;
}

- (void)dismissImagePickerController
{
    UIViewController *viewController = self.viewController;
    if (viewController.presentedViewController) {
        [viewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [viewController.navigationController popToViewController:viewController animated:YES];
    }
}

//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIViewController *viewController = self.viewController;
//    [viewController.view addSubview:viewController.loadingIndicator];
//    [viewController.loadingIndicator showLoading];
    // Recover the snapped image
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // Save the image to the album
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    BrokeNewsController *viewController = (BrokeNewsController *)[ControllerManage getSuperViewController:self.superview.superview];
//    [viewController.loadingIndicator hideLoading];
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"拍摄相片已保存入系统相册,请到相册中选择拍摄图片" ;
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    alert.delegate = self;
//    [alert show];
    
    
//    NSMutableArray *imgViews = @[].mutableCopy;
//    [imgViews addObject:image];
//    if (self.getImageBlock) {
//        self.getImageBlock(imgViews);
//    }
//
    [self cutImage:UIImageJPEGRepresentation(image, 1.0)];
}

- (void)cutImage:(NSData *)imageData{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight = self.ratioOfWidthAndHeight <= 0?320/240:self.ratioOfWidthAndHeight;
    imageCrop.image = [UIImage imageWithData:imageData];
    [imageCrop showWithAnimation:YES];
}

//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self LocalPhoto];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *imgViews = @[].mutableCopy;
//    NSMutableArray *saveImgs = @[].mutableCopy;
    if(imagePickerController.allowsMultipleSelection) {
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        for (int i = 0; i < assets.count; i++) {
            // 在资源的集合中获取第一个集合，并获取其中的图片
//            [imageManager requestImageForAsset:assets[i]
//                                    targetSize:CGSizeMake(640, 480)
//                                   contentMode:PHImageContentModeDefault
//                                       options:nil
//                                 resultHandler:^(UIImage *result, NSDictionary *info) {
//                                     
//                                     // 得到一张 UIImage，展示到界面上
//                                     [imgViews addObject:result];
//                                     
//                                 }];
            [imageManager requestImageDataForAsset:assets[i] options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                [imgViews addObject:imageData];
                if (i == (assets.count - 1)) {
                    if (self.getImageBlock) {
                        self.getImageBlock(imgViews);
                    }
                }
            }];
//            // 获取资源图片的详细资源信息，其中 imageAsset 是某个资源的 ALAsset 对象
//            ALAssetRepresentation *representation = [assets[i] defaultRepresentation];
//            // 获取资源图片的 fullScreenImage
//            UIImage *contentImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
//            [imgViews addObject:contentImage];
        }
    } else {
        NSLog(@"*** qb_imagePickerController:didSelectAssets:");
        NSLog(@"%@", assets);
    }

    
    
    UIViewController *viewController = self.viewController;
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{

    UIViewController *viewController = self.viewController;
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    NSMutableArray *imgViews = @[].mutableCopy;
    [imgViews addObject:UIImageJPEGRepresentation(originalImage, 1.0)];
    if (self.getImageBlock) {
        self.getImageBlock(imgViews);
    }

}


@end
