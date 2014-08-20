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

#pragma mark - View lifecycle

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
        [self addSquareWithType:[rangerInfo.rangerType intValue]];
        [self.rangerSquare setFrame:CGRectMake(rangerInfo.rangerXPosition, rangerInfo.rangerYPosition, RANGER_WIDTH, RANGER_HEIGHT)];
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
    rangerCell.isSelected = [self checkIfRangerIsInTheField:(PowerRangerType)indexPath.row];
    if (rangerCell.isSelected) {
        [rangerCell disableCell];
    } else {
        [rangerCell enableCellWithType:indexPath.row];
    }
    return rangerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rangerSelectionTable deselectRowAtIndexPath:indexPath animated:YES];
    PowerRangerCell *currentCell = (PowerRangerCell*)[self.rangerSelectionTable cellForRowAtIndexPath:indexPath];
    if (currentCell.isSelected) {
        [self deletePreviousValueForObjectType:indexPath.row];
        for (PowerRanger *rangerView in self.mapView.subviews) {
            if (rangerView.rangerType == indexPath.row) {
                [rangerView removeFromSuperview];
            }
        }
        [currentCell enableCellWithType:indexPath.row];
    } else {
        [self addSquareInMapWithRangerType:indexPath.row];
        [currentCell disableCell];
    }
}


#pragma mark - Map operations and saving positions.

- (BOOL)checkIfRangerIsInTheField:(PowerRangerType)rangerType {
    for (PowerRanger *ranger in self.mapView.subviews) {
        if (ranger.rangerType == rangerType) {
            return TRUE;
        }
    }
    return FALSE;
}


-(void)addSquareInMapWithRangerType:(PowerRangerType)rangerType {
    [self addSquareWithType:rangerType];
    NSInteger xPoint = (self.mapView.frame.size.width - self.rangerSquare.frame.size.width)/2;
    NSInteger yPoint = (self.mapView.frame.size.height - self.rangerSquare.frame.size.height)/2;
    // To distingiush two squares added same place.
    for (PowerRanger *ranger in self.mapView.subviews) {
        if (ranger.frame.origin.x == xPoint && ranger.frame.origin.y == yPoint) {
            xPoint += 10;
            yPoint += 10;
        }
    }
    //Simple Animation from top left corner.
    [self.rangerSquare setFrame:CGRectMake(0, 0, RANGER_WIDTH, RANGER_HEIGHT)];
    [UIView animateWithDuration:0.6 animations:^{
        [self.rangerSquare setFrame:CGRectMake(xPoint, yPoint, RANGER_WIDTH, RANGER_HEIGHT)];
    }];
}

-(void) addSquareWithType:(PowerRangerType)rangerType {
    self.rangerSquare = [[PowerRanger alloc] initWithType:rangerType];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.rangerSquare addGestureRecognizer:panGesture];
    [self.mapView addSubview:self.rangerSquare];
}

-(void)handlePan:(UIPanGestureRecognizer*)panGesture; {
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint newCenter = panGesture.view.center;
        CGPoint translation = [panGesture translationInView:panGesture.view];
        newCenter = CGPointMake(newCenter.x + translation.x,
                             newCenter.y + translation.y);
        
        //Check whether boundary conditions are met
        const NSInteger offset = 15;
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
- (IBAction)saveButtonClicked:(id)sender {
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
        [self saveRangerPositionsforRangerName:rangers.rangerName xPosition:rangers.center.x yPosition:rangers.center.y forType:rangers.rangerType];
    }
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"POWER_RANGER_POSITION_ALERT", nil) message:NSLocalizedString(@"POSITION_SAVED_ALERT", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [successAlert show];
}

- (IBAction)resetButtonClicked:(id)sender {
    for (PowerRanger *ranger in self.mapView.subviews) {
        [ranger removeFromSuperview];
        [self deletePreviousValueForObjectType:ranger.rangerType];
    }
    [self.rangerSelectionTable reloadData];
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

- (void)saveRangerPositionsforRangerName:(NSString*)powerRangerName xPosition:(float)xPosition yPosition:(float)yPosition forType:(PowerRangerType)rangerType {
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

-(void)saveContext {
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
