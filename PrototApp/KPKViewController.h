//
//  KPKViewController.h
//  PrototApp
//
//  Created by Enrique Martinez Mateo on 15/08/13.
//  Copyright (c) 2013 Enrique Martinez Mateo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPKViewController : UIViewController <UIAccelerometerDelegate>{
    float valueX, valueY;
}

@property (nonatomic, strong) IBOutlet UIButton *buttonMoving;

-(void)awakeAccelerometer;
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

@end
