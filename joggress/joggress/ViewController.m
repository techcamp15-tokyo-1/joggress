//
//  ViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    IBOutlet UIProgressView *CivicVirtuePointBar;//公徳ポイントポイントバー
    IBOutlet UILabel *CivicVirtuePointText;
    IBOutlet UIProgressView *HungerBar;//空腹ゲージ
    IBOutlet UILabel *HungertText;
    int p;//空腹ゲージ減少量(仮) ＆ 時間

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    // タイマーを生成（0.1秒おきにdoTimer:メソッドを呼び出す）
   [CivicVirtuePointText setText:[NSString stringWithFormat:@"%6d/999999",(int)(CivicVirtuePointBar.progress*999999)]];
   [HungertText setText:[NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)]];
    p = 100;
    [NSTimer scheduledTimerWithTimeInterval:0.1f
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
    // プログレスバーのバーをのばす
    HungerBar.progress = (float)p / 100.0;
    [HungertText setText:[NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)]];
    p--;
    if (p < 0) {
        p=100;
        // タイマーを止める
        //[timer invalidate];
    }
}

@end
