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
    IBOutlet UILabel *AvaterName;//アバター名
    IBOutlet UIProgressView *CivicVirtuePointBar;//公徳ポイントポイントバー
    IBOutlet UILabel *CivicVirtuePointText;
    IBOutlet UIProgressView *HungerBar;//空腹ゲージ
    IBOutlet UILabel *HungertText;
    int message;
    NSDate *PrevDate;
    IBOutlet UIImageView *ImageView;//アバター画像表示
    NSString *ImagePath;
    AvaterManagement *AM;
    Avater *avater;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// 全アバター設定
    AM = [[AvaterManagement alloc] init];
    
    //現在のアバターの設定
    avater = [AM Avater:0];
    [AvaterName setText:[NSString stringWithFormat:@"%@",avater.AvaterName]];
    NSString *ImageName = [NSString stringWithFormat:@"%@.%@",avater.ImageName,@"png"];
    ImageView.image = [UIImage imageNamed:ImageName];

    // タイマーを生成（0.1秒おきにdoTimer:メソッドを呼び出す）
    CivicVirtuePointBar.progress = (double)avater.CivicVirtuePoint/999999;
    HungerBar.progress = (double)avater.Hunger/100;
    [CivicVirtuePointText setText:[NSString stringWithFormat:@"%6d/999999",(int)(CivicVirtuePointBar.progress*999999)]];
    [HungertText setText:[NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)]];
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
    PrevDate = Date;
    
    // バーの処理
    HungerBar.progress = (double)avater.Hunger / 100.0;
    [HungertText setText:[NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)]];
    
    if(message>=0){
        message++;
        if(message==4){
            [KGStatusBar dismiss];
            message=-1;
        }
    }
    
    if (avater.Hunger < 0) {
        [KGStatusBar showWithStatus:@"餓死しました"];
        message = 0;
        int ID = [avater Reincarnation:FALSE];
        //現在のアバターの設定
        avater = [AM Avater:ID];
        [AvaterName setText:[NSString stringWithFormat:@"%@",avater.AvaterName]];
        NSString *ImageName = [NSString stringWithFormat:@"%@.%@",avater.ImageName,@"png"];
        ImageView.image = [UIImage imageNamed:ImageName];
        HungerBar.progress = (double)avater.Hunger/100;
        [CivicVirtuePointText setText:[NSString stringWithFormat:@"%6d/999999",(int)(CivicVirtuePointBar.progress*999999)]];
        [HungertText setText:[NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)]];
    } else {
        avater.Hunger-=(int)(tmp+0.5)/1.0 * avater.HungerDecrement;
    }
}


@end
