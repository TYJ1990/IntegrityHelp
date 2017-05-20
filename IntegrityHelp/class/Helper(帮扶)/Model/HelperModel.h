//
//  HelperModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class HelperListModel;

@protocol HelperListModel

@end



@interface HelperModel : JSONModel

@property(nonatomic,strong)NSMutableArray <HelperListModel,Optional>*data;

@end


@interface HelperListModel : JSONModel
@property(nonatomic,strong) NSNumber <Optional>*Addtime;
@property(nonatomic,strong) NSString <Optional>*Content;
@property(nonatomic,strong) NSString <Optional>*Id;
@property(nonatomic,strong) NSNumber <Optional>*Status;
@property(nonatomic,strong) NSString <Optional>*T_name;
@property(nonatomic,strong) NSString <Optional>*Title;
@property(nonatomic,strong) NSString <Optional>*U_name;
@property(nonatomic,strong) NSString <Optional>*Pic1;

@end
