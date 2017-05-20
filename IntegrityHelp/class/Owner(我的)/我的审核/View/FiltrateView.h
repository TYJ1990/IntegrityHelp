//
//  FiltrateView.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/3.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)(NSString *,NSString *,NSString *);

@interface FiltrateView : UIView

- (instancetype)initWithFrame:(CGRect)frame statusArray:(NSArray *)statusArray typeArray:(NSArray *)typeArray;

- (void)reloadDataWithStatusArray:(NSArray *)statusArray typeArray:(NSArray *)typeArray;

@property(nonatomic,copy) CallBack callBack;

@end
