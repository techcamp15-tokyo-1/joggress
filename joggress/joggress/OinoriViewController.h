//
//  OinoriViewController.h
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

// お祈りモード

#import <UIKit/UIKit.h>
#import "ShakeCounter.h"
#import <AudioToolbox/AudioToolbox.h>

@protocol OinoriViewDelegate
- (void)finishView:(int)returnValue;
@end

@interface OinoriViewController : UIViewController

@property int ShakeCount;
@property int nowPoint;
@property int PointIncrement;
@property (nonatomic) id delegate;
- (IBAction)respondToButtonClick:(id)sender;

@end
