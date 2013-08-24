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

@interface ViewController : UIViewController<OinoriViewDelegate>
-(IBAction)oinoriPush:(id)sender;
-(IBAction)zissekiPush:(id)sender;
@end
