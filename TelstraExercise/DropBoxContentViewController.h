//
//  DropBoxContentViewController.h
//  Telstra
//
//  Created by Ramya on 03/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OverViewModel;
@class Feeds;

@interface DropBoxContentViewController : UITableViewController

@property (nonatomic,retain) OverViewModel *data;

@property (nonatomic,retain) Feeds *newsRow;

@end

