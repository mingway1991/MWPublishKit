//
//  MWImageObject.h
//  GPUImage
//
//  Created by 石茗伟 on 2018/8/20.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MWImageObjectTypeUnknow,
    MWImageObjectTypeImage,
    MWImageObjectTypeUrl,
} MWImageObjectType;

@interface MWImageObject : NSObject <NSCoding>

/* 图片对象类型 */
@property (nonatomic, assign) MWImageObjectType type;
/* 图片对象类型，目前支持UIImage和NSURL */
@property (nonatomic, strong) id contentObject;

@end
