//
//  MWImageHelper.m
//  MWPublishKit
//
//  Created by 石茗伟 on 2018/8/22.
//

#import "MWImageHelper.h"

@implementation MWImageHelper

+ (UIImage *)loadImageWithName:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
