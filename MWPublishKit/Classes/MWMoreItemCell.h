//
//  MWMoreItemCell.h
//  GPUImage
//
//  Created by 石茗伟 on 2018/8/21.
//

#import <UIKit/UIKit.h>
@class MWMoreItem;

@interface MWMoreItemCell : UITableViewCell

- (void)updateUIWithMoreItem:(MWMoreItem *)moreItem isFirst:(BOOL)isFirst;

@end
