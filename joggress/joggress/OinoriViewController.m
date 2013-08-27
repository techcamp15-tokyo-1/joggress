//
//  OinoriViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "OinoriViewController.h"
#import "ViewController.h"

@implementation OinoriViewController
{
    IBOutlet UIProgressView * bar;
    IBOutlet UILabel *ShakeCountLabel;
    IBOutlet UILabel *InfoLabel;
    NSTimer *timer;
    NSTimer *Viewtimer;
    bool ButtonFlag;
    ShakeCounter *sc;
    int Count;
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
    double point = (_ShakeCount = _nowPoint);
    bar.progress = point/Point_MAX;
    ButtonFlag = false;
    sc=[ShakeCounter everySeconds:0.1];
    ShakeCountLabel.text = [NSString stringWithFormat:@""];
    ShakeCountLabel.textAlignment = NSTextAlignmentCenter;//中央揃え
    InfoLabel.text = @"5";
    InfoLabel.textAlignment = NSTextAlignmentCenter;

    //回数描画用タイマー
    Viewtimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                 target:self
                                               selector:@selector(ViewTimer:)
                                               userInfo:nil
                                                repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: Viewtimer forMode:NSDefaultRunLoopMode];
    
    //カウントダウン用タイマー
    Count=5;    
    NSTimer *CountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(CountDown:)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: CountDownTimer forMode:NSDefaultRunLoopMode];
    
    //お祈りイベント用タイマー
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                             target:self
                                           selector:@selector(doTimer:)
                                           userInfo:nil
                                            repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode:NSDefaultRunLoopMode];
    
    
    //お祈り終了用タイマー
    NSTimer *timerB = [NSTimer scheduledTimerWithTimeInterval:17.0f
                                                       target:self
                                                     selector:@selector(CloseTimer:)
                                                     userInfo:nil
                                                      repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer: timerB forMode:NSDefaultRunLoopMode];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)respondToButtonClick:(id)sender
{
    if(!ButtonFlag) return;
    _ShakeCount = [sc getCount] * _PointIncrement + _nowPoint;
    [timer invalidate];
    [Viewtimer invalidate];
    [sc stop];
    
    if ([_delegate respondsToSelector:@selector(finishView:)]){
        [_delegate finishView:_ShakeCount];
    }
    
    _ShakeCount = 0;
    // 画面を閉じる処理
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)CountDown:(NSTimer*)_timer
{
    InfoLabel.text = [NSString stringWithFormat:@"%d",--Count];
    NSLog(@"%d",Count);
    if(Count==0) [_timer invalidate];
}

-(void)doTimer:(NSTimer*)_timer
{
    double time=10;
    InfoLabel.text = @"祈れ!!!";
    ShakeCountLabel.text = [NSString stringWithFormat:@"0"];
    [sc startForSeconds:time];
    NSLog(@"Start!");
}

-(void)CloseTimer:(NSTimer*)_timer
{
    InfoLabel.text = @"終了";
    ShakeCountLabel.text = [NSString stringWithFormat:@"%d",[sc getCount]];
    double point = [sc getCount]*_PointIncrement + _nowPoint;
    bar.progress = point/Point_MAX;
    NSLog(@"mag:%3d",[sc getCount]);
    [sc stop];
    ButtonFlag = true;
}

-(void)ViewTimer:(NSTimer*)_timer
{
    double point = [sc getCount]*_PointIncrement + _nowPoint;
    bar.progress = point/Point_MAX;
    ShakeCountLabel.text = [NSString stringWithFormat:@"%d",[sc getCount]];
//    NSLog(@"mag:%3d",[sc getCount]);
}


@end
