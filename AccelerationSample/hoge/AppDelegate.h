//
//  AppDelegate.h
//  hoge
//
//  Created by techcamp on 2013/08/22.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeCounter.h"

@protocol KillCoreMotionDeligate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// デリゲート先で参照できるようにするためプロパティを定義しておく
@property (nonatomic, assign) id<KillCoreMotionDeligate> delegate;

@end
