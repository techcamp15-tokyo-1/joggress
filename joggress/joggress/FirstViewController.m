//
//  FirstViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/28.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

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
    
    
//    [NSTimer scheduledTimerWithTimeInterval:5.0f
//                                     target:self
//                                   selector:@selector(doTimer:)
//                                   userInfo:nil
//                                    repeats:NO];
//
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePush:(id)sender
{
    [self performSegueWithIdentifier:@"ViewSegue" sender:self];
}


//- (void)doTimer:(NSTimer*)timer
//{
//    NSLog(@"Call Timer");
//    [self performSegueWithIdentifier:@"ViewSegue" sender:self];
//}
@end
