 //
//  SelectCollectionView.h
//  PhotoTest
//
//  Created by 陈书钦 on 15/11/17.
//  Copyright © 2015年 陈书钦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteImageBlock)(void);



@interface PictureCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) DeleteImageBlock deleteImageBlock;

@end

typedef void (^GetImageBlock)(NSMutableArray *imageArray);

typedef void (^GetImageWithCountBlock)(NSMutableArray *imageArray,NSInteger imgTotalCount);

@interface SelectPictureView : UIView
@property (nonatomic, strong) UIViewController *superController;
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, assign) float ratioOfWidthAndHeight;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,copy) GetImageWithCountBlock getImageTotalBlack;
@property (nonatomic, strong) GetImageBlock getImageBlock;
//@property (nonatomic,assign) CGFloat ratioOfWidthAndHeight;

@end
