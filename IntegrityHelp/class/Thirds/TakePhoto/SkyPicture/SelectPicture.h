//
//  SelectPicture.h
//  xmrbApp
//
//  Created by HelloWorld on 14-8-21.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GetImageBlock)(NSMutableArray *imageArray);
@interface SelectPicture : UIButton

@property (nonatomic, strong) GetImageBlock getImageBlock;
@property (nonatomic, assign) NSInteger maxImageCount;

@property (nonatomic, assign) float ratioOfWidthAndHeight;
@end
