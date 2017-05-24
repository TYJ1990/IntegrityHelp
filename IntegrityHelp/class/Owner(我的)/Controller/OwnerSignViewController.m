//
//  OwnerSignViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/12.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerSignViewController.h"
#import "OwnerHistorySignViewController.h"


@interface OwnerSignViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation OwnerSignViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    [self setNavi];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_sign.length > 0) {
        _textView.text = _sign;
        _placeholder.hidden = YES;
    }
}


-(void)setNavi{
    [self initNav:@"我的签名" color:kWhite imgName:@"back_black"];
    [self rightTitle:@"历史"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
}



- (IBAction)saveInfo:(id)sender {
    
    if (_textView.text.length == 0) {
       _textView.text = @" ";
    }
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/sendContent" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],@"content":_textView.text} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _placeholder.hidden = YES;
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length < 1) {
        _placeholder.hidden = NO;
    }else{
        _placeholder.hidden = YES;
    }
}

- (void)rightAction{
    OwnerHistorySignViewController *historyVC = [[OwnerHistorySignViewController alloc] init];
    
    [self.navigationController pushViewController:historyVC animated:YES];
}


@end
