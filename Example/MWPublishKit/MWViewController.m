//
//  MWViewController.m
//  MWPublishKit
//
//  Created by mingway1991 on 08/20/2018.
//  Copyright (c) 2018 mingway1991. All rights reserved.
//

#import "MWViewController.h"
#import "MWPublishKit.h"

@interface MWViewController () <MWPublishViewMoreItemDataSource, MWPublishViewMoreItemDelegate>

@end

@implementation MWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MWPublishView *publishView = [[MWPublishView alloc] initWithFrame:self.view.frame
                                                   moreItemDataSource:self
                                                     moreItemDelegate:self];
    publishView.placeHolder = @"哈哈哈";
    publishView.textColor = [UIColor redColor];
    publishView.textFont = [UIFont systemFontOfSize:26];
    MWImageObject *test = [[MWImageObject alloc] init];
    test.type = MWImageObjectTypeUrl;
    test.contentObject = [NSURL URLWithString:@"http://pic.ffpic.com/files/tupian/tupian0277.jpg"];
    [publishView configSelectedImageObjects:@[test]];
    [publishView configInputText:@"测试"];
    [self.view addSubview:publishView];
}

- (NSInteger)moreItemCount {
    return 1;
}

- (MWMoreItem *)moreItemForRow:(NSInteger)row {
    if (row == 0) {
        MWMoreItem *moreItem = [[MWMoreItem alloc] init];
        moreItem.normalTitle = @"开启定位";
        moreItem.selectedTitle = @"xxxx市";
        moreItem.isSelected = NO;
        moreItem.normalIconImage = [UIImage imageNamed:@"location"];
        moreItem.selectedIconImage = [UIImage imageNamed:@"selected_location"];
        return moreItem;
    }
    return nil;
}

- (void)clickItemForMoreItem:(MWMoreItem *)moreItem row:(NSInteger)row {
    
}

@end
