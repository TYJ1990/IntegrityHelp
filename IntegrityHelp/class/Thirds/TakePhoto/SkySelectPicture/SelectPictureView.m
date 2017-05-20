//
//  SelectCollectionView.m
//  PhotoTest
//
//  Created by 陈书钦 on 15/11/17.
//  Copyright © 2015年 陈书钦. All rights reserved.
//

#import "SelectPictureView.h"
#import "JKImagePickerController.h"
#import "UIView+ViewController.h"
#import "MLImageCrop.h"
#import "UIImageView+WebCache.h"
//#import "commodityEditModel.h"
static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

@implementation PictureCell

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)awakeFromNib{
    [self initData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        [self initData];
        
    }
    
    return self;
}

- (void)initData{
    self.myImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.myImageView];
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.width/2)];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
    [self.deleteButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -30)];
    [self.deleteButton addTarget:self action:@selector(toDeleteImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
}

- (void)toDeleteImage{
    if (self.deleteImageBlock) {
        self.deleteImageBlock();
    }
}

- (void)layoutSubviews{
    self.myImageView.frame = self.bounds;
    self.deleteButton.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.width/2);
}

@end

@interface SelectPictureView() <UICollectionViewDataSource,UICollectionViewDelegate,JKImagePickerControllerDelegate,MLImageCropDelegate>
@property(assign,nonatomic) NSInteger imgTotalCount;
@property (strong, nonatomic)JKImagePickerController *imagePickerController;
@end

@implementation SelectPictureView

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
    }
    return self;
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

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self initData];
    }
    return self;
}

-(void) setImageArray:(NSMutableArray *)imageArray
{
    if(imageArray)
    {
        _imageArray = imageArray;
        [_collectionView reloadData];
    }
}

- (void)initData{

    self.imageArray = [[NSMutableArray alloc]init];
    [self.collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:@"PictureCell"];
    [self didSelectImage];
}

- (void)setImageUrlArray:(NSMutableArray *)imageUrlArray{
    self.maxImageCount -= imageUrlArray.count;
    _imageUrlArray = imageUrlArray;
    [self.imageArray removeAllObjects];
    for (int i=0; i<_imageUrlArray.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"default_image"], 1.0);
        NSMutableDictionary *member = imageUrlArray[i];
        id parameterDic = member[@"parameterDic"];
        NSDictionary *imageDic = @{@"image":imageData,@"isNewImage":@"0",@"parameterDic":parameterDic};
        [self.imageArray addObject:imageDic];
    }
    
    __block int imageCount = 0;
    __block NSMutableArray *imageViews = [[NSMutableArray alloc]init];
    for (int i=0; i<_imageUrlArray.count; i++) {
        NSString *imageStr = ((NSMutableDictionary *)self.imageUrlArray[i])[@"imageUrl"];
        if (imageStr) {
            NSURL *imageUrl = [[NSURL alloc]initWithString:imageStr];
            __weak typeof(self) weakSelf = self;
            if (imageUrl) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-320, 0, 1, 1)];
                [imageViews addObject:imageView];
                
                [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"default_image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]initWithDictionary:weakSelf.imageArray[i]];
                        [imageDic setObject:UIImageJPEGRepresentation(image, 1.0) forKey:@"image"];
                        [weakSelf.imageArray replaceObjectAtIndex:i withObject:imageDic];
                    }
                    if (imageCount == (weakSelf.imageArray.count - 1)) {
                        for (UIImageView *tempImageView in imageViews) {
                            [tempImageView removeFromSuperview];
                        }
                        [imageViews removeAllObjects];
                        [weakSelf.collectionView reloadData];
                    }
                    imageCount++;
                }];
                [weakSelf addSubview:imageView];
            }
        }
    }
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
    __weak typeof(self) weakSelf = self;

    if (assets.count==1) {
        JKAssets *asset = [assets objectAtIndex:0];
        ALAssetsLibrary  *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                [weakSelf cutImage: UIImageJPEGRepresentation(image, 1.0)];
                return ;
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
    } else {
        
        for (int i=0;i<assets.count;i++) {
        
            JKAssets *asset = [assets objectAtIndex:i];
            ALAssetsLibrary  *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    
                    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
          
                    NSDictionary *imageDic = @{@"image":imageData,@"isNewImage":@"1"};
                    
                    [weakSelf.imageArray addObject:imageDic];
                    
                    if (i == assets.count - 1) {
                        if (weakSelf.getImageBlock) {
                            
                            weakSelf.getImageBlock(weakSelf.imageArray);
                            
                        }
                        
                        if(weakSelf.getImageTotalBlack)
                            weakSelf.getImageTotalBlack(weakSelf.imageArray,(weakSelf.imgTotalCount+=_imageArray.count));
                    }
                    
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }

    
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
    }];
}





- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//拍照点击完成
- (void)imagePickerController:(JKImagePickerController *)imagePicker didPhoto:(JKAssets *)asset{
    
    [imagePicker.view Loading_0314];
    if (self.getImageBlock) {
        __weak typeof(self) weakSelf = self;
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                
                [weakSelf cutImage:UIImageJPEGRepresentation(image, 1.0)];
                
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
    self.assetsArray = [[NSMutableArray alloc]initWithObjects:asset, nil];
    [imagePicker dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)cutImage:(NSData *)imageData{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight = _ratioOfWidthAndHeight;
    imageCrop.image = [UIImage imageWithData:imageData];
    [imageCrop showWithAnimation:NO];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75*(ScreenW/320), 75*(ScreenW/320)/1.33333);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 0, 2);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.maxImageCount = 8;
    int imageCount = (int)(8 - self.imageArray.count);
    if (imageCount > 0) {
        return self.imageArray.count+1;
    } else {
        return self.imageArray.count;
    }

    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    if (self.imageArray.count > 0) {
        int imageCount = (int)(8 - self.imageArray.count);
        if (imageCount > 0) {
            if (indexPath.row == self.imageArray.count) {
                [cell.myImageView setImage:[UIImage imageNamed:@"choseAddImg"]];
                cell.deleteButton.hidden = YES;
            } else {
                cell.deleteButton.hidden = NO;
                NSDictionary *imageDic = self.imageArray[indexPath.row];
                NSData *imageData = imageDic[@"image"];
                
//                commodityEditProductImagesModel *paramDic =imageDic[@"parameterDic"];
//                if(paramDic.thumbnail&&[TXUtilsString isBlankString:paramDic.thumbnail])
//                {
//                     [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:paramDic.thumbnail] placeholderImage:[UIImage imageNamed:@"NoGoods"] options:SDWebImageRetryFailed];
//                }
//                else
//                {
//                }
                [cell.myImageView setImage:[UIImage imageWithData:imageData]];
       
                __weak typeof(self) weakSelf = self;
                cell.deleteImageBlock = ^(){
                    [weakSelf.imageArray removeObjectAtIndex:indexPath.row];
                    if (weakSelf.getImageBlock) {
                          weakSelf.getImageBlock(weakSelf.imageArray);
                        
                        
                        if(weakSelf.getImageTotalBlack)
                            weakSelf.getImageTotalBlack(weakSelf.imageArray,(weakSelf.imgTotalCount+=_imageArray.count));
                    }
                    [weakSelf.collectionView reloadData];
                };
            }
        } else {
            cell.deleteButton.hidden = NO;
            NSDictionary *imageDic = self.imageArray[indexPath.row];
            NSData *imageData = imageDic[@"image"];
            cell.myImageView.image = [UIImage imageWithData:imageData];
            __weak typeof(self) weakSelf = self;
            cell.deleteImageBlock = ^(){
                [weakSelf.imageArray removeObjectAtIndex:indexPath.row];
                if (weakSelf.getImageBlock) {
                      weakSelf.getImageBlock(weakSelf.imageArray);
                    
                    if(weakSelf.getImageTotalBlack)
                        weakSelf.getImageTotalBlack(weakSelf.imageArray,(weakSelf.imgTotalCount+=_imageArray.count));
                }
                [weakSelf.collectionView reloadData];
            };
        }
    } else {
        [cell.myImageView setImage:[UIImage imageNamed:@"choseAddImg"]];
        cell.deleteButton.hidden = YES;
    }
    
    
    return cell;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageArray.count || self.imageArray.count <= 0) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            BaseAlertControler *qq = [[BaseAlertControler alloc]init];
            UIAlertController *alert = [qq alertmessage:@"请先允许信扶访问你的相册及相机功能" Title:nil andBlock:^{
                NSURL*url=[NSURL URLWithString:@"prefs:root=com.tiaohuo.assistant"];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [self.viewController presentViewController:alert animated:YES completion:nil];
            return;
        }
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = self.allowsMultipleSelection;
        imagePickerController.minimumNumberOfSelection = 1;
        int imageCount = (int)(self.maxImageCount - self.imageArray.count);
        imagePickerController.maximumNumberOfSelection = imageCount <0?5:imageCount;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self.viewController presentViewController:navigationController animated:YES completion:NULL];
    }
    
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}

- (void)layoutSubviews{
    self.collectionView.frame = self.bounds;
}


#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    if (cropImage) {
        NSDictionary *imageDic = @{@"image":UIImageJPEGRepresentation(cropImage, 1.0),@"isNewImage":@"1"};
        [self.imageArray addObject:imageDic];
      
        if (self.getImageBlock) {
            self.getImageBlock(self.imageArray);
        }
          [self.collectionView reloadData];
    }
}


@end
