//
//  MWImageObject.m
//  GPUImage
//
//  Created by 石茗伟 on 2018/8/20.
//

#import "MWImageObject.h"

@implementation MWImageObject

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.contentObject forKey:@"contentObject"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.contentObject = [aDecoder decodeObjectForKey:@"contentObject"];
    }
    return self;
}

@end
