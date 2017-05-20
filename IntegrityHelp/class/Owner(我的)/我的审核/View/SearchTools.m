//
//  SearchTools.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/2.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "SearchTools.h"

@interface SearchTools()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property(nonatomic,strong) UIView *bgView;
@end

@implementation SearchTools


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUI];
    }
    return self;
}




- (void)setUI{
   
    [self addSubview:({
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, ScreenW, 50)];
        _bgView.backgroundColor = [UIColor colorWithHex:0xf9f9f9];
        _bgView.hidden = YES;
        _bgView;
    })];
    
    UIView *imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [imgView addSubview:({
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"owner_gray_search"]];
        img.center = imgView.center;
        img;
    })];
    
    UITextField *textField;
    [_bgView addSubview:({
        textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, ScreenW - 80, 30)];
        textField.placeholder = @"搜索标题，正文内容";
        textField.font = kFont(14);
        textField.layer.cornerRadius = 5;
        textField.layer.masksToBounds = YES;
        textField.backgroundColor = [UIColor whiteColor];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = imgView;
        textField.tag = 100;
        textField.returnKeyType = UIReturnKeySearch;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField;
    })];
    
    [_bgView addSubview:({
        UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [cancelBtn setTitleColor:kMainColor forState:(UIControlStateNormal)];
        cancelBtn.titleLabel.font = kFont(14);
        cancelBtn.frame = CGRectMake(ScreenW - 50, 10, 35, 30);
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
        cancelBtn;
    })];
}





- (IBAction)myChecking:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 100) {
        [_checking setTitleColor:kDarkText forState:(UIControlStateNormal)];
        [btn setTitleColor:kMainColor forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.3 animations:^{
            _line.center = CGPointMake(self.center.x * 1.5, _line.center.y);
        }];
    }else{
        [_checking setTitleColor:kMainColor forState:(UIControlStateNormal)];
        [_checked setTitleColor:kDarkText forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.3 animations:^{
            _line.center = CGPointMake(self.center.x / 2 - 6, _line.center.y);
        }];
    }
//    [self cancelAction];
    UITextField *tf = [_bgView viewWithTag:100];
    [tf resignFirstResponder];
    _bgView.hidden = YES;
    _finished(btn.tag,@"");
}

- (IBAction)searchClick:(id)sender {
    _bgView.hidden = NO;
    UITextField *tf = [_bgView viewWithTag:100];
    tf.text = @"";
    [tf becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show2" object:nil];
}

- (IBAction)shuaixuanClick:(id)sender {
    _finished(600,@"");
}

- (void)cancelAction{
    UITextField *tf = [_bgView viewWithTag:100];
    [tf resignFirstResponder];
    _bgView.hidden = YES;
    _finished(500,@"");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _finished(500,textField.text);
    [textField resignFirstResponder];
    return YES;
}


@end
