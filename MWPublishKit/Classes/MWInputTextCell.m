//
//  MWInputTextCell.m
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/12/11.
//

#import "MWInputTextCell.h"

@interface MWInputTextCell () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation MWInputTextCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.inputTextView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.inputTextView.frame = self.bounds;
}

- (NSString *)text {
    return self.inputTextView.text;
}

- (void)setText:(NSString *)text {
    self.inputTextView.text = text;
}

- (void)setFont:(UIFont *)font {
    if (font) {
        self.placeHolderLabel.font = font;
        self.inputTextView.font = font;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        self.inputTextView.textColor = textColor;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    self.placeHolderLabel.text = placeHolder;
    self.placeHolderLabel.frame = self.inputTextView.bounds;
    [self.placeHolderLabel sizeToFit];
}

- (void)resignTextViewFisrtResponder {
    [self.inputTextView resignFirstResponder];
}

#pragma mark - Private
/* 根据文本处理placeHolderLabel的显示与隐藏 */
- (void)updatePlaceHolderStateWithText:(NSString *)text {
    if (text.length == 0) {
        self.placeHolderLabel.alpha = 1;
    } else {
        self.placeHolderLabel.alpha = 0;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updatePlaceHolderStateWithText:textView.text];
}

#pragma mark - LazyLoad
- (UITextView *)inputTextView {
    if (!_inputTextView) {
        self.inputTextView = [[UITextView alloc] init];
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
        _placeHolderLabel.font = [UIFont systemFontOfSize:16.f];
        _placeHolderLabel.font = self.inputTextView.font;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.text = @"请输入内容";
        _placeHolderLabel.numberOfLines = 0;
        [_placeHolderLabel sizeToFit];
    }
    return _placeHolderLabel;
}

@end
