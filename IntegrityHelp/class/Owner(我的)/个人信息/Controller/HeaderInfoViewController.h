//
//  HeaderInfoViewController.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CallBack)(NSString *);

@interface HeaderInfoViewController : BaseViewController
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,copy) CallBack callBack;

@end
