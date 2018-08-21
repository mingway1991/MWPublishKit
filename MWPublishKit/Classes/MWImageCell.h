//
//  MWImageCell.h
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/20.
//

#import <UIKit/UIKit.h>
@class MWImageObject;

@interface MWImageCell : UICollectionViewCell

/* 更新图片UI */
- (void)updateUIWithImageObject:(MWImageObject *)imageObject;
/* 更新添加图片UI */
- (void)updateUIWithAddImage;

@end
