//
//  SelectOnePicture.h
//  PhotoTest
//
//  Created by 陈书钦 on 15/11/17.
//  Copyright © 2015年 陈书钦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetOneImageBlock)(NSData *imageData);

@interface SelectOnePicture : UIButton

@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, assign) float ratioOfWidthAndHeight;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) GetOneImageBlock getOneImageBlock;
@property (nonatomic, strong) UIViewController *superController;
//@property (assign,nonatomic) CGFloat  cutWidth;
//@property (assign,nonatomic) CGFloat cutHeight;
@property (assign,nonatomic)BOOL enableCutImg;
//@property (nonatomic,assign) CGFloat ratioOfWidthAndHeight;
- (void)toSelectImage:(GetOneImageBlock)getOneImageBlock;
@end
