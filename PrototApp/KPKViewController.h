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
#import "KPKMovAnalyzer.h"

@interface KPKViewController : UIViewController <UIAccelerometerDelegate>{
    NSDate *initDate;
    NSMutableString *stringLog;
    float valueX, valueY, valueZ;
    float oldValueX, oldValueY, oldValueZ;
    BOOL isButtonRecording;
    MFMailComposeViewController *mailer;
    BOOL logStarted;
    
    CGFloat userBrightness;
    KPKMovAnalyzer *algorythmAnalyzer;
}

@property (nonatomic, strong) IBOutlet UIButton *buttonMoving;
@property (strong, nonatomic) IBOutlet UIButton *outletButton;
@property (strong, nonatomic) IBOutlet UIButton *outletStopButton;
@property (strong, nonatomic) IBOutlet UIButton *outletSendLogButton;
@property (strong, nonatomic) IBOutlet UILabel *outletLabelexecution;
@property (strong, nonatomic) IBOutlet UILabel *outletLabelInfo;

- (void)awakeAccelerometer;
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void)calculateMovement:(float)value4X plus:(float)value4Y plus:(float)value4Z;
- (void)moveThingy:(float)value4X with:(float)value4Y;
- (void)addRow2stringLog:(float)movement at:(float)timestamp;
- (void)eventOnPushButton;
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
-(void) resetInterface;

- (IBAction)actionButton:(id)sender;
- (IBAction)actionStopButton:(id)sender;
- (IBAction)actionButtonSendLog:(id)sender;
-(void)switchButton:(int)sender;


@end
