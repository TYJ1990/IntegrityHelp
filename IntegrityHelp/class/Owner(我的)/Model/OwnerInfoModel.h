//
//  OwnerInfoModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OwnerInfoModel : JSONModel
@property(nonatomic,strong) NSString <Optional>*u_avatar;
@property(nonatomic,strong) NSString <Optional>*u_card;
@property(nonatomic,strong) NSNumber <Optional>*u_id;
@property(nonatomic,strong) NSString <Optional>*u_name;
@property(nonatomic,strong) NSString <Optional>*u_phone;
@property(nonatomic,strong) NSString <Optional>*u_pwd;
@property(nonatomic,strong) NSString <Optional>*f_id_name;
@property(nonatomic,strong) NSString <Optional>*ff_id_name;
@property(nonatomic,strong) NSString <Optional>*u_regtime;
@property(nonatomic,strong) NSString <Optional>*u_profile;
@property(nonatomic,strong) NSString <Optional>*u_content;

@end
