//
//  OwnerPointModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/28.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class OwnerPointListModel;

@protocol OwnerPointListModel

@end


@interface OwnerPointModel : JSONModel
@property(nonatomic,strong) NSArray<OwnerPointListModel,Optional> *data;

@end

@interface OwnerPointListModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *Face;
@property(nonatomic,strong) NSString<Optional> *u_face;
@property(nonatomic,strong) NSString<Optional> *Name;
@property(nonatomic,strong) NSString<Optional> *Phone;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *point;

@end
