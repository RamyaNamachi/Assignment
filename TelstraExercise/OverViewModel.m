//
//  OverViewModel.h
//  Telstra
//
// Created by Ramya on 03/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved
//

#import "OverViewModel.h"
#import "Feeds.h"

@implementation OverViewModel

-(instancetype)initWithTitle:(NSString *)newsTitle andFeeds:(NSMutableArray *)feeds
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _newsTitle = [newsTitle retain];
    _feeds = [feeds retain];
    
    return self;
}


-(void)dealloc{
    [_feeds release];
    [_newsTitle release];
    [super dealloc];
}


@end
