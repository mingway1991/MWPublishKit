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

@end

@implementation MWMoreItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.width = self.bounds.size.width-CGRectGetMaxX(self.iconImageView.frame)-10.f;
    self.titleLabel.frame = titleFrame;
}

- (void)updateUIWithMoreItem:(MWMoreItem *)moreItem {
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
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 12.f, MORE_ITEM_CELL_HEIGHT-24.f, MORE_ITEM_CELL_HEIGHT-24.f)];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+5.f, 0.f, self.bounds.size.width-CGRectGetMaxX(self.iconImageView.frame)-5.f, MORE_ITEM_CELL_HEIGHT)];
    }
    return _titleLabel;
}

@end
