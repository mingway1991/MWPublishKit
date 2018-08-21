//
//  MWPublishView.m
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/20.
//

#import "MWPublishView.h"
#import "MWImageCell.h"
#import "ZLPhotoActionSheet.h"
#import "ZLShowBigImgViewController.h"
#import "ZLPhotoModel.h"
#import "MWImageObject.h"
#import "MWMoreItemCell.h"
#import "MWMoreItem.h"
#import "MWDefines.h"

@interface MWPublishView() <UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UICollectionViewDelegate,
                            UITextViewDelegate,
                            UITableViewDataSource,
                            UITableViewDelegate>
{
    NSMutableArray<MWImageObject *> *_selectImages;     //保存选择图片对象的数组
    CGFloat _imageItemWidth;                            //图片条目的宽度
}
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) UITableView *moreTableView;

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

- (void)setup {
    _selectImages = [NSMutableArray array];
    [self addSubview:self.bgScrollView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Keyboard
- (void)keyboardHide:(UITapGestureRecognizer*)tap {
    [self.inputTextView resignFirstResponder];
}

#pragma mark - Public Methods
/* 设置默认图片 */
- (void)configSelectedImageObjects:(NSArray<MWImageObject *> *)imageObjects {
    [_selectImages addObjectsFromArray:imageObjects];
    [self updateSelectImages];
}

/* 设置默认文本 */
- (void)configInputText:(NSString *)inputText {
    self.inputTextView.text = inputText;
    [self updatePlaceHolderStateWithText:inputText];
}

/* 获取选中的图片对象 */
- (NSArray<MWImageObject *> *)selectedImgObjects {
    return _selectImages;
}

/* 获取输入文字 */
- (NSString *)inputText {
    return self.inputTextView.text;
}

- (void)reloadMoreItems {
    [self updateMoreItems];
}

#pragma mark - Setter
/* 设置placeHolder文本 */
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
    self.placeHolderLabel.frame = self.inputTextView.bounds;
    [self.placeHolderLabel sizeToFit];
}

/* 设置文本字体 */
- (void)setTextFont:(UIFont *)textFont {
    self.placeHolderLabel.font = textFont;
    self.inputTextView.font = textFont;
    self.placeHolderLabel.frame = self.inputTextView.bounds;
    [self.placeHolderLabel sizeToFit];
}

/* 设置文本颜色 */
- (void)setTextColor:(UIColor *)textColor {
    self.inputTextView.textColor = textColor;
}

#pragma mark - Helper
/* 计算图片item个数（包含加号） */
- (NSInteger)calImageCollectionViewItemCount {
    NSInteger itemCount = 0;
    if (_selectImages.count < 9) {
        itemCount = _selectImages.count+1;
    } else {
        itemCount = 9;
    }
    return itemCount;
}

/* 计算image collection view高度 */
- (CGFloat)calImageCollectionViewHeight {
    NSInteger itemCount = [self calImageCollectionViewItemCount];
    NSInteger lineNum = 0;
    if (itemCount % 3 == 0) {
        lineNum = itemCount/3;
    } else {
        lineNum = itemCount/3+1;
    }
    return lineNum*(_imageItemWidth+10.f);
}

/* 跳转选择图片ActionSheet  */
- (void)selectImage {
    ZLPhotoActionSheet *photoActionSheet = [self photoActionSheet];
    photoActionSheet.configuration.maxSelectCount = 9-_selectImages.count;
    //选择回调
    __weak typeof(_selectImages) weakSelectImages =_selectImages;
    __weak typeof(self) weakSelf = self;
    [photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        for (UIImage *image in images) {
            MWImageObject *obj = [[MWImageObject alloc] init];
            obj.type = MWImageObjectTypeImage;
            obj.contentObject = image;
            [weakSelectImages addObject:obj];
        }
        [weakSelf updateSelectImages];
    }];
    //调用相册
    [photoActionSheet showPreviewAnimated:YES];
}

/* 根据文本处理placeHolderLabel的显示与隐藏 */
- (void)updatePlaceHolderStateWithText:(NSString *)text {
    if (text.length == 0) {
        self.placeHolderLabel.alpha = 1;
    } else {
        self.placeHolderLabel.alpha = 0;
    }
}

/* 更新scrollView contentsize */
- (void)updateScrollViewContentSize {
    self.bgScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bgScrollView.bounds), CGRectGetMaxY(self.inputTextView.frame)+[self calImageCollectionViewHeight]+[self.moreItemDataSource moreItemCount]*MORE_ITEM_CELL_HEIGHT+BOTTOM_PADDING);
}

/* 更改选择图片数量 */
- (void)updateSelectImages {
    CGRect imageFrame = self.imageCollectionView.frame;
    imageFrame.size.height = [self calImageCollectionViewHeight];
    self.imageCollectionView.frame = imageFrame;
    [self.imageCollectionView reloadData];
    [self updateMoreItems];
}

/* 更改更多选项 */
- (void)updateMoreItems {
    CGRect moreFrame = self.moreTableView.frame;
    moreFrame.origin.y = CGRectGetMaxY(self.imageCollectionView.frame);
    moreFrame.size.height = [self.moreItemDataSource moreItemCount]*MORE_ITEM_CELL_HEIGHT;
    self.moreTableView.frame = moreFrame;
    [self.moreTableView reloadData];
    [self updateScrollViewContentSize];
}

#pragma mark - LongPress
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:self.imageCollectionView];
    NSIndexPath *indexPath = [self.imageCollectionView indexPathForItemAtPoint:point];
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            //开始移动
            if (@available(iOS 9.0, *)) {
                [self.imageCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            } else {
                // Fallback on earlier versions
            }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程中更新位置坐标
            if (@available(iOS 9.0, *)) {
                [self.imageCollectionView updateInteractiveMovementTargetPosition:point];
            } else {
                // Fallback on earlier versions
            }
            break;
        case UIGestureRecognizerStateEnded:
            //停止移动调用此方法
            if (@available(iOS 9.0, *)) {
                [self.imageCollectionView endInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
            break;
        default:
            //取消移动
            if (@available(iOS 9.0, *)) {
                [self.imageCollectionView cancelInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
            break;
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self calImageCollectionViewItemCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MWImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    if (indexPath.item == _selectImages.count) {
        [cell updateUIWithAddImage];
    } else {
        [cell updateUIWithImageObject:_selectImages[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectImages.count) {
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
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_imageItemWidth, _imageItemWidth);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item != _selectImages.count) {
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
    if (proposedIndexPath.item == _selectImages.count) {
        return originalIndexPath;
    } else {
        return proposedIndexPath;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updatePlaceHolderStateWithText:textView.text];
}

#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.moreItemDataSource && [self.moreItemDataSource respondsToSelector:@selector(moreItemCount)]) {
        return [self.moreItemDataSource moreItemCount];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MORE_ITEM_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MWMoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
    if (!cell) {
        cell = [[MWMoreItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
    }
    [cell updateUIWithMoreItem:[self.moreItemDataSource moreItemForRow:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.moreItemDelegate respondsToSelector:@selector(clickItemForMoreItem:row:)]) {
        [self.moreItemDelegate clickItemForMoreItem:[self.moreItemDataSource moreItemForRow:indexPath.row] row:indexPath.row];
    }
}

#pragma mark - LazyLoad
- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_bgScrollView addSubview:self.inputTextView];
        _imageItemWidth = ((CGRectGetWidth(_bgScrollView.bounds)-2*PADDING)-10.f)/3.f;
        [_bgScrollView addSubview:self.imageCollectionView];
        [_bgScrollView addSubview:self.moreTableView];
    }
    return _bgScrollView;
}

- (UITextView *)inputTextView {
    if (!_inputTextView) {
        self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(PADDING, 10.f, CGRectGetWidth(self.bgScrollView.bounds)-2*PADDING, INPUT_VIEW_HEIGHT)];
        _inputTextView.font = [UIFont systemFontOfSize:16.f];
        _inputTextView.delegate = self;
        _inputTextView.contentInset = UIEdgeInsetsZero;
        _inputTextView.textContainer.lineFragmentPadding = 0;
        _inputTextView.textContainerInset = UIEdgeInsetsZero;
        [_inputTextView addSubview:self.placeHolderLabel];
    }
    return _inputTextView;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        self.placeHolderLabel = [[UILabel alloc] initWithFrame:self.inputTextView.bounds];
        _placeHolderLabel.font = self.inputTextView.font;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.text = @"请输入内容";
        _placeHolderLabel.numberOfLines = 0;
        [_placeHolderLabel sizeToFit];
    }
    return _placeHolderLabel;
}

- (UICollectionView *)imageCollectionView {
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.f;
        layout.minimumInteritemSpacing = 5.f;
        self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(PADDING, CGRectGetMaxY(self.inputTextView.frame)+10.f, CGRectGetWidth(self.inputTextView.frame), [self calImageCollectionViewHeight]) collectionViewLayout:layout];
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        _imageCollectionView.clipsToBounds = NO;
        _imageCollectionView.bounces = NO;
        [_imageCollectionView registerClass:[MWImageCell class] forCellWithReuseIdentifier:@"imageCell"];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [_imageCollectionView addGestureRecognizer:longPressGesture];
    }
    return _imageCollectionView;
}

- (UITableView *)moreTableView {
    if (!_moreTableView) {
        self.moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(PADDING, CGRectGetMaxY(self.imageCollectionView.frame), CGRectGetWidth(self.imageCollectionView.frame), 0) style:UITableViewStylePlain];
        _moreTableView.delegate = self;
        _moreTableView.dataSource = self;
        _moreTableView.bounces = NO;
        _moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _moreTableView;
}

- (ZLPhotoActionSheet *)photoActionSheet {
    ZLPhotoActionSheet *photoActionSheet = [[ZLPhotoActionSheet alloc] init];
    photoActionSheet.configuration.maxPreviewCount = 10;
    photoActionSheet.sender = self.sender;
    photoActionSheet.configuration.allowSelectVideo = NO;
    photoActionSheet.configuration.allowSelectGif = YES;
    photoActionSheet.configuration.allowSelectOriginal = YES;
    photoActionSheet.configuration.languageType = ZLLanguageChineseSimplified;
    photoActionSheet.configuration.allowRecordVideo = NO;
    return photoActionSheet;
}

@end
