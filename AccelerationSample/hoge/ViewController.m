//
//  ViewController.m
//  hoge
//
//  Created by techcamp on 2013/08/22.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    double cycle=0.1;
    double time=100;
    
    ShakeCounter *sc=[ShakeCounter everySeconds:cycle];
    //self->motionManager=(CMMotionManager*)[sc getCMM];
    [sc startForSeconds:time];
    
    /*
    //[sc stop];
    NSLog(@"end.and restart");
    
    [sc startForSeconds:time];
    
    while(![sc isEnded]){
        NSLog(@"mag:%3f",[sc getAccSize]);
    }
    NSLog(@"end");
    [sc stop];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
