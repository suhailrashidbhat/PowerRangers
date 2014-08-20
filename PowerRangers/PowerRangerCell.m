//
//  PowerRangerCell.m
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import "PowerRangerCell.h"
#import "PowerRanger.h"

@implementation PowerRangerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath*)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.isSelected = NO;
        [self addSquareAndLabelWithIndexPath:indexPath];
    }
    return self;
}

- (void) disableCell {
    self.isSelected = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rangerName.textColor = [UIColor grayColor];
    [self.rangerSquare reloadRangerWithType:Gray];
}

- (void) enableCellWithType:(PowerRangerType)rangerType {
    self.isSelected = NO;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.rangerName.textColor = [UIColor blackColor];
    [self.rangerSquare reloadRangerWithType:rangerType];
}

-(void)addSquareAndLabelWithIndexPath:(NSIndexPath*)indexPath {
    self.rangerName = [[UILabel alloc] init];
    self.rangerSquare = [[PowerRanger alloc] initWithType:indexPath.row];
    const NSInteger labelWidth = RANGER_CELL_LABEL_WIDTH;
    const NSInteger labelHeight = RANGER_CELL_LABEL_HEIGHT;
    const NSInteger xOffsetRangerSquare = CELL_OFFSET;
    const NSInteger xOffsetLabel = xOffsetRangerSquare + RANGER_WIDTH + (CELL_OFFSET*2);
    const NSInteger yOffset = CELL_OFFSET;
    [self.rangerSquare setFrame:CGRectMake(xOffsetRangerSquare, yOffset, RANGER_WIDTH, RANGER_HEIGHT)];
    [self.rangerName setFrame:CGRectMake(xOffsetLabel, yOffset, labelWidth, labelHeight)];
    self.rangerName.text = self.rangerSquare.rangerName;
    [self addSubview:self.rangerSquare];
    [self addSubview:self.rangerName];
}

@end
