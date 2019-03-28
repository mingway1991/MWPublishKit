//
//  MWPublishView.m
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/20.
//

#import "MWPublishView.h"
#import "MWInputTextCell.h"
#import "MWImageCell.h"
#import "ZLPhotoActionSheet.h"
#import "ZLShowBigImgViewController.h"
#import "ZLPhotoModel.h"
#import "MWImageObject.h"
#import "MWMoreItemCell.h"
#import "MWMoreItem.h"
#import "MWDefines.h"
#import "MWImageHelper.h"
#import "MWDragImageTipsHeaderView.h"

@interface MWPublishView() <UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UICollectionViewDelegate> {
    NSMutableArray<MWImageObject *> *_selectImages;     //保存选择图片对象的数组
    CGFloat _imageItemWidth;                            //图片条目的宽度
    CGPoint _beginDragPoint;
}

@property (nonatomic, strong) MWInputTextCell *inputTextCell;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) UIButton *removeAreaButton;   //图片移除区域
@property (nonatomic, strong) ZLPhotoActionSheet *photoActionSheet;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation MWPublishView

- (instancetype)initWithFrame:(CGRect)frame
           moreItemDataSource:(id<MWPublishViewMoreItemDataSource>)moreItemDataSource
             moreItemDelegate:(id<MWPublishViewMoreItemDelegate>)moreItemDelegate {
    if (self = [super initWithFrame:frame]) {
        self.moreItemDataSource = moreItemDataSource;
        self.moreItemDelegate = moreItemDelegate;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentCollectionView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.removeAreaButton.frame = CGRectMake(0.f, CGRectGetHeight(self.bounds)-REMOVE_AREA_HEIGHT, CGRectGetWidth(self.bounds), REMOVE_AREA_HEIGHT);
}

- (void)setup {
    self.inputViewHeight = 150.f;
    self.leftRightMargin = 15.f;
    self.enablePreview = YES;
    self.clipsToBounds = YES;
    _selectImages = [NSMutableArray array];
    [self addSubview:self.contentCollectionView];
    [self addSubview:self.removeAreaButton];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewHandler:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Keyboard
- (void)tapViewHandler:(UITapGestureRecognizer*)tap {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [self.inputTextCell resignTextViewFisrtResponder];
}

#pragma mark - Public Methods
/* 设置默认图片 */
- (void)configSelectedImageObjects:(NSArray<MWImageObject *> *)imageObjects {
    [_selectImages addObjectsFromArray:imageObjects];
    [self updateSelectImages];
}

/* 设置默认文本 */
- (void)configInputText:(NSString *)inputText {
    [self.inputTextCell setText:inputText];
}

/* 获取选中的图片对象 */
- (NSArray<MWImageObject *> *)selectedImgObjects {
    return _selectImages;
}

/* 获取输入文字 */
- (NSString *)inputText {
    return self.inputTextCell.text;
}

/* 刷新更多条目 */
- (void)reloadMoreItems {
    [self.contentCollectionView reloadData];
}

#pragma mark - Setter
- (void)setLeftRightMargin:(CGFloat)leftRightMargin {
    _leftRightMargin = leftRightMargin;
    _imageItemWidth = floorf(([UIScreen mainScreen].bounds.size.width-2*leftRightMargin-2*DISTANCE_BETWEEN_IMAGES)/3.f);
    self.layout.sectionInset = UIEdgeInsetsMake(0, leftRightMargin, 0, leftRightMargin);
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    [self.inputTextCell setPlaceHolder:placeHolder];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self.inputTextCell setFont:textFont];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self.inputTextCell setTextColor:textColor];
}

- (void)setSender:(UIViewController *)sender {
    _sender = sender;
    self.photoActionSheet.sender = sender;
}

- (void)setNavBarColor:(UIColor *)navBarColor {
    _navBarColor = navBarColor;
    self.photoActionSheet.configuration.navBarColor = navBarColor;
}

- (void)setNavTitleColor:(UIColor *)navTitleColor {
    _navTitleColor = navTitleColor;
    self.photoActionSheet.configuration.navTitleColor = navTitleColor;
}

- (void)setBottomViewBgColor:(UIColor *)bottomViewBgColor {
    _bottomViewBgColor = bottomViewBgColor;
    self.photoActionSheet.configuration.bottomViewBgColor = bottomViewBgColor;
}

- (void)setBottomBtnsNormalTitleColor:(UIColor *)bottomBtnsNormalTitleColor {
    _bottomBtnsNormalTitleColor = bottomBtnsNormalTitleColor;
    self.photoActionSheet.configuration.bottomBtnsNormalTitleColor = bottomBtnsNormalTitleColor;
}

- (void)setBottomBtnsDisableBgColor:(UIColor *)bottomBtnsDisableBgColor {
    _bottomBtnsDisableBgColor = bottomBtnsDisableBgColor;
    self.photoActionSheet.configuration.bottomBtnsDisableBgColor = bottomBtnsDisableBgColor;
}

- (void)setCustomImageNames:(NSArray<NSString *> *)customImageNames {
    _customImageNames = customImageNames;
    self.photoActionSheet.configuration.customImageNames = customImageNames;
}

#pragma mark - Helper
/* 计算图片item个数（包含加号） */
- (NSInteger)calImageCollectionViewItemCount {
    NSInteger itemCount = 0;
    if (_selectImages.count < IMAGE_MAX_COUNT) {
        itemCount = _selectImages.count+1;
    } else {
        itemCount = IMAGE_MAX_COUNT;
    }
    return itemCount;
}

/* 跳转选择图片ActionSheet  */
- (void)selectImage {
    self.photoActionSheet.configuration.maxSelectCount = IMAGE_MAX_COUNT-_selectImages.count;
    //选择回调
    __weak typeof(_selectImages) weakSelectImages =_selectImages;
    __weak typeof(self) weakSelf = self;
    [self.photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        for (UIImage *image in images) {
            MWImageObject *obj = [[MWImageObject alloc] init];
            obj.type = MWImageObjectTypeImage;
            obj.contentObject = image;
            [weakSelectImages addObject:obj];
        }
        [weakSelf updateSelectImages];
    }];
    //调用相册
    if (self.enablePreview) {
        [self.photoActionSheet showPreviewAnimated:YES];
    } else {
        [self.photoActionSheet showPhotoLibrary];
    }
}

/* 更改选择图片数量 */
- (void)updateSelectImages {
    [self.contentCollectionView reloadData];
}

#pragma mark - LongPress
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:self.contentCollectionView];
    NSIndexPath *indexPath = [self.contentCollectionView indexPathForItemAtPoint:point];
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            [self hideKeyboard];
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            //开始移动
            if (@available(iOS 9.0, *)) {
                _beginDragPoint = point;
                self.removeAreaButton.hidden = NO;
                [self.contentCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            } else {
                // Fallback on earlier versions
            }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程中更新位置坐标
            if (@available(iOS 9.0, *)) {
                [self.contentCollectionView updateInteractiveMovementTargetPosition:point];
            } else {
                // Fallback on earlier versions
            }
            break;
        case UIGestureRecognizerStateEnded:
            //停止移动调用此方法
            if (@available(iOS 9.0, *)) {
                [self.contentCollectionView endInteractiveMovement];
                //判断位置是否在删除区域
                CGPoint location = [longPress locationInView:self];
                if (CGRectContainsPoint(self.removeAreaButton.frame, location)) {
                    NSIndexPath *indexPath = [self.contentCollectionView indexPathForItemAtPoint:_beginDragPoint];
                    if (indexPath) {
                        [_selectImages removeObjectAtIndex:indexPath.item];
                        [self.contentCollectionView reloadData];
                    }
                }
                self.removeAreaButton.hidden = YES;
            } else {
                // Fallback on earlier versions
            }
            break;
        default:
            //取消移动
            if (@available(iOS 9.0, *)) {
                self.removeAreaButton.hidden = YES;
                [self.contentCollectionView cancelInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
            break;
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //section 0 文本区
    //section 1 图片区
    //section 2 更多功能区
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self calImageCollectionViewItemCount];
    } else if (section == 2) {
        if (self.moreItemDataSource && [self.moreItemDataSource respondsToSelector:@selector(moreItemCount)]) {
            return [self.moreItemDataSource moreItemCount];
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0) {
        [self.inputTextCell setTextColor:_textColor];
        [self.inputTextCell setFont:_textFont];
        [self.inputTextCell setPlaceHolder:_placeHolder];
        return self.inputTextCell;
    } else if (section == 1) {
        MWImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        if (indexPath.item == _selectImages.count) {
            [cell updateUIWithAddImage];
        } else {
            [cell updateUIWithImageObject:_selectImages[item]];
        }
        return cell;
    } else if (section == 2) {
        MWMoreItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreItemCell" forIndexPath:indexPath];
        [cell updateUIWithMoreItem:[self.moreItemDataSource moreItemForRow:item] isFirst:item == 0 ? YES : NO];
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"blankCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if (section == 0) {
        
    } else if (section == 1) {
        if (item == _selectImages.count) {
            //进入选择图片
            [self selectImage];
        } else {
            //预览图片
            NSMutableArray *models = [NSMutableArray arrayWithCapacity:_selectImages.count];
            for (MWImageObject *imgObject in _selectImages) {
                if (imgObject.type == MWImageObjectTypeUrl) {
                    [models addObject:GetDictForPreviewPhoto(imgObject.contentObject, ZLPreviewPhotoTypeURLImage)];
                } else if (imgObject.type == MWImageObjectTypeImage) {
                    [models addObject:GetDictForPreviewPhoto(imgObject.contentObject, ZLPreviewPhotoTypeUIImage)];
                }
            }
            __weak typeof(_selectImages) weakSelectImages =_selectImages;
            __weak typeof(self) weakSelf = self;
            ZLPhotoActionSheet *photoActionSheet = [self photoActionSheet];
            [photoActionSheet previewPhotos:models index:indexPath.row hideToolBar:NO complete:^(NSArray * _Nonnull photos) {
                [weakSelectImages removeAllObjects];
                for (NSDictionary *dict in photos) {
                    MWImageObject *imageObj = [[MWImageObject alloc] init];
                    imageObj.contentObject = dict[ZLPreviewPhotoObj];
                    if ([dict[ZLPreviewPhotoTyp] integerValue] == ZLPreviewPhotoTypeUIImage) {
                        imageObj.type = MWImageObjectTypeImage;
                    } else if ([dict[ZLPreviewPhotoTyp] integerValue] == ZLPreviewPhotoTypeURLImage) {
                        imageObj.type = MWImageObjectTypeUrl;
                    }
                    [weakSelectImages addObject:imageObj];
                }
                [weakSelf updateSelectImages];
            }];
        }
    } else if (section == 2) {
        if ([self.moreItemDelegate respondsToSelector:@selector(clickItemForMoreItem:row:)]) {
            [self.moreItemDelegate clickItemForMoreItem:[self.moreItemDataSource moreItemForRow:item] row:item];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width-2*self.leftRightMargin, self.inputViewHeight);
    } else if (section == 1) {
        return CGSizeMake(_imageItemWidth, _imageItemWidth);
    } else if (section == 2) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width-2*self.leftRightMargin, MORE_ITEM_CELL_HEIGHT);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (section == 1) {
            MWDragImageTipsHeaderView *tipsHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"tipsHeader" forIndexPath:indexPath];
            return tipsHeader;
        }
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *tipsFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"tipsFooter" forIndexPath:indexPath];
        return tipsFooter;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), IMAGE_TIPS_HEIGHT);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), DISTANCE_BETWEEN_TEXTVIEW_AND_IMAGE);
    } else if (section == 1) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), DISTANCE_BETWEEN_IMAGE_AND_MOREITEMS);
    } else if (section == 2) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), DISTANCE_BOTTOM_MARGIN);
    }
    return CGSizeZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 1 && indexPath.item != _selectImages.count) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    /* 交换资源数组中移动item和目标位置item的资源位置 */
    id objc = [_selectImages objectAtIndex:sourceIndexPath.item];
    [_selectImages removeObject:objc];
    [_selectImages insertObject:objc atIndex:destinationIndexPath.item];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    /* 可以指定位置禁止交换 */
    if (proposedIndexPath.section == 1 && proposedIndexPath.item != _selectImages.count) {
        return proposedIndexPath;
    } else {
        return originalIndexPath;
    }
}

#pragma mark - LazyLoad
- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumLineSpacing = DISTANCE_BETWEEN_IMAGES;
        self.layout.minimumInteritemSpacing = DISTANCE_BETWEEN_IMAGES;
        self.layout.sectionInset = UIEdgeInsetsMake(0, self.leftRightMargin, 0, self.leftRightMargin);
        self.contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:self.layout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.clipsToBounds = NO;
        _contentCollectionView.alwaysBounceVertical = YES;
        [_contentCollectionView registerClass:[MWInputTextCell class] forCellWithReuseIdentifier:@"textCell"];
        [_contentCollectionView registerClass:[MWImageCell class] forCellWithReuseIdentifier:@"imageCell"];
        [_contentCollectionView registerClass:[MWMoreItemCell class] forCellWithReuseIdentifier:@"moreItemCell"];
        [_contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"blankCell"];
        [_contentCollectionView registerClass:[MWDragImageTipsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"tipsHeader"];
        [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"tipsFooter"];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [_contentCollectionView addGestureRecognizer:longPressGesture];
    }
    return _contentCollectionView;
}

- (ZLPhotoActionSheet *)photoActionSheet {
    if (!_photoActionSheet) {
        self.photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        _photoActionSheet.configuration.maxPreviewCount = 10;
        if (self.sender) {
            _photoActionSheet.sender = self.sender;
        }
        _photoActionSheet.configuration.allowSelectVideo = NO;
        _photoActionSheet.configuration.allowSelectGif = YES;
        _photoActionSheet.configuration.allowSelectOriginal = YES;
        _photoActionSheet.configuration.languageType = ZLLanguageChineseSimplified;
        _photoActionSheet.configuration.allowRecordVideo = NO;
        if (self.navBarColor) {
            _photoActionSheet.configuration.navBarColor = self.navBarColor;
        }
        if (self.navTitleColor) {
            _photoActionSheet.configuration.navTitleColor = self.navTitleColor;
        }
        if (self.bottomViewBgColor) {
            _photoActionSheet.configuration.bottomViewBgColor = self.bottomViewBgColor;
        }
        if (self.bottomBtnsNormalTitleColor) {
            _photoActionSheet.configuration.bottomBtnsNormalTitleColor = self.bottomBtnsNormalTitleColor;
        }
        if (self.bottomBtnsDisableBgColor) {
            _photoActionSheet.configuration.bottomBtnsDisableBgColor = self.bottomBtnsDisableBgColor;
        }
        if (self.customImageNames) {
            _photoActionSheet.configuration.customImageNames = self.customImageNames;
        }
    }
    return _photoActionSheet;
}

- (UIView *)removeAreaButton {
    if (!_removeAreaButton) {
        self.removeAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeAreaButton.hidden = YES;
        _removeAreaButton.backgroundColor = [UIColor colorWithRed:210/225.f green:50/225.f blue:50/225.f alpha:1.0];
        _removeAreaButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_removeAreaButton setImage:[MWImageHelper loadImageWithName:@"remove"] forState:UIControlStateNormal];
        [_removeAreaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_removeAreaButton setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
        
        /** 设置图片文字上下样式 */
        CGFloat space = 5.f;    //图片与文字间距
        
        CGFloat imageWith = _removeAreaButton.imageView.image.size.width;
        CGFloat imageHeight = _removeAreaButton.imageView.image.size.height;
        CGFloat labelWidth = _removeAreaButton.titleLabel.intrinsicContentSize.width;
        CGFloat labelHeight = _removeAreaButton.titleLabel.intrinsicContentSize.height;
        
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        _removeAreaButton.titleEdgeInsets = labelEdgeInsets;
        _removeAreaButton.imageEdgeInsets = imageEdgeInsets;
    }
    return _removeAreaButton;
}

- (MWInputTextCell *)inputTextCell {
    if (!_inputTextCell) {
        self.inputTextCell = [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:@"textCell" forIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return _inputTextCell;
}

@end
