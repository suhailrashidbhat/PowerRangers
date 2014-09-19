//
//  PowerRanger.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//


/*
 This is a UI component which will create the Power Ranger Square in the map and in the PowerRangerCell. 
 */

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Red,
    Yellow,
    Green,
    Blue,
    Black,
    Gray
} PowerRangerType;


static const int RANGER_WIDTH = 30;
static const int RANGER_HEIGHT = 30;

// Interface addition.  

@interface PowerRanger : UIView

- (id)initWithType:(PowerRangerType)rangerType;
- (void)reloadRangerWithType:(PowerRangerType)rangerType;
@property (nonatomic, assign) PowerRangerType rangerType;
@property (nonatomic, copy) NSString *rangerName;


@end
