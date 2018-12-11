//
//  MWMoreItemCell.m
//  GPUImage
//
//  Created by 石茗伟 on 2018/8/21.
//

#import "MWMoreItemCell.h"
#import "MWMoreItem.h"
#import "MWDefines.h"

@interface MWMoreItemCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation MWMoreItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.bottomLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect topLineFrame = self.topLineView.frame;
    topLineFrame.size.width = self.bounds.size.width;
    self.topLineView.frame = topLineFrame;
    
    CGRect bottomLineFrame = self.bottomLineView.frame;
    bottomLineFrame.size.width = self.bounds.size.width;
    bottomLineFrame.origin.y = self.bounds.size.height - bottomLineFrame.size.height;
    self.bottomLineView.frame = bottomLineFrame;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.width = self.bounds.size.width-CGRectGetMaxX(self.iconImageView.frame)-10.f;
    self.titleLabel.frame = titleFrame;
}

- (void)updateUIWithMoreItem:(MWMoreItem *)moreItem isFirst:(BOOL)isFirst {
    self.topLineView.hidden = !isFirst;
    if (moreItem.isSelected) {
        self.iconImageView.image = moreItem.selectedIconImage;
        self.titleLabel.text = moreItem.selectedTitle;
        self.titleLabel.textColor = moreItem.selectedTitleColor;
    } else {
        self.iconImageView.image = moreItem.normalIconImage;
        self.titleLabel.text = moreItem.normalTitle;
        self.titleLabel.textColor = moreItem.normalTitleColor;
    }
    self.titleLabel.font = moreItem.titleFont;
}

#pragma mark - LazyLoad
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        CGFloat width = 18.f;
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, (MORE_ITEM_CELL_HEIGHT-width)/2.f, width, width)];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+5.f, 0.f, self.bounds.size.width-CGRectGetMaxX(self.iconImageView.frame)-5.f, MORE_ITEM_CELL_HEIGHT)];
    }
    return _titleLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, .5f)];
        _topLineView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, self.bounds.size.height-.5f, self.bounds.size.width, .5f)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    return _bottomLineView;
}

@end
