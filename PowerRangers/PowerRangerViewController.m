//
//  PowerRangerViewController.m
//  PowerRangers
//
//  Created by Suhail Rashid Bhat on 8/18/14.
//  Copyright (c) 2014 Suhail Rashid Bhat. All rights reserved.
//

#import "PowerRangerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    const NSInteger labelWidth = 150;
    const NSInteger labelHeight = 30;
    const NSInteger xOffsetRangerSquare = 10;
    const NSInteger xOffsetLabel = xOffsetRangerSquare + RANGER_WIDTH + 20;
    const NSInteger yOffset = 10;
    
    UITableViewCell* rangerCell  = nil;
    NSString *cellIdentifier = @"rangerSelectionCell";
    rangerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    self.powerRangerName = [[UILabel alloc] init];
    self.rangerSquare = [[PowerRanger alloc] initWithType:indexPath.row];
    if (rangerCell == nil) {
        rangerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [rangerCell addSubview:self.rangerSquare];
        [rangerCell addSubview:self.powerRangerName];
        
        [self.rangerSquare setFrame:CGRectMake(xOffsetRangerSquare, yOffset, RANGER_WIDTH, RANGER_HEIGHT)];
        [self.powerRangerName setFrame:CGRectMake(xOffsetLabel, yOffset, labelWidth, labelHeight)];
    }
    self.powerRangerName.text = self.rangerSquare.rangerName;
    return rangerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.rangerSquare = [[PowerRanger alloc] initWithType:indexPath.row];
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handlePan:)];
    [self.rangerSquare addGestureRecognizer:pgr];
    [self.rangerSquare setFrame:CGRectMake(self.mapView.center.x, self.mapView.center.y, RANGER_WIDTH, RANGER_HEIGHT)];
    self.rangerSquare.center = self.mapView.center;
    [self.mapView addSubview:self.rangerSquare];
}

-(void)handlePan:(UIPanGestureRecognizer*)pgr; {
    if (pgr.state == UIGestureRecognizerStateChanged) {
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        center = CGPointMake(center.x + translation.x,
                             center.y + translation.y);
        pgr.view.center = center;
        [pgr setTranslation:CGPointZero inView:pgr.view];
    }
}

@end
