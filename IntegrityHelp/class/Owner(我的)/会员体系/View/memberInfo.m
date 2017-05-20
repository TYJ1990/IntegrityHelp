//
//  memberInfo.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/2.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "memberInfo.h"

@interface memberInfo()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *telphone;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *age;

@end

@implementation memberInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 40;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}


- (IBAction)dismiss:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cooperation" object:@{@"key":@"dismiss"}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"detailDismiss" object:nil];
}

- (void)configureWithName:(NSString *)name icon:(NSString *)icon telphone:(NSString *)telphone gener:(NSString *)gender age:(NSString *)age type:(NSString *)type{
    [_icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"owner_header"]];
    _type.text = type;
    _telphone.text = telphone;
    _name.text = name;
    _gender.text = gender;
    _age.text = age;
}

- (IBAction)sure:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cooperation" object:nil];
}


@end
