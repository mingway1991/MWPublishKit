//
//  MWMoreItem.h
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/21.
//

#import <Foundation/Foundation.h>

@interface MWMoreItem : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *selectedTitle;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIImage *normalIconImage;
@property (nonatomic, strong) UIImage *selectedIconImage;
@property (nonatomic, strong) UIFont *titleFont;


@end
