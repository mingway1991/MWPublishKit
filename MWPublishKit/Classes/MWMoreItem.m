//
//  MWMoreItem.m
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/21.
//

#import "MWMoreItem.h"

@implementation MWMoreItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSelected = NO;
        self.normalTitleColor = [UIColor blackColor];
        self.selectedTitleColor = [UIColor greenColor];
        self.titleFont = [UIFont systemFontOfSize:16.f];
    }
    return self;
}

@end
