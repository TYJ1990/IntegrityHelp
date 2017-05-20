//
//  HelperDetailView.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/4.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "Helper_DetailV.h"
#import "HelpDetailModel.h"
#import "SDPhotoBrowser.h"
#import "UIButton+WebCache.h"

@interface Helper_DetailV()<SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIScrollView *picView;
@property(nonatomic,strong) NSArray *photoItemArray;
@property(nonatomic,assign) NSInteger height;

@end

@implementation Helper_DetailV

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _statusImg.alpha = 0;
        _photoItemArray = [NSArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeight:) name:@"srollDown" object:nil];
    }
    return self;
}



- (void)initWithModel:(HelpDetailModel *)model{
    _username.text = model.Uname;
    _status.text = [Utils getStatus:[model.Status integerValue]];
    _title.text = model.Title;
    _content.text = model.Content;
    
    _statusImg.image = [UIImage imageNamed:[Utils getStatusImg:[model.Status integerValue]]];
    _statusImg.transform = CGAffineTransformMakeScale(2.5,2.5);
    [UIView animateWithDuration:0.5 animations:^{
        _statusImg.alpha = 1;
        _statusImg.transform = CGAffineTransformMakeScale(1.0,1.0);
    }];
    
    _photoItemArray = model.Pic;
    if (model.Pic.count > 0) {
        _picView.contentSize = CGSizeMake(85 * model.Pic.count, 70);
        for (int i = 0; i < model.Pic.count; i++) {
            [_picView addSubview:({
                UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                btn.frame = CGRectMake(10 + i * 85, 5, 80, 60);
                btn.tag = i + 100;
                [btn sd_setImageWithURL:[NSURL URLWithString:imageUrl(model.Pic[i])] forState:(UIControlStateNormal)];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
                btn;
            })];
        }
    }
}


- (void)buttonClick:(UIButton *)button
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = _picView; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = button.tag - 100;
    browser.delegate = self;
    browser.offHeight = -_height;
    [browser show];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIButton *btn = [_picView viewWithTag:100 + index];
    return btn.currentImage;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:imageUrl(self.photoItemArray[index])];
}


- (void)getHeight:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    _height = [dic[@"height"] integerValue];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"srollDown" object:nil];
}

@end
