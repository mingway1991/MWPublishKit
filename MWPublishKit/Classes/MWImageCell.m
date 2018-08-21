//
//  MWImageCell.m
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/20.
//

#import "MWImageCell.h"
#import "UIImageView+WebCache.h"
#import "MWImageObject.h"

@interface MWImageCell()

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIImageView *addImageView;

@end

@implementation MWImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.showImageView];
        [self.contentView addSubview:self.addImageView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.showImageView.image = nil;
}

- (void)updateUIWithImageObject:(MWImageObject *)imageObject {
    self.showImageView.hidden = NO;
    self.addImageView.hidden = YES;
    if (imageObject.type == MWImageObjectTypeImage) {
        self.showImageView.image = imageObject.contentObject;
    } else if (imageObject.type == MWImageObjectTypeUrl) {
        [self.showImageView sd_setImageWithURL:imageObject.contentObject];
    }
}

- (void)updateUIWithAddImage {
    self.showImageView.hidden = YES;
    self.addImageView.hidden = NO;
}

#pragma mark - LazyLoad
- (UIImageView *)showImageView {
    if (!_showImageView) {
        self.showImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _showImageView;
}

- (UIImageView *)addImageView {
    if (!_addImageView) {
        self.addImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        UIImage *image = [UIImage imageNamed:@"add" inBundle:bundle compatibleWithTraitCollection:nil];
        _addImageView.image = image;
    }
    return _addImageView;
}

@end
