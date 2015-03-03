//
//  JsonTableViewCell.m
//  Telstra
//
//Created by ramya on 03.03/15.
//  Copyright (c) 2015 cognizant. All rights reserved.
//

#import "JsonTableViewCell.h"
#import "Feeds.h"
#import "UIImageView+AFNetworking.h"


#define accessoryTypeSpacing 35
#define edgeSpacing 20

@interface JsonTableViewCell()


@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UILabel *descriptionLabel;
@property(nonatomic,retain) UIImageView *feedImage;
@property(nonatomic,copy) Feeds *feed;


// Private Methods
-(void)addconstrainsForCellElements;

@end

@implementation JsonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _titleLabel = [[UILabel alloc]init];
    _descriptionLabel = [[UILabel alloc]init];
    _feedImage = [[UIImageView alloc]init];
    
    
    
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
    [self.titleLabel setTextColor:[UIColor blueColor]];
    
    
    [self.descriptionLabel setNumberOfLines:0];
    [self.descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.descriptionLabel setTextColor:[UIColor blackColor]];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.feedImage];
    
    [self addconstrainsForCellElements];
    
    return self;
    
}


#pragma mark -
#pragma mark Custom Methods

/*
 
 This Function is used to add autolayout constraint to the text label and
 image view in the tableview cell.
 
 */
-(void)addconstrainsForCellElements
{
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.feedImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Adding 'Leading' , 'Trailing' , 'Top' constraints for Title Label
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    NSLayoutConstraint *topConstraintForTitleLabel =[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    [topConstraintForTitleLabel setPriority:UILayoutPriorityRequired]; // Setting maximum priority for the constraint
    [self.contentView addConstraint:topConstraintForTitleLabel];
    
    
    // Adding 'Leading' , 'Bottom' constraints to Description Label
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    NSLayoutConstraint *bottomConstraintForDescLabel = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.descriptionLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    [bottomConstraintForDescLabel setPriority:900];
    [self.contentView addConstraint:bottomConstraintForDescLabel];
    
    // Addding Cross Contraint between Title label and desc label
    NSLayoutConstraint *topConstraintForDescLabel=[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    [topConstraintForDescLabel setPriority:UILayoutPriorityRequired];
    [self.contentView addConstraint:topConstraintForDescLabel];
    
    
    // Adding 'Centre Y ' , 'Leading' , 'Bottom' constraints to Feed ImageView
    
    NSLayoutConstraint *centreSpacingConstraint=[NSLayoutConstraint constraintWithItem:self.feedImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [centreSpacingConstraint setPriority:900];
    [self.contentView addConstraint:centreSpacingConstraint];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.feedImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.descriptionLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.feedImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
    
    NSLayoutConstraint *constraintForImageViewBottom=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.feedImage attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    [constraintForImageViewBottom setPriority:900]; // Setting a lower priority constraint to acheive a gap of 10 pixel between the imageview and bottom of the contentview
    [self.contentView addConstraint:constraintForImageViewBottom];
    
    NSLayoutConstraint *topSpacingCOnstraintImgView=[NSLayoutConstraint constraintWithItem:self.feedImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.descriptionLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [topSpacingCOnstraintImgView setPriority:900];
    [self.contentView addConstraint:topSpacingCOnstraintImgView];
    
    
    
    
    
    
    // Setting the Height and Width for the ImageView.
    NSDictionary *dictionary=NSDictionaryOfVariableBindings(_feedImage,_titleLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_feedImage(70)]" options:0 metrics:nil views:dictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_feedImage(50)]" options:0 metrics:nil views:dictionary]];
    
}


/*
 This function is used to get the data from the Feed object and to load in the label and imageview
 A copy of 'Feed' object is made in this function.
 
 */
-(void)loadDataInCell:(Feeds *)feeds
{
    self.feed= feeds;
    [self.descriptionLabel setText:[self.feed feedsDescription]];
    [self.titleLabel setText:[self.feed  feedsTitle]];
    if(![[feeds feedsImage] isEqualToString:@""])
        [self.feedImage setImageWithURL:[NSURL URLWithString:[feeds feedsImage]] placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"]];
    else{
        [self.feedImage setImage:[UIImage imageNamed:@""]];
    }
}

-(void)loadDataInitialCell{
    self.textLabel.text = @"Fetching JSON Data";
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    // Setting preferred Max width for UILabel this is required only in case of UIlabel created by code and aligned using autolayout
    [self.descriptionLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-CGRectGetWidth(self.feedImage.bounds)-accessoryTypeSpacing-edgeSpacing];
    [self.titleLabel setPreferredMaxLayoutWidth:CGRectGetWidth(self.bounds)-accessoryTypeSpacing-edgeSpacing];
    
    
}

#pragma mark -
#pragma mark Dealloc Method

-(void)dealloc
{
    
    [_titleLabel release];
    [_descriptionLabel release];
    [_feedImage release];
    [_feed release];
    [super dealloc];
}



@end
