//
//  OinoriViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "OinoriViewController.h"

@implementation OinoriViewController
{
    IBOutlet UILabel *ShakeCountLabel;
    NSTimer *timer;
    NSTimer *Viewtimer;
    bool ButtonFlag;
    ShakeCounter *sc;
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
    ButtonFlag = true;
    sc=[ShakeCounter everySeconds:0.1];
    [ShakeCountLabel setText:[NSString stringWithFormat:@""]];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:nil
                                    repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer: timer forMode:NSDefaultRunLoopMode];

    NSTimer *timerB = [NSTimer scheduledTimerWithTimeInterval:17.0f
                                             target:self
                                           selector:@selector(CloseTimer:)
                                           userInfo:nil
                                            repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer: timerB forMode:NSDefaultRunLoopMode];
    
    Viewtimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                       target:self
                                                     selector:@selector(ViewTimer:)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: Viewtimer forMode:NSDefaultRunLoopMode];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)respondToButtonClick:(id)sender
{
    if(!ButtonFlag) return;
    [timer invalidate];
    [Viewtimer invalidate];
    [sc stop];
    
    if ([_delegate respondsToSelector:@selector(finishView:)]){
        [_delegate finishView:_ShakeCount];
    }
    
    // 画面を閉じる処理
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)doTimer:(NSTimer*)_timer
{
    ButtonFlag = false;
    double time=10;
    
    [ShakeCountLabel setText:[NSString stringWithFormat:@"0"]];
    [sc startForSeconds:time];
}

-(void)CloseTimer:(NSTimer *)_timer
{
    _ShakeCount = [sc getCount];
    ShakeCountLabel.text = [NSString stringWithFormat:@"%d",_ShakeCount];
    NSLog(@"mag:%3d",[sc getCount]);

    [sc stop];
    ButtonFlag = true;
}

-(void)ViewTimer:(NSTimer *)_timer
{
    _ShakeCount = [sc getCount];
    ShakeCountLabel.text = [NSString stringWithFormat:@"%d",_ShakeCount];
    NSLog(@"mag:%3d",[sc getCount]);
}


@end
