//
//  Ranger.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Ranger : NSManagedObject

@property (nonatomic, retain) NSString *rangerName;
@property (nonatomic, retain) NSNumber *rangerType;
@property (nonatomic, assign) float rangerXPosition;
@property (nonatomic, assign) float rangerYPosition;

@end
