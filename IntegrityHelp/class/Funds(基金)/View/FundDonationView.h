//
//  FundDonationView.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/19.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundDonationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *twentyBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiftyBtn;
@property (weak, nonatomic) IBOutlet UIView *otherNum;
@property (weak, nonatomic) IBOutlet UITextField *otherTF;
@property (weak, nonatomic) IBOutlet UIButton *donationBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeProticol;
@property (weak, nonatomic) IBOutlet UIButton *proticolBtn;
@property (weak, nonatomic) IBOutlet UIImageView *otherImg;
@property (weak, nonatomic) IBOutlet UIImageView *twentyImg;
@property (weak, nonatomic) IBOutlet UIImageView *fiftyImg;

@end
