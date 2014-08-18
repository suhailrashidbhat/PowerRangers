//
//  PowerRangerViewController.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerRanger.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PowerRanger *rangerSquare;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *rangerSelectionTable;

@end
