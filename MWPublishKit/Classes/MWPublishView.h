//
//  MWPublishView.h
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/20.
//

#import <UIKit/UIKit.h>
@class MWImageObject;
@class MWMoreItem;

@protocol MWPublishViewMoreItemDataSource <NSObject>

@required
/* 条目个数 */
- (NSInteger)moreItemCount;
/* 每一行条目信息 */
- (MWMoreItem *)moreItemForRow:(NSInteger)row;

@end

@protocol MWPublishViewMoreItemDelegate <NSObject>

@optional
/* 选中条目方法 */
- (void)clickItemForMoreItem:(MWMoreItem *)moreItem row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MWPublishView : UIView

/* 文本占位文字 */
@property (nonatomic, copy, setter=setPlaceHolder:)NSString *placeHolder;
/* 文字字体 */
@property (nonatomic, strong, setter=setTextFont:)UIFont *textFont;
/* 文字颜色 */
@property (nonatomic, strong, setter=setTextColor:)UIColor *textColor;
/* 更多选项数据源 */
@property (nonatomic, weak) id<MWPublishViewMoreItemDataSource> moreItemDataSource;
/* 更多选项代理 */
@property (nonatomic, weak) id<MWPublishViewMoreItemDelegate> moreItemDelegate;

#pragma mark - init
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame
           moreItemDataSource:(id<MWPublishViewMoreItemDataSource>)moreItemDataSource
             moreItemDelegate:(id<MWPublishViewMoreItemDelegate>)moreItemDelegate NS_DESIGNATED_INITIALIZER;

#pragma mark - public methods
/* 配置选中图片对象 */
- (void)configSelectedImageObjects:(NSArray<MWImageObject *> *)imageObjects;
/* 配置默认文本 */
- (void)configInputText:(NSString *)inputText;
/* 获取选中的图片对象 */
- (NSArray<MWImageObject *> *)selectedImgObjects;
/* 获取输入文字 */
- (NSString *)inputText;
/* 刷新更多条目 */
- (void)reloadMoreItems;

@end

NS_ASSUME_NONNULL_END
