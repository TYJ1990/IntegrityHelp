//
//  OwnerHistoryModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/12.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class OwnerHistoryListModel;
@protocol OwnerHistoryListModel

@end

@interface OwnerHistoryModel : JSONModel

@property(nonatomic,strong) NSArray<OwnerHistoryListModel,Optional> *data;

@end


@interface OwnerHistoryListModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *Addtime;
@property(nonatomic,strong) NSString<Optional> *Content;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Uid;

@end
