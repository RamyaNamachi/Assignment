//
//  ViewController.m
//  Telstra
//Created by ramya on 03.03/15.
//  Copyright (c) 2015 cognizant. All rights reserved.
//

#import "DropBoxContentViewController.h"

#import "AFNetworking.h"
#import "OverViewModel.h"
#import "UIRefreshControl+AFNetworking.h"
#import "JsonTableViewCell.h"

#import "Feeds.h"
static NSString *CellIdentifier = @"Cell";

@interface DropBoxContentViewController ()


@property (nonatomic,retain) UIRefreshControl *refreshControl;


@end

@implementation DropBoxContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadJsonData];
    // Do any additional setup after loading the view, typically from a nib.
    
    // An instance of UIrefreshview control is created.
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100.0f)];
    self.refreshControl=refreshControl;
    [refreshControl release];
    [self.refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    [self.navigationItem setHidesBackButton:YES];
    
}

-(void)downloadJsonData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *response = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/g41ldl6t0afw9dv/facts.json"]]; //use static string
        NSError *parseError = nil;
        NSMutableDictionary *jsonFeedDictionary = [[NSMutableDictionary alloc]init];
        NSString* string = [[[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\0" withString:@""];
        // NSLog(@"string %@",string);
        response = [string dataUsingEncoding:NSUTF8StringEncoding];
        jsonFeedDictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&parseError];
        if(!parseError){
            // NSLog(@"no error");
            
            NSMutableArray *jsonArrayOfRowsFromDict = [[NSMutableArray alloc] init];
            
            
            for(NSDictionary *rowDict in [jsonFeedDictionary objectForKey:@"rows"]){
                //assign and reuse
                if(!([rowDict objectForKey:@"title"]==(id)[NSNull null] && [rowDict objectForKey:@"description"]==(id)[NSNull null]&& [rowDict objectForKey:@"imageHref"]==(id)[NSNull null])){
                    
                    Feeds *records = [[Feeds alloc] init];
                    if([records containsAllElements:rowDict]){
                        
                        [jsonArrayOfRowsFromDict addObject:records];
                    }
                }
            }
            self.data = [[OverViewModel alloc] initWithTitle:[jsonFeedDictionary objectForKey:@"title"] andFeeds:jsonArrayOfRowsFromDict];
            [self.navigationItem setTitle:self.data.newsTitle];
            //  NSLog(@"data fetched");
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //   NSLog(@"data %@",  self.data.feeds);
                [self.tableView reloadData];
                
            });
        }
        else{
            [self showErrorAlert:parseError];
        }
    });
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark TableView Datasource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.data feeds] count]==0)
        return 1;
    else
        return [[self.data feeds] count]; // The number of rows is the feeds count which is got from the response
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self basicCellAtIndexPath:indexPath];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self heightForBasicCellAtIndexPath:indexPath];
    
}

#pragma mark -
#pragma mark Orientation handlers

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}



#pragma mark -
#pragma mark Custom Methods

/*
 
 This function is used to create or dequeue the instance of the cell
 and load the label and the imageview in the cell with data from the
 'Feed' object
 
 */

- (JsonTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JsonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    
    if (!cell) {
        cell = [[[JsonTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease]   ;
    }
    
    if([[self.data feeds]count]==0){
        [cell loadDataInitialCell];
        
    }
    else{
        
        
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        [cell loadDataInCell:[self.data.feeds objectAtIndex:indexPath.row]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell ;
    
}


/*
 
 This function is suposed to return the dynamic height of the
 cells based on their content
 
 */


- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    
    JsonTableViewCell *sizingCell = [self basicCellAtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}


/*
 
 The height of the tableview cell is calculated in this method.
 Since autolayout is used 'systemLayoutSizeFittingSize' method is
 used to find the size of tableview cell
 
 */
- (CGFloat)calculateHeightForConfiguredSizingCell:(JsonTableViewCell *)sizingCell {
    
    [sizingCell setFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(sizingCell.bounds))];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

/*
 
 This function is called to make the service call
 and reload the table view.
 
 */

-(void)reloadTable{
    [self.refreshControl beginRefreshing];
    
    [self downloadJsonData];
    
    [self.refreshControl endRefreshing];
    
    
    
    
}

/*
 This method is used to display the alertview
 
 */


-(void)showErrorAlert:(NSError *)error
{
    UIAlertView *alertView=[[[UIAlertView alloc]initWithTitle:@"Error" message:[NSError description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    [alertView show];
}

#pragma mark -
#pragma marl dealloc method

-(void)dealloc{
    
    [_data release];
    [super dealloc];
    
}

@end
