//
//  ViewController.m
//  huga_ippei
//
//  Created by techcamp on 2013/08/23.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import "ViewController.h"
#import "StreetPassCommunicator.h"

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self SPCsetMyMessage:@"一平のiPhoneだよ"];
    [self SPCresetConnectedList];
    [self SPCstart];
    //[self SPCstop];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
