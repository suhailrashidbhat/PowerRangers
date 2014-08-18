//
//  PowerRangerCell.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerRanger.h"

@interface PowerRangerCell : UITableViewCell

@property(nonatomic, strong) PowerRanger *rangerSquare;
@property(nonatomic, strong) UILabel *rangerName;
@property(nonatomic, assign) BOOL isSelected;

-(void) InitializeCellWithIndexPath:(NSIndexPath*)indexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath*)indexPath;
- (void) disableCell;
- (void) enableCellWithType:(PowerRangerType)rangerType;

@end
