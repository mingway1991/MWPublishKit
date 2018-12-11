//
//  MWInputTextCell.h
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWInputTextCell : UICollectionViewCell

/** 获取文字内容 */
- (NSString *)text;

/** 设置文本内容 */
- (void)setText:(NSString *)text;

/** 设置字体 */
- (void)setFont:(UIFont *)font;

/** 设置字体颜色 */
- (void)setTextColor:(UIColor *)textColor;

/** 设置占位文字 */
- (void)setPlaceHolder:(NSString *)placeHolder;

/** 取消键盘响应 */
- (void)resignTextViewFisrtResponder;

@end

NS_ASSUME_NONNULL_END
