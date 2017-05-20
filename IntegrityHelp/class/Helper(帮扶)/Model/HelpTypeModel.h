//
//  HelpTypeModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/3.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class HelpTypeListModel;

@protocol HelpTypeListModel

@end


@interface HelpTypeModel : JSONModel
@property(nonatomic,strong) NSArray<HelpTypeListModel,Optional> *data;

@end

@interface HelpTypeListModel : JSONModel
@property(nonatomic,strong) NSString<Optional> *Morder;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Name;
@property(nonatomic,strong) NSString<Optional> *Pid;

@end
