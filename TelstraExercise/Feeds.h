//
//  Feeds.h
//  Telstra
//
//Created by ramya on 03.03/15.
//  Copyright (c) 2015 cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feeds : NSObject<NSCopying>

@property(nonatomic,retain) NSString *feedsTitle;
@property(nonatomic,retain) NSString *feedsDescription;
@property(nonatomic,retain) NSString *feedsImage;

-(BOOL)containsAllElements:(NSDictionary *)attributes;

-(id)copyWithZone:(NSZone *)zone;
@end
