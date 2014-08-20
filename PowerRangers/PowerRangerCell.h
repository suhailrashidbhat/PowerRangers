//
//  PowerRangerCell.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

/*
 This is a UI component which will create the Power Ranger Cell in the table it will have 
  PowerRangerSquare | RangerNameLabel.
 */

#import <UIKit/UIKit.h>
#import "PowerRanger.h"

static const int RANGER_CELL_LABEL_WIDTH = 150;
static const int RANGER_CELL_LABEL_HEIGHT = 30;
static const int CELL_OFFSET = 10;

@interface PowerRangerCell : UITableViewCell

@property(nonatomic, strong) PowerRanger *rangerSquare;
@property(nonatomic, strong) UILabel *rangerName;
@property(nonatomic, assign) BOOL isSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath*)indexPath;
- (void) disableCell;
- (void) enableCellWithType:(PowerRangerType)rangerType;

@end
