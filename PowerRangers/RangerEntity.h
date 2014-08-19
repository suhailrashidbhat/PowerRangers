//
//  RangerEntity.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

/*
This is the Core Data Entity Class which stores the Power ranger's Name, Type, X and Y position in the map.
 */

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RangerEntity : NSManagedObject

@property (nonatomic, retain) NSString *rangerName;
@property (nonatomic, retain) NSNumber *rangerType;
@property (nonatomic, assign) float rangerXPosition;
@property (nonatomic, assign) float rangerYPosition;

@end
