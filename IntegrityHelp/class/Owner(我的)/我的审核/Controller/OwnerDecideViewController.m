//
//  OwnerDecideViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/5.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerDecideViewController.h"

@interface OwnerDecideViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation OwnerDecideViewController

- (void)viewWillAppear:(BOOL)animated{
    [self setNavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}




- (void)setNavi{
    [self initNav:@"审批意见" color:kWhite imgName:@"back_black"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    self.view.backgroundColor = kMainGray;
    _tipLabel.text = _tip;
}

- (IBAction)submitInfo:(id)sender {
    if (_textView.text.length < 1) {
        [self.view Message:@"请输入审核理由" HiddenAfterDelay:1];
        return;
    }
    NSString *urlStr;
    NSDictionary *dic;
    if ([_tip isEqualToString:@"请输入同意理由"]) {
        urlStr = @"IosIndex/doFview";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"p_id":_pid,@"reason":_textView.text};
    }else if([_tip isEqualToString:@"请输入拒绝理由"]){
        urlStr = @"IosIndex/noFview";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"p_id":_pid,@"reason":_textView.text};
    }else{
        urlStr = @"IosIndex/comment";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"p_id":_pid,@"comment":_textView.text,@"t_id":_tid};
    }
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:urlStr refreshCache:NO params:dic success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            });
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        _tipLabel.hidden = YES;
    }else{
        _tipLabel.hidden = NO;
    }
}


@end
