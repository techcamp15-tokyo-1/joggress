//
//  ViewController.h
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvaterManagement.h"
#import "Avater.h"
#import "OinoriViewController.h"
#import "StreetPassCommunicator.h"

@interface ViewController : StreetPassCommunicator<OinoriViewDelegate>
-(IBAction)oinoriPush:(id)sender;
-(IBAction)zissekiPush:(id)sender;

#define DeadKey @"isDead"
#define IDkey @"AvaterID"
#define PointKey @"NowCivicVirtuePoint"
#define HungerKey @"NowHunger"
#define DateKey @"Datekey"
#define DeadTimeKey @"DeadTime"
#define SPCListKey @"StreetPassCommunicatorKey"

extern const float Hunger_MAX;
extern const float Point_MAX;

@end
