//
//  MWDragImageTipsHeaderView.m
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/12/12.
//

#import "MWDragImageTipsHeaderView.h"
#import "MWImageHelper.h"
#import "MWDefines.h"

@interface MWDragImageTipsHeaderView ()

@property (nonatomic, strong) UIImageView *tipsImageView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation MWDragImageTipsHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.tipsImageView];
    [self addSubview:self.tipsLabel];
}

#pragma mark - LazyLoad
- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        CGFloat itemHeight = 16.f;
        self.tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 5.f, itemHeight, itemHeight)];
        _tipsImageView.image = [MWImageHelper loadImageWithName:@"tips"];
    }
    return _tipsImageView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        CGRect frame = self.bounds;
        frame.origin.x = CGRectGetMaxX(self.tipsImageView.frame) + 3.f;
        frame.origin.y = 5.f;
        frame.size.height = CGRectGetHeight(self.tipsImageView.bounds);
        self.tipsLabel = [[UILabel alloc] initWithFrame:frame];
        _tipsLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        _tipsLabel.font = [UIFont systemFontOfSize:12.f];
        _tipsLabel.text = @"长按并拖拽图片可改变顺序";
    }
    return _tipsLabel;
}

@end
