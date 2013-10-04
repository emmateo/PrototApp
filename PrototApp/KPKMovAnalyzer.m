//
//  KPKMovAnalyzer.m
//  SiestApp
//
//  Created by Carlos Domínguez on 04/09/13.
//  Copyright (c) 2013 KePyKa. All rights reserved.
//

#import "KPKMovAnalyzer.h"

@implementation KPKMovAnalyzer

/*
  
 MATLAB code to be removed!
 
 frameSize = 15; % in seconds
 START_THRESHOLD = 1000; % Energy in frame threshols to detect start sleeping threshold
 END_THRESHOLD = 1500; % Energy in frame threshols to detect best wakeup moment
 MINIMUM_SLEEPING_TIME = 60*15; % in seconds
 MAXIMUM_SLEEPING_TIME = 60*60; % in seconds
 
 
 siestaStartFound = 0;
 siestaStartValue = 0; % in seconds
 
 siestaLimitFound = 0;
 siestaLimitValue = 0;
 
 EnergyFramesPlot = zeros(floor(max(siesta(:,2))/frameSize)+1,2);
 frameCounter = 1;
 
 startOfFrame = siesta(1,1);
 frameEnergy = 0;
 
 
 for counter=1:1:length(siesta(:,1))
 if (siesta(counter,1) - startOfFrame) < frameSize
 frameEnergy = frameEnergy + siesta(counter,2); % Add sample to frame
 else
 EnergyFramesPlot(frameCounter, 1) = siesta(counter,1);
 EnergyFramesPlot(frameCounter,2) = frameEnergy;
 frameCounter = frameCounter +1;
 if siestaStartFound == 0
 if frameEnergy < START_THRESHOLD
 siestaStartFound = 1;
 siestaStartValue = siesta(counter, 1);
 end
 elseif siestaLimitFound == 0
 if (frameEnergy > END_THRESHOLD) & ((siesta(counter,1) - siestaStartValue) > MINIMUM_SLEEPING_TIME)
 siestaLimitFound = 1;
 siestaLimitValue = siesta(counter, 1);
 end
 end
 
 if siesta(counter,1) > MAXIMUM_SLEEPING_TIME
 siestaLimitFound = 1;
 siestaLimitValue = siesta(counter, 1);
 end
 startOfFrame = siesta(counter,1); % Reset frame start
 frameEnergy = 0; % Reset frame energy
 end
 
 end
 
 */

/**
 * Constant definitions
 */
#define FRAME_SIZE      15           // in seconds
#define START_THRESHOLD 1000         // Energy in frame threshols to detect start sleeping threshold
#define END_THRESHOLD 1500           // Energy in frame threshols to detect best wakeup moment
#define MINIMUM_SLEEPING_TIME  60*15 // in seconds
#define MAXIMUM_SLEEPING_TIME  60*60 // in seconds

/**
 * Relevant variables in the movement analysis
 */

static Boolean siestaStartFound = false; // Indicates if the siesta beginning has been found
static double siestaStartValue = 0.0; // in seconds

static Boolean siestaLimitFound = false; // Indicates it the wakeup time has been found
static double siestaLimitValue = 0.0; // in seconds

static double currentFrameStart = 0.0; // in seconds
static double energyInCurrentFrame = 0.0; // Indicates the energy in the current frame

/*
 * timeStamp -> Value received from the gyroscope
 * movement -> Sum of all gyroscope components in absolute value
 * Return true if it is necessary to wake up the user
 * Return false otherwise
 */
-(Boolean) analyze:(double)movement at:(double)timeStamp {
    
    siestaLimitFound = false;
    
    if (currentFrameStart == 0.0) {
        currentFrameStart = timeStamp;
    }
    
    if ((timeStamp - currentFrameStart) < FRAME_SIZE) {
        energyInCurrentFrame = energyInCurrentFrame + movement; // Add sample to frame
    } else {
        
        if (siestaStartFound == false) {
            if (energyInCurrentFrame < START_THRESHOLD) {
                siestaStartFound = true;
                siestaStartValue = timeStamp;
            }
        } else if (siestaLimitFound == false) {
                if ((energyInCurrentFrame > END_THRESHOLD) &&
                    (timeStamp - siestaStartValue) > MINIMUM_SLEEPING_TIME){
                siestaLimitFound = true;
                siestaLimitValue = timeStamp;
            }
        }
                
        if ((timeStamp - siestaStartValue) > MAXIMUM_SLEEPING_TIME) {
            siestaLimitFound = true;
            siestaLimitValue = timeStamp;
        }
        currentFrameStart = timeStamp; // Reset frame start
        energyInCurrentFrame = 0.0; // Reset frame energy
        
    }

    return siestaLimitFound;
}

@end


