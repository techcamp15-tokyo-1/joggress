//
//  ViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "ViewController.h"
#import "KGStatusBar.h"
#import "UIApplication+UIID.h"

const float Hunger_MAX = 999.0;
const float Point_MAX = 999.0;
const float CallTimerSpan = 5.0;
const int zisseki_NUM = 30;

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
    bool OinoriFlag;
    int zissekiFlag;
    int ReincarnationAvaterList;
    int SPCAvaterList;
    int ogurai;
    int ninkimono;
    int checkZisseki;
}

+ (void)initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionaryWithCapacity:13];
    [defaultValues setValue:[NSNumber numberWithBool:false] forKey:DeadKey];
    [defaultValues setValue:[NSNumber numberWithBool:true] forKey:OinoriKey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:IDkey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:PointKey];
    [defaultValues setValue:[NSNumber numberWithInteger:Hunger_MAX] forKey:HungerKey];
    [defaultValues setObject:[NSDate date] forKey:DateKey];
    [defaultValues setObject:[NSDate date] forKey:DeadTimeKey];
    [defaultValues setObject:[NSDictionary dictionary] forKey:SPCListKey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:ZissekiKey];
    [defaultValues setValue:[NSNumber numberWithInteger:1] forKey:RALKey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:SPCALKey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:OguraiKey];
    [defaultValues setValue:[NSNumber numberWithInteger:0] forKey:NinkimonoKey];

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
    SPCAvaterList = [[savedata stringForKey:SPCALKey] intValue];
    
    //お祈り可能かどうかのフラグ設定
    PrevDate = [savedata objectForKey:DateKey];
    DeadTime = [savedata objectForKey:DeadTimeKey];    
    OinoriFlag = [savedata boolForKey:OinoriKey];
    
    //実績の設定
    zissekiFlag = checkZisseki = [[savedata stringForKey:ZissekiKey] intValue];
    ogurai  = [[savedata stringForKey:OguraiKey] intValue];
    ninkimono  = [[savedata stringForKey:NinkimonoKey] intValue];
    
    //転生したアバター設定
    ReincarnationAvaterList = [[savedata stringForKey:RALKey] intValue];
    
    
    //一度呼び出す
    [self subTimer:false];

    // タイマーを生成（CallTimerSpan秒おきにdoTimer:メソッドを呼び出す）
    CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*Point_MAX)];
    HungertText.text = [NSString stringWithFormat:@"%3d/999",(int)(HungerBar.progress*Hunger_MAX)];
    messageCount = -1;
    MainTimer = [NSTimer scheduledTimerWithTimeInterval:CallTimerSpan
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:nil
                                    repeats:YES];
    
    //通信設定
    SendMessage = [NSString stringWithFormat:@"%d,%d",avater.ID,avater.Hunger!=Hunger_MAX];
    [self SPCsetMyMessage:SendMessage];
    if(!Dead) [self SPCstart];
}

// save
-(void) save
{
    
    if(zissekiFlag == 1 << 29 -1) zissekiFlag |= 1 << 29;//全実績解放フラグ
    
    @autoreleasepool {
        if(checkZisseki != zissekiFlag){
            int flags = zissekiFlag & ~checkZisseki;
            // UTF8 エンコードされた CSV ファイル
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zisseki" ofType:@"txt"];
            NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            
            // 改行文字で区切って配列に格納する
            NSArray *lines = [text componentsSeparatedByString:@"\n"];

            NSString *string = [[NSString alloc] init];
            for(int i=zisseki_NUM;i>=0;--i) if((flags >> i & 1) == 1){
                string = [NSString stringWithFormat:@"実績「%@」を解放しました。\n%@",lines[i],string];
            }
            
            [self showAlert:@"実績解放" Message:string];
        }
    }
    
    checkZisseki = zissekiFlag;
    NSUserDefaults *savedata = [NSUserDefaults standardUserDefaults];
    [savedata setBool:Dead forKey:DeadKey];
    [savedata setValue:[NSNumber numberWithBool:OinoriFlag] forKey:OinoriKey];
    [savedata setValue:[NSNumber numberWithInteger:avater.ID] forKey:IDkey];
    [savedata setValue:[NSNumber numberWithInteger:avater.CivicVirtuePoint] forKey:PointKey];
    [savedata setValue:[NSNumber numberWithInteger:avater.Hunger] forKey:HungerKey];
    [savedata setObject:PrevDate forKey:DateKey];
    [savedata setObject:DeadTime forKey:DeadTimeKey];
    [savedata setObject:[self SPCgetConnectedList] forKey:SPCListKey];
    [savedata setValue:[NSNumber numberWithInteger:zissekiFlag] forKey:ZissekiKey];
    [savedata setValue:[NSNumber numberWithInteger:ReincarnationAvaterList] forKey:RALKey];
    [savedata setValue:[NSNumber numberWithInteger:SPCAvaterList] forKey:SPCALKey];
    [savedata setValue:[NSNumber numberWithInteger:ogurai] forKey:OguraiKey];
    [savedata setValue:[NSNumber numberWithInteger:ninkimono] forKey:NinkimonoKey];
    [savedata synchronize];
    
    
//    NSLog(@"%d,",[savedata boolForKey:OinoriKey]);
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
    NSLog(@"flag %d %d",Dead,OinoriFlag);
    
    if(Dead || !OinoriFlag){
        [KGStatusBar showWithStatus:@"現在お祈り出来ません"];
        messageCount = 0;
        return;
    }
    
    OinoriFlag = false;
    zissekiFlag |= 1 << 0;//お祈り実績フラグ
    [KGStatusBar dismiss];
    [MainTimer invalidate];//タイマー一時停止
    [self SPCstop];
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
    } else if ([segue.identifier isEqualToString:@"zissekiSegue"]) {
        ZissekiViewController *viewCon = segue.destinationViewController;
        viewCon.zissekiFlag = zissekiFlag;
    }

}

//お祈りモードから帰ってきた時
- (void)finishView:(int)returnValue{
    avater.CivicVirtuePoint = returnValue;
    if(avater.CivicVirtuePoint>Point_MAX) avater.CivicVirtuePoint = Point_MAX;
    CivicVirtuePointBar.progress = (double)avater.CivicVirtuePoint/Point_MAX;
    CivicVirtuePointText.text = [NSString stringWithFormat:@"%3d/999",(int)(CivicVirtuePointBar.progress*Point_MAX)];
    NSLog(@"returnValue %d" , returnValue);
    [self save];
    [self SPCstart];
    MainTimer = [NSTimer scheduledTimerWithTimeInterval:CallTimerSpan
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
    NSTimeInterval tmp= [Date timeIntervalSinceDate:PrevDate];
    OinoriFlag |= [self oinoriCheck:Date];
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
            zissekiFlag |= 1 << 1;//死亡実績フラグ
            zissekiFlag |= 1 << 3;//餓死実績フラグ
            
            [self SPCstop];
            
            //おめでとう！！！
            if(avater.ID == 22 || avater.ID == 23){
                [self showAlert:@"ここまで辿り着いたアナタへ" Message:@"おめでとう 行ってらっしゃい！！"];
            }
            
            //実績フラグ用の変数のリセット
            ogurai = 0;
            ninkimono = 0;
            
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
            [self ReincarnationCheck];
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
        if(messageCount==2){
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
        SPCAvaterList |= 1 << SPCAvaterID;//すれ違ったアバターIDの保存
        if(SPCAvaterID == (1 <<  24) - 1) zissekiFlag |= 1 << 24;//全アバターすれ違い実績フラグ
        
        if(avater.Hunger != Hunger_MAX && [avater Predation:SPCAvaterID]){// 捕食
            [KGStatusBar showWithStatus:@"捕食しました"];
            zissekiFlag |= 1 << 5;//捕食実績フラグ
            if(++ogurai >= 5) {
                zissekiFlag |= 1 << 27;//連続捕食実績フラグ
                ogurai = 0;
            }
            avater.Hunger += 200;
            if(avater.Hunger > Hunger_MAX) avater.Hunger = Hunger_MAX;
            HungerBar.progress = (double)avater.Hunger / Hunger_MAX;
            HungertText.text = [NSString stringWithFormat:@"%3d/999",(int)(HungerBar.progress*Hunger_MAX)];
        } else if(Eat && [avater UnPredation:SPCAvaterID]){// 被食
            [KGStatusBar showWithStatus:@"捕食されました"];
            [self SPCstop];
            Dead = true;
            zissekiFlag |= 1 << 1;//死亡実績フラグ
            zissekiFlag |= 1 << 6;//被食実績フラグ
            if(++ninkimono >= 5) {
                zissekiFlag |= 1 << 28;//連続被食実績フラグ
                ninkimono = 0;
            }
            
            //おめでとう！！！
            if(avater.ID == 22 || avater.ID == 23 ){
                [self showAlert:@"ここまで辿り着いたアナタへ" Message:@"おめでとう 行ってらっしゃい！！"];
            }
            
            //実績フラグ用の変数のリセット
            ogurai = 0;

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

// お祈りフラグの取得 0,3,6,12,15,18,24で更新
- (bool) oinoriCheck:(NSDate*) now
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowdateComps = [calendar components:NSYearCalendarUnit |
                                   NSMonthCalendarUnit  |
                                   NSDayCalendarUnit    |
                                   NSHourCalendarUnit   |
                                   NSMinuteCalendarUnit |
                                   NSSecondCalendarUnit
                                              fromDate:now];
    NSDateComponents *prevdateComps = [calendar components:NSYearCalendarUnit |
                                      NSMonthCalendarUnit  |
                                      NSDayCalendarUnit    |
                                      NSHourCalendarUnit   |
                                      NSMinuteCalendarUnit |
                                      NSSecondCalendarUnit
                                                 fromDate:PrevDate];


    
    if(nowdateComps.day - prevdateComps.day >= 3) zissekiFlag |= 1 << 26;//被食実績フラグ
    
//    NSLog(@"%d %d %d %d",nowdateComps.minute,nowdateComps.second,prevdateComps.minute,prevdateComps.second);
    // 年、月、日をまたいだ場合
    if(prevdateComps.year <  nowdateComps.year) return true;
    if(prevdateComps.month < nowdateComps.month) return true;
    if (prevdateComps.day < nowdateComps.day) return true;

    //一日内の処理
    for(int i=0;i<24;i+=3){
        if(prevdateComps.hour < i && i <= nowdateComps.hour ) return true;
    }
    
    //debug用
    //for(int i=0;i<60;i+=3)if(prevdateComps.minute < i && i <= nowdateComps.minute ) return true;
    for(int i=0;i<60;i+=10)if(prevdateComps.second < i && i <= nowdateComps.second ) return true;

    return false;
}

- (void) ReincarnationCheck
{
    zissekiFlag |= 1 << 2;//転生実績フラグ
    ReincarnationAvaterList |= 1 << avater.ID;//転生アバターリスト
    if(ReincarnationAvaterList == (1 <<  24) - 1) zissekiFlag |= 1 << 25;//全アバター転生実績フラグ

    if(avater.Category != 0) zissekiFlag |= 1 << 4;//微生物以外のアバター転生実績フラグ
    if(avater.Category == 1) zissekiFlag |= 1 << 10;//海洋生物アバター転生実績フラグ
    if(avater.Category == 2) zissekiFlag |= 1 << 7;//昆虫アバター転生実績フラグ
    if(avater.Category == 3) zissekiFlag |= 1 << 14;//爬虫類アバター転生実績フラグ
    if(avater.Category == 4) zissekiFlag |= 1 << 12;//鳥類アバター転生実績フラグ
    if(avater.Category == 5) zissekiFlag |= 1 << 16;//哺乳類アバター転生実績フラグ
    if(avater.Category == 6) zissekiFlag |= 1 << 18;//類人猿アバター転生実績フラグ
    if(avater.Category == 7) zissekiFlag |= 1 << 21;//人外アバター転生実績フラグ

    if(avater.ID == 9) zissekiFlag |= 1 << 9;//黒い悪魔G転生実績フラグ
    if(avater.ID == 21) zissekiFlag |= 1 << 20;//人アバター転生実績フラグ
    
    int _1 =  400, _2  = 608, _3 = 50176, _4 = 14336, _5 = 458752, _6 = 3670016, _7 = 12582912;
    
    if((_1 & ReincarnationAvaterList)== _1) zissekiFlag |= 1 << 11;//海洋生物全アバター転生実績フラグ
    if((_2 & ReincarnationAvaterList)== _2) zissekiFlag |= 1 << 8;//昆虫全アバター転生実績フラグ
    if((_3 & ReincarnationAvaterList)== _3) zissekiFlag |= 1 << 15;//爬虫類全アバター転生実績フラグ
    if((_4 & ReincarnationAvaterList)== _4) zissekiFlag |= 1 << 13;//鳥類全アバター転生実績フラグ
    if((_5 & ReincarnationAvaterList)== _5) zissekiFlag |= 1 << 17;//哺乳類全アバター転生実績フラグ
    if((_6 & ReincarnationAvaterList)== _6) zissekiFlag |= 1 << 19;//類人猿全アバター転生実績フラグ
    if((_7 & ReincarnationAvaterList)== _7) zissekiFlag |= 1 << 22;//人外全アバター転生実績フラグ
    
    if((zissekiFlag >> 21 & 1) == 1 && avater.ID == 0) zissekiFlag |= 1 << 23;//二周目アメーバ転生実績フラグ

    
}

//ダイアログの表示
- (void)showAlert:(NSString*)title Message:(NSString*)message
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:self
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


//for deligate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Alert clicked!!");
}




@end
