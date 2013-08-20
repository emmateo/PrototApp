//
//  KPKViewController.h
//  PrototApp
//
//  Created by Enrique Martinez Mateo on 15/08/13.
//  Copyright (c) 2013 Enrique Martinez Mateo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface KPKViewController : UIViewController <UIAccelerometerDelegate>{
    NSDate *initDate;
    NSMutableString *stringLog;
    float valueX, valueY, valueZ;
    float oldValueX, oldValueY, oldValueZ;
}

@property (nonatomic, strong) IBOutlet UIButton *buttonMoving;

- (void)awakeAccelerometer;
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void)calculateMovement:(float)value4X plus:(float)value4Y plus:(float)value4Z;
- (void)moveThingy:(float)value4X with:(float)value4Y;
- (void)addRow2stringLog:(float)movement at:(float)timestamp;
- (void)eventOnPushButton;
- (IBAction)buttonAction:(id)sender;
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

@end
