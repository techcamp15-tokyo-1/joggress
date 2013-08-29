//
//  HelpViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/29.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "HelpViewController.h"

@implementation HelpViewController
{
    IBOutlet UIButton *CloseButton;
    IBOutlet UITextView * textView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [CloseButton.titleLabel setFont:[UIFont fontWithName:@"MisakiGothic" size:20.0]];
    [textView setFont:[UIFont fontWithName:@"MisakiGothic" size:20.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)respondToButtonClick:(id)sender
{
    // 画面を閉じる処理
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
