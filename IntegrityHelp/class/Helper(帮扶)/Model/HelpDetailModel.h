//
//  HelpDetailModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/4.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class HelpDetailListModel;

@protocol HelpDetailListModel

@end




@interface HelpDetailModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *Addtime;
@property(nonatomic,strong) NSString<Optional> *Comment;
@property(nonatomic,strong) NSString<Optional> *Content;
@property(nonatomic,strong) NSString<Optional> *F_id;
@property(nonatomic,strong) NSString<Optional> *F_id_face;
@property(nonatomic,strong) NSString<Optional> *F_id_name;
@property(nonatomic,strong) NSString<Optional> *F_no;
@property(nonatomic,strong) NSString<Optional> *F_pic;
@property(nonatomic,strong) NSString<Optional> *F_review;
@property(nonatomic,strong) NSString<Optional> *F_time;
@property(nonatomic,strong) NSString<Optional> *Ff_id;
@property(nonatomic,strong) NSString<Optional> *Ff_id_face;
@property(nonatomic,strong) NSString<Optional> *Ff_id_name;
@property(nonatomic,strong) NSString<Optional> *Ff_no;
@property(nonatomic,strong) NSString<Optional> *Ff_pic;
@property(nonatomic,strong) NSString<Optional> *Ff_review;
@property(nonatomic,strong) NSString<Optional> *Ff_time;
@property(nonatomic,strong) NSString<Optional> *Finishtime;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Ptype;
@property(nonatomic,strong) NSString<Optional> *T_name;
@property(nonatomic,strong) NSString<Optional> *Star;
@property(nonatomic,strong) NSString<Optional> *Status;
@property(nonatomic,strong) NSString<Optional> *Tid;
@property(nonatomic,strong) NSString<Optional> *Title;
@property(nonatomic,strong) NSString<Optional> *Ty;
@property(nonatomic,strong) NSString<Optional> *Uid;
@property(nonatomic,strong) NSString<Optional> *Uname;
@property(nonatomic,strong) NSString<Optional> *U_name;
@property(nonatomic,strong) NSString<Optional> *face;
@property(nonatomic,strong) NSArray<HelpDetailListModel,Optional> *list;
@property(nonatomic,strong) NSString<Optional> *Tid_face;
@property(nonatomic,strong) NSString<Optional> *Tid_name;
@property(nonatomic,strong) NSString<Optional> *Tid_time;
@property(nonatomic,strong) NSArray<Optional> *Pic;


@end

@interface HelpDetailListModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *Addtime;
@property(nonatomic,strong) NSString<Optional> *Content;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *P_id;
@property(nonatomic,strong) NSString<Optional> *Uid;
@property(nonatomic,strong) NSString<Optional> *face;
@property(nonatomic,strong) NSString<Optional> *id;
@property(nonatomic,strong) NSString<Optional> *name;


@end




