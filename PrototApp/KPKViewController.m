//
//  KPKViewController.m
//  PrototApp
//
//  Created by Enrique Martinez Mateo on 15/08/13.
//  Copyright (c) 2013 Enrique Martinez Mateo. All rights reserved.
//

#import "KPKViewController.h"

@interface KPKViewController ()

@end

@implementation KPKViewController

//Synteshis
@synthesize buttonMoving;

//AwakeAccelerometer
-(void)awakeAccelerometer
{
    //Start accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/60.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    NSLog(@"Accelerometer started");
}

//Accelerometer movement
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    #define MOVING_OBJECT_RADIUS 34
    
    //Acceleration for player
    valueX = acceleration.x * 45.0;
    valueY = acceleration.y * 45.0;
    
    //Create new Integer
    int intPlayerNewX = (int)(buttonMoving.center.x + valueX);
    int intPlayerNewY = (int)(buttonMoving.center.y + valueY);

    //Position validation
    if(intPlayerNewX > (320  - MOVING_OBJECT_RADIUS))
    {
        intPlayerNewX = (320  - MOVING_OBJECT_RADIUS);
    }
    if(intPlayerNewX < (0 + MOVING_OBJECT_RADIUS))
    {
        intPlayerNewX = (0 + MOVING_OBJECT_RADIUS);
    }
    
    if(intPlayerNewY > (480  - MOVING_OBJECT_RADIUS))
    {
         intPlayerNewY = (480  - MOVING_OBJECT_RADIUS);
    }
    if(intPlayerNewY < (0 + MOVING_OBJECT_RADIUS))
    {
        intPlayerNewY = (0 + MOVING_OBJECT_RADIUS);
    }
    
    //Make the new point
    CGPoint buttonNewCenter = CGPointMake(intPlayerNewX, intPlayerNewY);
    buttonMoving.center = buttonNewCenter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self awakeAccelerometer];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //Kill the accelerometer
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
