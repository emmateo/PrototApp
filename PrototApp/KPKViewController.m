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
- (void)calculateMovement:(float)value4X plus:(float)value4Y plus:(float)value4Z
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
    
    //Compute amount of movement
    float totMovement = (diffX + diffY + diffZ);
    
    //Insert corrent line into log
    [self addRow2stringLog:totMovement at:offset];
    
    //Print results
    //printf("%f;%f;\n", offset, totMovement);
}

- (void)addRow2stringLog:(float)movement at:(float)timestamp
{
    //Add a row to the stringLog
    [stringLog appendFormat:@"%f,%f;\r", timestamp, movement];
}

- (void)moveThingy:(float)value4X with:(float)value4Y
{
    #define MOVING_OBJECT_RADIUS 9
    
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
- (void)awakeAccelerometer
{
    //Start accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/60.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    NSLog(@"Accelerometer started");
}

//Accelerometer movement
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
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
    
    //Initialise CSV with header
    stringLog = [NSMutableString stringWithString:@"Timestamp,Movement;\r"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self awakeAccelerometer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //Kill the accelerometer
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    //Time offset from the begining
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm"];
    NSString *formattedDateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"formattedDateString: %@", formattedDateString);
    
    //Set filename
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *fileName = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"sleepingLog_%@.csv", formattedDateString]];
    NSError *error;
    
    //Create the file
    BOOL res = [stringLog writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    //Check completion
    if (!res) {
        NSLog(@"Error %@ while writing to file %@", [error localizedDescription], fileName );
    }else{
        NSLog(@"File: %@ was created.", fileName);
    }
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:[NSString stringWithFormat:@"[SiestApp] SleepingLog \%@", formattedDateString]];
    
    NSArray *toRecipents = [NSArray arrayWithObjects:@"enriquemmateo@gmail.com",@"carlosdominguez6@gmail.com", nil];
    [mailer setMessageBody:@"This is the automatic log sent from SiestApp prototype..." isHTML:NO];
    [mailer setToRecipients:toRecipents];
    
    // Get the resource path and read the file using NSData
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    [mailer addAttachmentData:fileData mimeType:@"text/csv" fileName:fileName];
    
    //Launch mail
    [self presentViewController:mailer animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
