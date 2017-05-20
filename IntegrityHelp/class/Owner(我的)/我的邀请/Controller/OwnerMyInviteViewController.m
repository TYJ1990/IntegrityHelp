//
//  OwnerMyInviteViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerMyInviteViewController.h"
#import "OwnerInvitModel.h"
#import <Photos/Photos.h>


@interface OwnerMyInviteViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *QRCode;
@property (weak, nonatomic) IBOutlet UILabel *codeNumber;
@property (weak, nonatomic) IBOutlet UILabel *usedBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(nonatomic,strong) UIScrollView *scrollview;
@property(nonatomic,strong) OwnerInvitModel *invitModel;
@property(nonatomic,strong) NSMutableArray *modelArray;
@property(nonatomic,strong) UIButton *creatBtn;

@end

@implementation OwnerMyInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initnavi];
    [self setUI];
    [self downloadData];
}


- (void)initnavi{
    [self initNav:@"我的邀请" color:RGB(68, 69, 84) imgName:@"back_white"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self rightTitle:@"保存"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    self.view.backgroundColor = RGB(68, 69, 84);
}


- (void)setUI{
    [self.view addSubview:({
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenW, ScreenH - 104 - 100)];
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.delegate = self;
        _scrollview.backgroundColor = [UIColor clearColor];
        _scrollview.pagingEnabled = YES;
        _scrollview.contentSize = CGSizeMake(ScreenW * 3, ScreenH - 104 - 100);
        _scrollview;
    })];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyCodeNumber)];
    [_scrollview addGestureRecognizer:longPress];
    
    _usedBtn.layer.borderWidth = 1;
    _headImg.image = _Img;
    _modelArray = [NSMutableArray array];
    
    [self.view addSubview:({
        _creatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_creatBtn setTitle:@"生成二维码" forState:(UIControlStateNormal)];
        [_creatBtn addTarget:self action:@selector(creatQRCode:) forControlEvents:(UIControlEventTouchUpInside)];
        [_creatBtn setTitleColor:kMainColor forState:(UIControlStateNormal)];
        _creatBtn.hidden = YES;
        _creatBtn.titleLabel.font = kFont(15);
        _creatBtn.frame = CGRectMake(ScreenW - 140, 60, 110, 40);
        _creatBtn;
    })];
}

- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/myQrcode" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _invitModel = [[OwnerInvitModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                if ([[Utils getValueForKey:@"u_id"] integerValue] == 1) {
                    for (int i = 0; i < _invitModel.data.count; i++) {
                        OwnerInvitListModel *model = _invitModel.data[i];
                        if (![model.Isshow boolValue]) {
                            [_modelArray addObject:model];
                        }
                    }
                    if (_modelArray.count == 0) {
                        [self.view Message:@"暂无未使用的邀请码" HiddenAfterDelay:1];
                    }else{
                        [self UIGetData:_modelArray[0]];
                    }
                    _scrollview.contentSize = CGSizeMake(ScreenW * _modelArray.count, ScreenH - 104 - 100);
                    _pageControl.numberOfPages = _modelArray.count;
                    _creatBtn.hidden = NO;
                }else{
                    [self UIGetData:_invitModel.data[0]];
                }
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)UIGetData:(OwnerInvitListModel *)model{
    [_QRCode sd_setImageWithURL:[NSURL URLWithString:imageUrl2(model.Qrcode)]];
    _codeNumber.text = [NSString stringWithFormat:@"长按复制邀请码：%@",model.Code];
    _usedBtn.textColor = [model.Isshow boolValue] ? kLightGray : kMainColor;
    _usedBtn.layer.borderColor = [model.Isshow boolValue] ? kLightGray.CGColor : kMainColor.CGColor;
    _usedBtn.text = [model.Isshow boolValue] ? @"已使用" : @"未使用";
}


- (void)creatQRCode:(UIButton *)sender {
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/addCode" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            [_modelArray removeAllObjects];
            [self downloadData];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    _pageControl.currentPage = index;
    WS(weakSelf)
    [UIView animateWithDuration:1 animations:^{
        if ([[Utils getValueForKey:@"u_id"] integerValue] == 1) {
            [weakSelf UIGetData:_modelArray[index]];
        }else{
            [weakSelf UIGetData:_invitModel.data[index]];
        }
    }];
}

-(void)copyCodeNumber{
    NSInteger index = _scrollview.contentOffset.x / ScreenW;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [_invitModel.data[index] Code];
    [self.view Message:@"复制成功" HiddenAfterDelay:1];
}



- (void)rightAction{
    [self makeScreenShotCompletion:^(UIImage *image) {
        
    }];
}

/**
 *  简单截屏并将图片保存到本地
 */
-(void)makeScreenShotCompletion:(void(^)(UIImage * image))completion{
    //开启上下文  <span style="font-family: Arial, Helvetica, sans-serif;">设置截屏大小</span>
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    completion(image);
    /**
     *  将图片保存到本地相册
     */
    UIImageWriteToSavedPhotosAlbum(image, self , @selector(image:didFinishSavingWithError:contextInfo:), nil);//保存图片到照片库
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        [self.view Message:@"保存成功" HiddenAfterDelay:1];
    }else{
        
    }
}




@end
