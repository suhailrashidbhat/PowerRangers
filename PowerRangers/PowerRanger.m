//
//  PowerRanger.m
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

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
    switch (rangerType) {
        case Red:
            self.backgroundColor = [UIColor redColor];
            self.rangerName = @"Red Ranger";
            break;
        case Yellow:
            self.backgroundColor = [UIColor yellowColor];
            self.rangerName = @"Yellow Ranger";
            break;
        case Green:
            self.backgroundColor = [UIColor greenColor];
            self.rangerName = @"Green Ranger";
            break;
        case Blue:
            self.backgroundColor = [UIColor blueColor];
            self.rangerName = @"Blue Ranger";
            break;
        case Black:
            self.backgroundColor = [UIColor blackColor];
            self.rangerName = @"Black Ranger";
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
