//
//  ViewController.h
//  hoge
//
//  Created by techcamp on 2013/08/22.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeCounter.h"

@interface ViewController : UIViewController{
    CMMotionManager *motionManager;//加速度センサマネージャ
}
@end
