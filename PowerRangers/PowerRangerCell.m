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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRangerType:(PowerRangerType)rangerType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.isSelected = NO;
        self.rangerType = rangerType;
        [self addSquare];
        [self addLabel];
    }
    return self;
}

- (void) disableCell {
    self.isSelected = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rangerName.textColor = [UIColor grayColor];
    [self.rangerSquare reloadRangerWithType:Gray];
}

- (void) enableCell {
    self.isSelected = NO;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    [self updateCellLabelColor];
    [self.rangerSquare reloadRangerWithType:self.rangerType];
}

-(void)addSquare {
    self.rangerSquare = [[PowerRanger alloc] initWithType:self.rangerType];
    [self.rangerSquare setFrame:CGRectMake(CELL_OFFSET, CELL_OFFSET, RANGER_WIDTH, RANGER_HEIGHT)];
    [self addSubview:self.rangerSquare];
}

-(void)addLabel {
    const NSInteger xOffsetLabel = CELL_OFFSET + RANGER_WIDTH + (CELL_OFFSET*2);
    self.rangerName = [[UILabel alloc] init];
    [self.rangerName setFrame:CGRectMake(xOffsetLabel, CELL_OFFSET, RANGER_CELL_LABEL_WIDTH, RANGER_CELL_LABEL_HEIGHT)];
    self.rangerName.text = self.rangerSquare.rangerName;
    [self updateCellLabelColor];
    [self addSubview:self.rangerName];
}

-(void)updateCellLabelColor {
    switch (self.rangerType) {
        case Red:
            self.rangerName.textColor = [UIColor redColor];
            break;
        case Yellow:
            self.rangerName.textColor = [UIColor yellowColor];
            break;
        case Green:
            self.rangerName.textColor = [UIColor greenColor];
            break;
        case Blue:
            self.rangerName.textColor = [UIColor blueColor];
            break;
        case Black:
            self.rangerName.textColor = [UIColor blackColor];
            break;
        default:
            break;
    }
}

@end
