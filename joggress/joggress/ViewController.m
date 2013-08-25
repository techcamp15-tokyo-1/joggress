//
//  ViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "ViewController.h"
#import "KGStatusBar.h"
#import "OinoriViewController.h"

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
    NSTimer *MainTimer;
    bool Dead;
    NSDate *DeadTime;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// 全アバター設定
    AM = [[AvaterManagement alloc] init];
    
    //現在のアバターの設定
    avater = [AM Avater:0];
    AvaterName.text = [NSString stringWithFormat:@"%@",avater.AvaterName];
    NSString *ImageName = [NSString stringWithFormat:@"%@.%@",avater.ImageName,@"png"];
    ImageView.image = [UIImage imageNamed:ImageName];
    Dead = false;

    // タイマーを生成（0.1秒おきにdoTimer:メソッドを呼び出す）
    CivicVirtuePointBar.progress = (double)avater.CivicVirtuePoint/999;
    HungerBar.progress = (double)avater.Hunger/100;
    CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*999)];
    HungertText.text = [NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)];
    PrevDate = [NSDate date];
    message = -1;
    MainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
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

//お祈りボタンを押した時
-(IBAction)oinoriPush:(id)sender
{
    if(Dead){
        [KGStatusBar showWithStatus:@"現在お祈り出来ません"];
        message = 0;
        return;
    }
    [MainTimer invalidate];
    [self performSegueWithIdentifier:@"oinoriSegue" sender:self];
}

//実績ボタンを押した時
-(IBAction)zissekiPush:(id)sender
{
    [self performSegueWithIdentifier:@"zissekiSegue" sender:self];    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"oinoriSegue"]) {
        OinoriViewController *viewCon = segue.destinationViewController;
        viewCon.delegate = self;
        viewCon.nowPoint = avater.CivicVirtuePoint;
        viewCon.PointIncrement = avater.CivicVirtuePointIncrement;
    }
}

- (void)finishView:(int)returnValue{
    avater.CivicVirtuePoint += returnValue;
    if(avater.CivicVirtuePoint>999) avater.CivicVirtuePoint = 999;
    CivicVirtuePointBar.progress = (double)avater.CivicVirtuePoint/999.0;
    CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*999)];
    NSLog(@"returnValue %d" , returnValue);
    
    MainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:nil
                                    repeats:YES];
    
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
    
    if(!Dead){//生きている場合
        //餓死判定
        if (avater.Hunger < 0) {
            [KGStatusBar showWithStatus:@"餓死しました"];
            Dead = true;
            DeadTime = [NSDate date];
            message = 0;
            int ID = [avater Reincarnation:FALSE];
            //現在のアバターの設定
            avater = [AM Avater:ID];
            AvaterName.text = [NSString stringWithFormat:@"ユウレイ"];
            NSString *ImageName = [NSString stringWithFormat:@"ghost.%@",@"png"];
            ImageView.image = [UIImage imageNamed:ImageName];
            CivicVirtuePointBar.progress = 0;
            HungerBar.progress = 100;
            CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*999)];
            HungertText.text = [NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)];
        } else {
            avater.Hunger-=(int)(tmp+0.5)/1.0 * avater.HungerDecrement;
        }
        
        // バーの処理
        HungerBar.progress = (double)avater.Hunger / 100.0;
        HungertText.text = [NSString stringWithFormat:@"%3d/100",(int)(HungerBar.progress*100)];
    } else {//死んでいる場合
        tmp = [Date timeIntervalSinceDate:DeadTime];
        if(tmp > 10){
            [KGStatusBar showWithStatus:[NSString stringWithFormat:@"%@に転生しました",avater.AvaterName]];
            Dead = false;
            message = 0;
            //現在のアバターの設定
            AvaterName.text = [NSString stringWithFormat:@"%@",avater.AvaterName];
            NSString *ImageName = [NSString stringWithFormat:@"%@.%@",avater.ImageName,@"png"];
            ImageView.image = [UIImage imageNamed:ImageName];
        }
    }
    
    if(message>=0){
        message++;
        if(message==4){
            [KGStatusBar dismiss];
            message=-1;
        }
    }
}


@end
