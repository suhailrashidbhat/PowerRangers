//
//  PowerRanger.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Red,
    Yellow,
    Green,
    Blue,
    Black
} PowerRangerType;


static const int RANGER_WIDTH = 30;
static const int RANGER_HEIGHT = 30;

@interface PowerRanger : UIView

- (id)initWithType:(PowerRangerType)rangerType;
@property (nonatomic, assign) PowerRangerType rangerType;
@property (nonatomic, strong) NSString *rangerName;


@end
