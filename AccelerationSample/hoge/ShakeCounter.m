//
//  ShakeCounter.m
//  joggress
//
//  Created by techcamp on 2013/08/22.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import "ShakeCounter.h"
#import "ViewController.h"

@implementation ShakeCounter

const double userAccThreshold=0.1;

//timing秒ごとにカウント判定
+(ShakeCounter*)everySeconds:(double)timing{
    ShakeCounter* obj = [[self alloc] init];
    obj->timing=timing;
    obj->prevAcc=0;
    obj->isEnd=true;
    obj->semCount=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->semEnd=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->semAcc=dispatch_semaphore_create(1);//セマフォ最大値1
    
    return obj;
}

//seconds秒間カウント
-(void)startForSeconds:(int)seconds{
    
    //カウント判定を行う数
    countJudgNum_MAX=(int)seconds/timing;
    [self setCount:0];
    countJudgNum=0;
    [self setIsEnd:false];
    
//sensor setting    // CMMotionManagerを作成
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = timing;//センサーの値を読み込む頻度
    
    // モーションデータ更新時のハンドラを作成
    void (^handler)(CMDeviceMotion *, NSError *) = ^(CMDeviceMotion *motion, NSError *error){
        CMAcceleration user = motion.userAcceleration;
        //NSLog(@"sensor alived!!");
        // ユーザー加速度の大きさを算出
        double magnitude = sqrt(pow(user.x, 2) + pow(user.y, 2) + pow(user.z, 2));
        //NSLog(@"x:%.3f,y:%.3f,z:%.3f,mag:%.3f",user.x,user.y,user.z,magnitude);
        
        //カウント判定
        if(![self getIsEnd]){
            if(countJudgNum<=countJudgNum_MAX){
                if(prevAcc-magnitude>0&&magnitude>userAccThreshold){
                    //カウント増加
                    [self setCount:[self getCount]+1];
                    //NSLog(@"count added!!:%2d",[self getCount]);
                }
                countJudgNum++;
                prevAcc=magnitude;
            }else{
                [self setIsEnd:true];
            }
        }
        
        [self setNowAcc:magnitude];//現在の加速度にセット
        NSLog(@"加速度:%3f",magnitude);
    };
    
    // モーションデータの測定を開始
    queue = [[[NSOperationQueue alloc] init] autorelease];//スレッドとして実行
    [motionManager startDeviceMotionUpdatesToQueue:queue withHandler:handler];

}

-(double)getAccSize{
    return [self getNowAcc];
}

-(bool)isEnded{
    return [self getIsEnd];
}

-(void)stop{
    [motionManager release];
    motionManager = nil;
    [queue release];
    queue=nil;
}


//setter & getter

-(int)getCount{
    int c;
    dispatch_semaphore_wait(semCount, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    c=count;//値のコピー
    dispatch_semaphore_signal(semCount);// セマフォの開放
    return c;
}

-(void)setCount:(int)c{
    dispatch_semaphore_wait(semCount, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    count=c;//値のコピー
    dispatch_semaphore_signal(semCount);// セマフォの開放
}

-(double)getNowAcc{
    double c;
    dispatch_semaphore_wait(semAcc, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    c=nowAcc;//値のコピー
    dispatch_semaphore_signal(semAcc);// セマフォの開放
    return c;
}

-(void)setNowAcc:(double)acc{
    dispatch_semaphore_wait(semAcc, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    nowAcc=acc;//値のコピー
    dispatch_semaphore_signal(semAcc);// セマフォの開放
}

-(bool)getIsEnd{
    bool end;
    dispatch_semaphore_wait(semEnd, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    end=isEnd;//値のコピー
    dispatch_semaphore_signal(semEnd);// セマフォの開放
    return end;
}

-(void)setIsEnd:(bool)end{
    dispatch_semaphore_wait(semEnd, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    isEnd=end;//値のコピー
    dispatch_semaphore_signal(semEnd);// セマフォの開放
}

@end
