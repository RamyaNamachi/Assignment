//
//  OverViewModel.h
//  Telstra
//
// Created by Ramya on 03/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved
//

#import <Foundation/Foundation.h>

@class Feeds;
@interface OverViewModel : NSObject


@property(nonatomic,retain) NSString *newsTitle;
@property(nonatomic,retain) NSMutableArray *feeds;

-(instancetype)initWithTitle:(NSString *)newsTitle andFeeds:(NSMutableArray *)feeds;

@end
