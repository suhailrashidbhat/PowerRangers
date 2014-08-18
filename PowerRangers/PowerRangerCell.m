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

- (void)awakeFromNib
{
    // Initialization code
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
    const NSInteger labelWidth = 150;
    const NSInteger labelHeight = 30;
    const NSInteger xOffsetRangerSquare = 10;
    const NSInteger xOffsetLabel = xOffsetRangerSquare + RANGER_WIDTH + 20;
    const NSInteger yOffset = 10;
    [self.rangerSquare setFrame:CGRectMake(xOffsetRangerSquare, yOffset, RANGER_WIDTH, RANGER_HEIGHT)];
    [self.rangerName setFrame:CGRectMake(xOffsetLabel, yOffset, labelWidth, labelHeight)];
    self.rangerName.text = self.rangerSquare.rangerName;
    [self addSubview:self.rangerSquare];
    [self addSubview:self.rangerName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
