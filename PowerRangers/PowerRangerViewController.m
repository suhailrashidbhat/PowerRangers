//
//  PowerRangerViewController.m
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import "PowerRangerViewController.h"
#import "PowerRangerCell.h"
#import "RangerEntity.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *xRed;
@property (weak, nonatomic) IBOutlet UILabel *yRed;
@property (weak, nonatomic) IBOutlet UILabel *xYellow;
@property (weak, nonatomic) IBOutlet UILabel *yYellow;
@property (weak, nonatomic) IBOutlet UILabel *xGreen;
@property (weak, nonatomic) IBOutlet UILabel *yGreen;
@property (weak, nonatomic) IBOutlet UILabel *xBlue;
@property (weak, nonatomic) IBOutlet UILabel *yBlue;
@property (weak, nonatomic) IBOutlet UILabel *xBlack;
@property (weak, nonatomic) IBOutlet UILabel *yBlack;

@end


@implementation ViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self restoreAndPlotRanger];
}

- (void)restoreAndPlotRanger {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RangerEntity"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (RangerEntity *rangerInfo in fetchedObjects) {
        NSLog(@"RangerType: %@", rangerInfo.rangerName);
        NSLog(@"XPosition: %f", rangerInfo.rangerXPosition);
        NSLog(@"YPosition: %f", rangerInfo.rangerYPosition);
        
        self.rangerSquare = [[PowerRanger alloc] initWithType:[rangerInfo.rangerType intValue]];
        [self.rangerSquare setFrame:CGRectMake(rangerInfo.rangerXPosition, rangerInfo.rangerXPosition, RANGER_WIDTH, RANGER_HEIGHT)];
        [self.mapView addSubview:self.rangerSquare];
    }
}

#pragma mark - Table view data source and delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PowerRangerCell* rangerCell  = nil;
    NSString *cellIdentifier = @"rangerSelectionCell";
    rangerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (rangerCell == nil) {
        rangerCell = [[PowerRangerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withIndexPath:indexPath];
    }
    return rangerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rangerSelectionTable deselectRowAtIndexPath:indexPath animated:YES];
    PowerRangerCell *currentCell = (PowerRangerCell*)[self.rangerSelectionTable cellForRowAtIndexPath:indexPath];
    if (currentCell.isSelected) {
        for (UIView *rangerView in self.mapView.subviews) {
            if (rangerView.tag == indexPath.row) {
                [rangerView removeFromSuperview];
            }
        }
        [currentCell enableCellWithType:indexPath.row];
    } else {
        [self addSquareInMapWithIndexPath:indexPath];
        [currentCell disableCell];
    }
}

#pragma mark - Map operations and saving positions.

-(void)addSquareInMapWithIndexPath:(NSIndexPath*)indexPath {
    self.rangerSquare = [[PowerRanger alloc] initWithType:indexPath.row];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.rangerSquare addGestureRecognizer:panGesture];
    [self.rangerSquare setFrame:CGRectMake(self.mapView.center.x, self.mapView.center.y, RANGER_WIDTH, RANGER_HEIGHT)];
    NSInteger xPoint = (self.mapView.frame.size.width - self.rangerSquare.frame.size.width)/2;
    NSInteger yPoint = (self.mapView.frame.size.height - self.rangerSquare.frame.size.height)/2;
   
    // To distingiush two squares added same place.
    for (PowerRanger *ranger in self.mapView.subviews) {
        if (ranger.frame.origin.x == xPoint && ranger.frame.origin.y == yPoint) {
            xPoint += 10;
            yPoint += 10;
        }
    }
    [self.rangerSquare setFrame:CGRectMake(xPoint, yPoint, RANGER_WIDTH, RANGER_HEIGHT)];
    self.rangerSquare.tag = indexPath.row;
    [self.mapView addSubview:self.rangerSquare];
}

-(void)handlePan:(UIPanGestureRecognizer*)panGesture; {
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint newCenter = panGesture.view.center;
        CGPoint translation = [panGesture translationInView:panGesture.view];
        newCenter = CGPointMake(newCenter.x + translation.x,
                             newCenter.y + translation.y);
        const NSInteger offset = 15;
        
        //Check whether boundary conditions are met
        NSInteger yMin = self.mapView.bounds.origin.y + offset;
        NSInteger yMax = self.mapView.bounds.size.height - offset;
        NSInteger xMin = self.mapView.bounds.origin.x + offset;
        NSInteger xMax = self.mapView.bounds.size.width - offset;
        BOOL inBounds = (newCenter.y >= yMin && newCenter.y <= yMax &&
                         newCenter.x >= xMin && newCenter.x <= xMax);
        if  (inBounds) {
            //if boundary conditions met : translate the view
            panGesture.view.center = newCenter;
            NSLog(@"X: %f  Y == %f", newCenter.x, newCenter.y);
            [panGesture setTranslation:CGPointZero inView:self.view];
        }
    }
}
- (IBAction)SaveButtonClicked:(id)sender {
    for (PowerRanger *rangers in self.mapView.subviews) {
        NSString *xString = [NSString stringWithFormat:@"%2f", rangers.center.x];
        NSString *yString = [NSString stringWithFormat:@"%2f", rangers.center.y];
        switch (rangers.rangerType) {
            case Red:
                self.xRed.text = xString;
                self.yRed.text = yString;
                break;
             case Yellow:
                self.xYellow.text = xString;
                self.yYellow.text = yString;
                break;
            case Green:
                self.xGreen.text = xString;
                self.yGreen.text = yString;
                break;
            case Blue:
                self.xBlue.text = xString;
                self.yBlue.text = yString;
                break;
            case Black:
                self.xBlack.text = xString;
                self.yBlack.text = yString;
                break;
            default:
                break;
        }
        [self deletePreviousValueForObjectType:rangers.rangerType];
        [self SaveRangerPositionsforRangerName:rangers.rangerName xPosition:rangers.center.x yPosition:rangers.center.y forType:rangers.rangerType];
    }
}

- (void)deletePreviousValueForObjectType:(PowerRangerType)objectType {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * allRangers = [[NSFetchRequest alloc] init];
    [allRangers setEntity:[NSEntityDescription entityForName:@"RangerEntity" inManagedObjectContext:context]];
    [allRangers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * rangers = [context executeFetchRequest:allRangers error:&error];
    //error handling goes here
    for (NSManagedObject *ranger in rangers) {
        RangerEntity *entity = (RangerEntity*)ranger;
        if([entity.rangerType intValue] == objectType) {
            [context deleteObject:ranger];
        }
    }
    NSError *saveError = nil;
    [context save:&saveError];
}

- (IBAction)DisplayResultsButtonClicked:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RangerEntity"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (RangerEntity *rangerInfo in fetchedObjects) {
        NSString *xString = [NSString stringWithFormat:@"%2f", rangerInfo.rangerXPosition];
        NSString *yString = [NSString stringWithFormat:@"%2f", rangerInfo.rangerYPosition];
        switch ((int)rangerInfo.rangerType) {
            case Red:
                self.xRed.text = xString;
                self.yRed.text = yString;
                break;
            case Yellow:
                self.xYellow.text = xString;
                self.yYellow.text = yString;
                break;
            case Green:
                self.xGreen.text = xString;
                self.yGreen.text = yString;
                break;
            case Blue:
                self.xBlue.text = xString;
                self.yBlue.text = yString;
                break;
            case Black:
                self.xBlack.text = xString;
                self.yBlack.text = yString;
                break;
            default:
                break;
        }
    }
    
}

- (void)SaveRangerPositionsforRangerName:(NSString*)powerRangerName xPosition:(float)xPosition yPosition:(float)yPosition forType:(PowerRangerType)rangerType {
    NSManagedObjectContext *context = [self managedObjectContext];
    RangerEntity *ranger = [NSEntityDescription
                      insertNewObjectForEntityForName:@"RangerEntity"
                      inManagedObjectContext:context];
    ranger.rangerName = powerRangerName;
    ranger.rangerType = [NSNumber numberWithInt:rangerType];
    ranger.rangerXPosition = xPosition;
    ranger.rangerYPosition = yPosition;

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [self saveContext];
}

-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PowerRangerPositions" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PowerRangerPositions.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
