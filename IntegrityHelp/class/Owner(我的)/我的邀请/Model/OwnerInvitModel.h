//
//  OwnerInvitModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class OwnerInvitListModel;

@protocol OwnerInvitListModel

@end



@interface OwnerInvitModel : JSONModel

@property(nonatomic,strong) NSArray<OwnerInvitListModel,Optional> *data;
@end


@interface OwnerInvitListModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *Qrcode;
@property(nonatomic,strong) NSNumber<Optional> *Addtime;
@property(nonatomic,strong) NSString<Optional> *Code;
@property(nonatomic,strong) NSNumber<Optional> *Id;
@property(nonatomic,strong) NSNumber<Optional> *Uid;
@property(nonatomic,strong) NSNumber<Optional> *Isshow;

@end
