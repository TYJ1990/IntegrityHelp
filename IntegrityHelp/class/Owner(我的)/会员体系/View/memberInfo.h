//
//  memberInfo.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/2.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface memberInfo : UIView
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (void)configureWithName:(NSString *)name icon:(NSString *)icon telphone:(NSString *)telphone gener:(NSString *)gender age:(NSString *)age type:(NSString *)type;

@end
