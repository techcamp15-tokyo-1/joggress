//
//  ViewController.m
//  joggress
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
    
    NSString *uiid=[[UIApplication sharedApplication] uniqueInstallationIdentifier];
    NSLog(@"%@",uiid);
    
    [AudioPlayer playAudio:@"01min" Type:@"mp3" Volume:0.1];
    [AudioPlayer showAlert:@"hoge" Message:@"huga\nあｓｄｆｇｈｊｋｌ；\nあｓｄｇｈｊｋｌｓｄｆ"];
    [AudioPlayer showAlert:@"hoge" Message:@"hugaあｓｇｈｊｋｌｓｄｆ"];
    [self SPCsetMyMessage:@"080のiPhoneだよ"];
    //[self SPCresetConnectedList];
    [self SPCstart];
    //[self SPCstop];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
