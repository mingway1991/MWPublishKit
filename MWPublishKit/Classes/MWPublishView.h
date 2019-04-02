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

/* 输入文本区域高度，默认150 */
@property (nonatomic, assign) CGFloat inputViewHeight;
/* 左右间距，默认15 */
@property (nonatomic, assign) CGFloat leftRightMargin;
/* 文本占位文字 */
@property (nonatomic, copy, setter=setPlaceHolder:) NSString *placeHolder;
/* 文本占位文字颜色，默认[UIColor lightGrayColor] */
@property (nonatomic, strong, setter=setPlaceHolderColor:) UIColor *placeHolderColor;
/* 文字字体，默认[UIFont systemFontOfSize:16.f] */
@property (nonatomic, strong, setter=setTextFont:) UIFont *textFont;
/* 文字颜色 */
@property (nonatomic, strong, setter=setTextColor:) UIColor *textColor;
/* 删除区域高度， 默认60 */
@property (nonatomic, assign) CGFloat removeAreaHeight;
/* 更多选项数据源 */
@property (nonatomic, weak) id<MWPublishViewMoreItemDataSource> moreItemDataSource;
/* 更多选项代理 */
@property (nonatomic, weak) id<MWPublishViewMoreItemDelegate> moreItemDelegate;
/* 图片选择器需要，传当前控制器即可 */
@property (nonatomic, weak) UIViewController *sender;
/* 导航条颜色，默认 rgb(19, 153, 231) */
@property (nonatomic, strong) UIColor *navBarColor;
/* 导航标题颜色，默认 rgb(255, 255, 255) */
@property (nonatomic, strong) UIColor *navTitleColor;
/* 底部工具条底色，默认 rgb(255, 255, 255) */
@property (nonatomic, strong) UIColor *bottomViewBgColor;
/* 底部工具栏按钮 可交互 状态标题颜色，底部 toolbar 按钮可交互状态title颜色均使用这个，确定按钮 可交互 的背景色为这个，默认rgb(80, 180, 234) */
@property (nonatomic, strong) UIColor *bottomBtnsNormalTitleColor;
/* 底部工具栏按钮 不可交互 状态标题颜色，底部 toolbar 按钮不可交互状态颜色均使用这个，确定按钮 不可交互 的背景色为这个，默认rgb(200, 200, 200) */
@property (nonatomic, strong) UIColor *bottomBtnsDisableBgColor;
/* 支持开发者自定义图片，但是所自定义图片资源名称必须与被替换的bundle中的图片名称一致 */
@property (nonatomic, strong) NSArray<NSString *> *customImageNames;
/* 是否支持预览前几张图片 */
@property (nonatomic, assign) BOOL enablePreview;

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
