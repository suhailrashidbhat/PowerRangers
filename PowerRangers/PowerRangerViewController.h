//
//  PowerRangerViewController.h
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerRanger.h"
#import "MapKit/MapKit.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//@property (strong, nonatomic) IBOutlet MKMapView *mapVyu;  TODO::Lets do in next version.
@property (nonatomic, strong) PowerRanger *rangerSquare;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *rangerSelectionTable;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;

@end
