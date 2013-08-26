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
#import "UIApplication+UIID.h"

const float Hunger_MAX = 999.0;
const float Point_MAX = 999.0;
const float CallTimerSpan = 5.0;

@interface ViewController ()

@end

@implementation ViewController
{
    IBOutlet UILabel *AvaterName;//アバター名
    IBOutlet UIProgressView *CivicVirtuePointBar;//公徳ポイントポイントバー
    IBOutlet UILabel *CivicVirtuePointText;
    IBOutlet UIProgressView *HungerBar;//空腹ゲージ
    IBOutlet UILabel *HungertText;
    int messageCount;
    NSDate *PrevDate;
    IBOutlet UIImageView *ImageView;//アバター画像表示
    NSString *ImagePath;
    AvaterManagement *AM;
    Avater *avater;
    NSTimer *MainTimer;
    bool Dead;
    NSDate *DeadTime;
    NSString *SendMessage;
}

+ (void)initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionaryWithCapacity:6];
    [defaultValues setValue:false forKey:DeadKey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:IDkey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:PointKey];
    [defaultValues setValue:[NSNumber numberWithInteger:Hunger_MAX] forKey:HungerKey];
    [defaultValues setObject:[NSDate date] forKey:DateKey];
    [defaultValues setObject:[NSDate date] forKey:DeadTimeKey];
    [defaultValues setObject:[NSDictionary dictionary] forKey:SPCListKey];
    
    NSUserDefaults *savedata = [NSUserDefaults standardUserDefaults];
    [savedata registerDefaults:defaultValues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// 全アバター設定
    AM = [[AvaterManagement alloc] init];
    
    //現在のアバターの設定
    NSUserDefaults *savedata = [NSUserDefaults standardUserDefaults];
    avater = [AM Avater:[[savedata stringForKey:IDkey] intValue]];
    avater.CivicVirtuePoint = [[savedata stringForKey:PointKey] intValue];
    avater.Hunger = [[savedata stringForKey:HungerKey]intValue];
    Dead = [savedata boolForKey:DeadKey];
    if(!Dead){
        AvaterName.text = [NSString stringWithFormat:@"%@",avater.AvaterName];
        NSString *ImageName = [NSString stringWithFormat:@"%@.%@",avater.ImageName,@"png"];
        ImageView.image = [UIImage imageNamed:ImageName];
        CivicVirtuePointBar.progress = (double)avater.CivicVirtuePoint/Point_MAX;
        HungerBar.progress = (double)avater.Hunger/Hunger_MAX;
    }else{
        AvaterName.text = [NSString stringWithFormat:@"ユウレイ"];
        NSString *ImageName = [NSString stringWithFormat:@"ghost.%@",@"png"];
        ImageView.image = [UIImage imageNamed:ImageName];
        CivicVirtuePointBar.progress = 0;
        HungerBar.progress = Hunger_MAX;
    }
    
    //すれ違いログの設定
    //NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:[savedata dataForKey:SPCListKey]]);
    [self SPCsetConnectedList:[[savedata dictionaryForKey:SPCListKey] mutableCopy]] ;
    
    //一度呼び出す
    [self subTimer:false];

    // タイマーを生成（0.1秒おきにdoTimer:メソッドを呼び出す）
    CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*Point_MAX)];
    HungertText.text = [NSString stringWithFormat:@"%3d/999",(int)(HungerBar.progress*Hunger_MAX)];
    PrevDate = [savedata objectForKey:DateKey];
    DeadTime = [savedata objectForKey:DeadTimeKey];
    messageCount = -1;
    MainTimer = [NSTimer scheduledTimerWithTimeInterval:CallTimerSpan
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:nil
                                    repeats:YES];
    
    //通信設定
    SendMessage = [NSString stringWithFormat:@"%d,%d",avater.ID,avater.Hunger!=Hunger_MAX];
    [self SPCsetMyMessage:SendMessage];
    [self SPCstart];
}

// save
-(void) save
{
    NSUserDefaults *savedata = [NSUserDefaults standardUserDefaults];
    [savedata setBool:Dead forKey:DeadKey];
    [savedata setValue:[NSNumber numberWithInteger:avater.ID] forKey:IDkey];
    [savedata setValue:[NSNumber numberWithInteger:avater.CivicVirtuePoint] forKey:PointKey];
    [savedata setValue:[NSNumber numberWithInteger:avater.Hunger] forKey:HungerKey];
    [savedata setObject:PrevDate forKey:DateKey];
    [savedata setObject:DeadTime forKey:DeadTimeKey];
    [savedata setObject:[self SPCgetConnectedList] forKey:SPCListKey];
    [savedata synchronize];
    
//    NSLog(@"%d",[savedata boolForKey:DeadKey]);
//    NSLog(@"%d",[[savedata stringForKey:IDkey]intValue]);
//    NSLog(@"%d",[[savedata stringForKey:PointKey]intValue]);
//    NSLog(@"%d",[[savedata stringForKey:HungerKey]intValue]);
//    NSLog([[savedata objectForKey:DateKey] description]);
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
        messageCount = 0;
        return;
    }
    [MainTimer invalidate];//タイマー一時停止
    [self performSegueWithIdentifier:@"oinoriSegue" sender:self];
}

//実績ボタンを押した時
-(IBAction)zissekiPush:(id)sender
{
    [self performSegueWithIdentifier:@"zissekiSegue" sender:self];    
}

//ページ遷移が起こった時
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"oinoriSegue"]) {
        OinoriViewController *viewCon = segue.destinationViewController;
        viewCon.delegate = self;
        viewCon.nowPoint = avater.CivicVirtuePoint;
        viewCon.PointIncrement = avater.CivicVirtuePointIncrement;
    }
}

//お祈りモードから帰ってきた時
- (void)finishView:(int)returnValue{
    avater.CivicVirtuePoint += returnValue;
    if(avater.CivicVirtuePoint>Point_MAX) avater.CivicVirtuePoint = Point_MAX;
    CivicVirtuePointBar.progress = (double)avater.CivicVirtuePoint/Point_MAX;
    CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*Point_MAX)];
    NSLog(@"returnValue %d" , returnValue);
    
    MainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:nil
                                    repeats:YES];
    
}

// 一定時間ごとに呼ばれるメソッド
- (void)doTimer:(NSTimer *)timer
{
    [self subTimer:true];
}

- (void) subTimer:(bool) flag{
    NSDate *Date = [NSDate date];
    float tmp= [Date timeIntervalSinceDate:PrevDate];
    PrevDate = Date;
    
    // 通信が起きていた場合
    if ([self SPCgetCommListSize] > 0) {
        [self ReceiveMessage];
        return;
    }
    
    if(!Dead){//生きている場合
        //NSLog(@"case1");
        //餓死判定
        if (avater.Hunger < 0) {
            [KGStatusBar showWithStatus:@"餓死しました"];
            Dead = true;
            DeadTime = [NSDate date];
            messageCount = 0;
            int ID = [avater Reincarnation:FALSE];
            //現在のアバターの設定
            avater = [AM Avater:ID];
            AvaterName.text = [NSString stringWithFormat:@"ユウレイ"];
            NSString *ImageName = [NSString stringWithFormat:@"ghost.%@",@"png"];
            ImageView.image = [UIImage imageNamed:ImageName];
            CivicVirtuePointBar.progress = 0;
            HungerBar.progress = Hunger_MAX;
            CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*Point_MAX)];
            HungertText.text = [NSString stringWithFormat:@"%3d/999",(int)(HungerBar.progress*Hunger_MAX)];
        } else {
            if(flag) avater.Hunger-=(int)(tmp+0.5)/CallTimerSpan * avater.HungerDecrement;
            SendMessage = [NSString stringWithFormat:@"%d,%d",avater.ID,avater.Hunger!=Hunger_MAX];
            [self SPCsetMyMessage:SendMessage];

        }
        
        // バーの処理
        HungerBar.progress = (double)avater.Hunger / Hunger_MAX;
        HungertText.text = [NSString stringWithFormat:@"%3d/999",(int)(HungerBar.progress*Hunger_MAX)];
    } else {//死んでいる場合
        //NSLog(@"case2");
        tmp = [Date timeIntervalSinceDate:DeadTime];
        if((int)(tmp+0.5) > 10){
            [KGStatusBar showWithStatus:[NSString stringWithFormat:@"%@に転生しました",avater.AvaterName]];
            [self SPCstart];
            Dead = false;
            messageCount = 0;
            //現在のアバターの設定
            AvaterName.text = [NSString stringWithFormat:@"%@",avater.AvaterName];
            NSString *ImageName = [NSString stringWithFormat:@"%@.%@",avater.ImageName,@"png"];
            ImageView.image = [UIImage imageNamed:ImageName];
        }
    }
    
    // メッセージの消去判定
    if(messageCount>=0){
        messageCount++;
        if(messageCount==4){
            [KGStatusBar dismiss];
            messageCount=-1;
        }
    }
    
    [self save];

}

- (void) ReceiveMessage
{
    while ([self SPCgetCommListSize] > 0 && !Dead) {// メッセージが空になるまで かつ 生きている間
        // メッセージをCSVで受理 配列に格納
        NSArray *message = [[self SPCgetCommMessage] componentsSeparatedByString:@","];
        int SPCAvaterID = [message[0] intValue];
        bool Eat = [message[0] boolValue];
        
        if(avater.Hunger != Hunger_MAX && [avater Predation:SPCAvaterID]){// 捕食
            [KGStatusBar showWithStatus:@"捕食しました"];
            avater.Hunger += 200;
            if(avater.Hunger > Hunger_MAX) avater.Hunger = Hunger_MAX;
            HungerBar.progress = (double)avater.Hunger / Hunger_MAX;
            HungertText.text = [NSString stringWithFormat:@"%3d/999",(int)(HungerBar.progress*Hunger_MAX)];
        } else if(Eat && [avater UnPredation:SPCAvaterID]){// 被食
            [KGStatusBar showWithStatus:@"捕食されました"];
            [self SPCstop];
            Dead = true;
            DeadTime = [NSDate date];
            int ID = [avater Reincarnation:TRUE];
            //現在のアバターの設定
            avater = [AM Avater:ID];
            AvaterName.text = [NSString stringWithFormat:@"ユウレイ"];
            NSString *ImageName = [NSString stringWithFormat:@"ghost.%@",@"png"];
            ImageView.image = [UIImage imageNamed:ImageName];
            CivicVirtuePointBar.progress = 0;
            HungerBar.progress = Hunger_MAX;
            CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*Point_MAX)];
            HungertText.text = [NSString stringWithFormat:@"%3d/999",(int)(HungerBar.progress*Hunger_MAX)];
        } else {// その他
            [KGStatusBar showWithStatus:@"すれ違い 公徳ポイントゲット"];
            avater.CivicVirtuePoint += 100;
            if(avater.CivicVirtuePoint>Point_MAX) avater.CivicVirtuePoint = Point_MAX;
            CivicVirtuePointBar.progress = (double)avater.CivicVirtuePoint/Point_MAX;
            CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*Point_MAX)];
        }
    }
    
    while ([self SPCgetCommListSize] > 0) [self SPCgetCommMessage];
    messageCount = 0;
    SendMessage = [NSString stringWithFormat:@"%d,%d",avater.ID,avater.Hunger!=Hunger_MAX];
    [self SPCsetMyMessage:SendMessage];
    [self save];
}

@end
