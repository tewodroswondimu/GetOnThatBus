//
//  BusStopDetailsViewController.m
//  GetOnThatBus
//
//  Created by Tewodros Wondimu on 1/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "BusStopDetailsViewController.h"

@interface BusStopDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *busStopAddress;
@property (weak, nonatomic) IBOutlet UILabel *busStopRoutes;
@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;

@end

@implementation BusStopDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.busStop.busStopName;
    self.busStopAddress.text = self.busStop.busStopName;
    self.busStopRoutes.text = self.busStop.routes;
    self.directionsTextView.text = self.busStop.direction;
}

@end
