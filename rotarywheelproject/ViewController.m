//
//  ViewController.m
//  rotarywheelproject
//
//  Created by Patrick Cooke on 7/16/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

#import "ViewController.h"
#import "RotaryWheel.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize sectorLabel;

- (void) wheelDidChangeValue:(NSString *)newValue {
    self.sectorLabel.text = newValue;
}


#pragma mark Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 60, self.view.center.y  + 125, 120, 30)];
    sectorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sectorLabel];
    RotaryWheel *wheel = [[RotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 200, 200) andDelegate:self withSections:4];
     wheel.center = CGPointMake(self.view.center.x , self.view.center.y);
    [self.view addSubview:wheel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
