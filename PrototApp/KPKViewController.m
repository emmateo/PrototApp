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

//Calculate movement
-(void)calculateMovement:(float)value4X plus:(float)value4Y plus:(float)value4Z
{
    //Initialise auxiliar variables
    float diffX;
    float diffY;
    float diffZ;
    
    //Calculate amount of movement
    diffX = fabsf(valueX - oldValueX);
    diffY = fabsf(valueY - oldValueY);
    diffZ = fabsf(valueZ - oldValueZ);
    
    //Set nex oldValues
    oldValueX = valueX;
    oldValueY = valueY;
    oldValueZ = valueZ;
    
    //Time offset from the begining
    NSDate *currDate = [NSDate date];
    NSTimeInterval offset = [currDate timeIntervalSinceDate:initDate];
    
    float totMovement = (diffX + diffY + diffZ);
    
    //Print results
    printf("%f;%f;\n", offset, totMovement);
}

-(void)moveThingy:(float)value4X with:(float)value4Y
{
    #define MOVING_OBJECT_RADIUS 34
    
    //Create new Integer
    int intPlayerNewX = (int)(buttonMoving.center.x + valueX);
    int intPlayerNewY = (int)(buttonMoving.center.y - valueY);
    
    //Position validation
    if(intPlayerNewX > (320  - MOVING_OBJECT_RADIUS))
    {
        intPlayerNewX = (320 - MOVING_OBJECT_RADIUS);
    }
    if(intPlayerNewX < (0 + MOVING_OBJECT_RADIUS))
    {
        intPlayerNewX = (0 + MOVING_OBJECT_RADIUS);
    }
    
    if(intPlayerNewY > (460 - MOVING_OBJECT_RADIUS))
    {
        intPlayerNewY = (460 - MOVING_OBJECT_RADIUS);
    }
    if(intPlayerNewY < (0 + MOVING_OBJECT_RADIUS))
    {
        intPlayerNewY = (0 + MOVING_OBJECT_RADIUS);
    }
    
    //Make the new point
    CGPoint buttonNewCenter = CGPointMake(intPlayerNewX, intPlayerNewY);
    buttonMoving.center = buttonNewCenter;
    
}

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
    //Acceleration for player
    valueX = acceleration.x * 45.0;
    valueY = acceleration.y * 45.0;
    valueZ = acceleration.z * 45.0;
    
    //Calculate movement
    [self calculateMovement:valueX plus:valueY plus:valueZ];
    
    //Move the thing of the screen
    [self moveThingy:valueX with:valueY];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    initDate = [[NSDate alloc] init];
    oldValueX = 0; oldValueY = 0; valueZ = 0;
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
