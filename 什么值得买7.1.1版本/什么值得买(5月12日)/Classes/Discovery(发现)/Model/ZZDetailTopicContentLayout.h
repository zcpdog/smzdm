//
//  ZZDetailTopicContentLayout.h
//  什么值得买
//
//  Created by Wang_ruzhou on 16/9/13.
//  Copyright © 2016年 Wang_ruzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZDetailTopicModel.h"

#define kDetailTopicMarginX  15                    /**< 整个内容, 左右间距 */
#define kDetailTopicMarginY  15                    /**< 整个内容, 上下间距 */
#define kDetailTopicContentOffsetX 15           /**< 内容偏移, 左右 */
#define kDetailTopicContentOffsetY 15           /**< 内容偏移, 上下 */
#define kDetailTopicContentTopMargin 15         /**< 内容顶部留白 */
#define kDetailTopicContentAvartarWH 70         /**< 头像宽高 */
#define kDetailTopicUserInfoWidth 150             /**< 用户信息宽 */
#define kDetailTopicUserInfoMarginX 8           /**< 用户信息左右留白 */
#define kDetailTopicUserInfoMarginY 8           /**< 用户信息上下留白 */
#define kDetailTopicProPicWH 100                /**< 配图大小 */
#define kDetailTopicTitleLeftMargin  30         /**< 标题左间距 */
#define kDetailTopicDescTopMargin 15            /**< 文字描述顶部留白 */
#define kDetailTopicDescHeight 120              /**< 文字描述高度 */
#define kDetailTopicDescWidth (kScreenW - 2 * kDetailContentOffset) /**< 文字描述宽 */
#define kDetailTopicUseTimeY 15                 /**< 使用时长上下留白 */
#define kDetailTopicSmallBtnWidth   30          /**< 小按钮宽 */
#define kDetailTopicSmallBtnMargin   30          /**< 按钮间间距 */

@interface ZZDetailTopicContentLayout : NSObject
/** 头像高度 */
@property (nonatomic, assign) CGFloat avatarViewHeight;

@property (nonatomic, strong) YYTextLayout *userInfoLayout;
@property (nonatomic, assign) CGFloat userInfoHeight;
/** 标题 和 价格 */
@property (nonatomic, strong) YYTextLayout *titleLayout;

/** 推荐原因, 副标题 + 文本内容 */
@property (nonatomic, strong) YYTextLayout *descriptionLayout;
@property (nonatomic, assign) CGFloat descriptionHeight;
/** 用户上传图片数 */
@property (nonatomic, strong) YYTextLayout *picCountLayout;
/** 评论数 */
@property (nonatomic, strong) YYTextLayout *commentCountLayout;
/** 使用时长 */
@property (nonatomic, strong) YYTextLayout *useTimeLayout;
@property (nonatomic, assign) CGFloat useTimeHeight;

@property (nonatomic, strong) ZZDetailTopicModel *detailTopicModel;
@property (nonatomic, assign) CGFloat height;
- (instancetype)initWithContentDetailModel:(ZZDetailTopicModel *)detailTopicModel;
//计算布局
- (void)layout;

@end
