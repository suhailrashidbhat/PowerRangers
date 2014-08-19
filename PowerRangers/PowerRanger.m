//
//  PowerRanger.m
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

/*
 This is a UI component which will create the Power Ranger Square in the map and in the PowerRangerCell.
 */

#import "PowerRanger.h"

@implementation PowerRanger

- (id)initWithType:(PowerRangerType)rangerType
{
    self = [super init];
    if (self) {
        // Initialization code
        [self reloadRangerWithType:rangerType];
    }
    return self;
}

- (void)reloadRangerWithType:(PowerRangerType)rangerType {
    self.rangerType = rangerType;
    switch (rangerType) {
        case Red:
            self.backgroundColor = [UIColor redColor];
            self.rangerName = NSLocalizedString(@"RED", nil);
            break;
        case Yellow:
            self.backgroundColor = [UIColor yellowColor];
            self.rangerName = NSLocalizedString(@"YELLOW", nil);
            break;
        case Green:
            self.backgroundColor = [UIColor greenColor];
            self.rangerName = NSLocalizedString(@"GREEN", nil);
            break;
        case Blue:
            self.backgroundColor = [UIColor blueColor];
            self.rangerName = NSLocalizedString(@"BLUE", nil);
            break;
        case Black:
            self.backgroundColor = [UIColor blackColor];
            self.rangerName = NSLocalizedString(@"BLACK", nil);
            break;
        case Gray:
            self.backgroundColor = [UIColor grayColor];
            self.rangerName = NSLocalizedString(@"GRAY", nil);
            break;
        default:
            break;
    }
}

@end
