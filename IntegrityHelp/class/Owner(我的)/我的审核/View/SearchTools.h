//
//  SearchTools.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/2.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Finished) (NSInteger ,NSString *);

@interface SearchTools : UIView

@property(nonatomic,copy) Finished finished;
@property (weak, nonatomic) IBOutlet UIButton *checking;
@property (weak, nonatomic) IBOutlet UIButton *checked;

@end
