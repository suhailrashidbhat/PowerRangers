//
//  PowerRangerViewController.m
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import "PowerRangerViewController.h"
#import "PowerRangerCell.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *rangersArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor purpleColor]];
    self.rangersArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        for (PowerRanger *ranger in self.rangersArray) {
            if (ranger.rangerType == indexPath.row) {
                [self.rangersArray removeObject:ranger];
            }
        }
        for (PowerRanger *ranger in self.mapView.subviews) {
            if (ranger.rangerType == indexPath.row) {
                ranger.hidden = YES;
            }
        }
        [currentCell enableCellWithType:indexPath.row];
    } else {
        [self addSquareInMapWithIndexPath:indexPath];
        [currentCell disableCell];
    }
}

-(void)addSquareInMapWithIndexPath:(NSIndexPath*)indexPath {
    self.rangerSquare = [[PowerRanger alloc] initWithType:indexPath.row];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handlePan:)];
    [self.rangerSquare addGestureRecognizer:panGesture];
    [self.rangerSquare setFrame:CGRectMake(self.mapView.center.x, self.mapView.center.y, RANGER_WIDTH, RANGER_HEIGHT)];
    self.rangerSquare.center = self.mapView.center;
    [self.mapView addSubview:self.rangerSquare];
    [self.rangersArray addObject:self.rangerSquare];
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
            [panGesture setTranslation:CGPointZero inView:self.view];
        }
    }
}

@end
