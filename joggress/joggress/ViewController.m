//
//  ViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "ViewController.h"
#import "KGStatusBar.h"

@interface ViewController ()

@end

@implementation ViewController
{
    IBOutlet UIProgressView *CivicVirtuePointBar;//公徳ポイントポイントバー
    IBOutlet UILabel *CivicVirtuePointText;
    IBOutlet UIProgressView *HungerBar;//空腹ゲージ
    IBOutlet UILabel *HungertText;
    int p;//空腹ゲージ減少量(仮) ＆ 時間
    int message;
    NSDate *PrevDate;
    IBOutlet UIImageView *ImageView;//アバター画像表示
    NSString *ImagePath;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *ImageName = @"akaichi.png";
    ImageView.image = [UIImage imageNamed:ImageName];

    // タイマーを生成（0.1秒おきにdoTimer:メソッドを呼び出す）
    [CivicVirtuePointText setText:[NSString stringWithFormat:@"%6d/999999",(int)(CivicVirtuePointBar.progress*999999)]];
    [HungertText setText:[NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)]];
    p = 100;
    PrevDate = [NSDate date];
    message = -1;
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:nil
                                    repeats:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 指定時間後にタイマーから呼ばれる
 * @param timer 呼び出し元のNSTimerオブジェクト
 */
- (void)doTimer:(NSTimer *)timer
{
    NSDate *Date = [NSDate date];
    float tmp= [Date timeIntervalSinceDate:PrevDate];
    //NSLog (@"%f" ,tmp);
    PrevDate = Date;
    // バーの処理
    HungerBar.progress = (float)p / 100.0;
    [HungertText setText:[NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)]];
    p-=(int)(tmp+0.5)/1.0;
    //p-=10;
    
    if(message>=0){
        message++;
        if(message==4){
            [KGStatusBar dismiss];
            message=-1;
        }
    }
    
    if (p < 0) {
        p=100;
        [KGStatusBar showWithStatus:@"死にました"];
        message = 0;
    }
}


@end
