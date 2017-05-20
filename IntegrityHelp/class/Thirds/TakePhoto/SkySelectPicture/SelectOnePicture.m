//
//  SelectOnePicture.m
//  PhotoTest
//
//  Created by 陈书钦 on 15/11/17.
//  Copyright © 2015年 陈书钦. All rights reserved.
//

#import "SelectOnePicture.h"
#import "JKImagePickerController.h"
#import "UIView+ViewController.h"
#import "MLImageCrop.h"

@interface SelectOnePicture ()<JKImagePickerControllerDelegate,MLImageCropDelegate>
@property (strong, nonatomic)JKImagePickerController *imagePickerController;
@property (strong,nonatomic) UIImage *img;
@end

@implementation SelectOnePicture

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {

        [self addTarget:self action:@selector(clickAddImgButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Create a image view
        _enableCutImg = YES;

        [self addTarget:self action:@selector(clickAddImgButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)clickAddImgButton:(id)sender{

    [self didSelectImage];
}

- (void)toSelectImage:(GetOneImageBlock)getOneImageBlock{
    self.getOneImageBlock = getOneImageBlock;
    [self didSelectImage];
}

- (void)didSelectImage{
    _imagePickerController  = [[JKImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.showsCancelButton = YES;
    _imagePickerController.allowsMultipleSelection = NO;
    _imagePickerController.minimumNumberOfSelection = 1;
    _imagePickerController.maximumNumberOfSelection = 1;
    //    imagePickerController.selectedAssetArray = self.assetsArray;
    UIViewController *controllerView = self.viewController;
    if (!controllerView) {
        controllerView = self.superController;
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_imagePickerController];
    [controllerView presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    [imagePicker.view Loading_0314];
    [NSThread sleepForTimeInterval:0.1];
    
    
        if (self.getOneImageBlock) {
            NSMutableArray *imageViews = [[NSMutableArray alloc]init];
            for (int i=0;i<assets.count;i++) {
                JKAssets *asset = [assets objectAtIndex:i];
                ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
                __weak typeof(self) weakSelf = self;
                [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                        _img = image;
                        [imageViews addObject:UIImageJPEGRepresentation(image,1.0)];
                        if (assets.count == 1) {
                            if (weakSelf.getOneImageBlock) {
                                [weakSelf cutImage:UIImageJPEGRepresentation(image, 1.0)];
                                //weakSelf.getOneImageBlock(UIImageJPEGRepresentation(image,1.0));
                                //weakSelf.getOneImageBlock(imgData);
                            }
                        }
                    }
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }
        
        
        self.assetsArray = [NSMutableArray arrayWithArray:assets];
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];

}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didPhoto:(JKAssets *)asset{
    if (self.getOneImageBlock) {
        __weak typeof(self) weakSelf = self;
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                if(_enableCutImg){
                     [weakSelf cutImage:UIImageJPEGRepresentation(image, 1.0)];
                }
                else
                {
                    self.getOneImageBlock(UIImageJPEGRepresentation(image, 1.0));
                }
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
 
    }];
}


- (void)cutImage:(NSData *)imageData{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
//    imageCrop.cutWidth = _cutWidth;
//    imageCrop.cutHeight = _cutHeight;
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight =_ratioOfWidthAndHeight;
    imageCrop.image = [UIImage imageWithData:imageData];
    [imageCrop showWithAnimation:YES];
}



#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    //    [self setImage:originalImage forState:UIControlStateNormal];
    //    [self setBackgroundImage:originalImage forState:UIControlStateNormal];
    if (self.getOneImageBlock) {
        self.getOneImageBlock(UIImageJPEGRepresentation(cropImage, 1.0));
    }
    
}


@end
