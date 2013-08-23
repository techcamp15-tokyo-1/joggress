//
//  ShakeCounter.h
//  joggress
//
//  Created by techcamp on 2013/08/22.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface ShakeCounter : NSObject{
@private
    // 振った回数countのsetとgetを管理するセマフォ
    dispatch_semaphore_t semCount;
    // 計測終了フラグisEndを管理するセマフォ
    dispatch_semaphore_t semEnd;
    // 加速度の大きさnowAccを管理するセマフォ
    dispatch_semaphore_t semAcc;
    
    //センシング用のオペレーションキュー
    NSOperationQueue *queue;
    
    int count;//振った回数
    double prevAcc;//前回観測時の加速度の大きさ
    double nowAcc;//今観測した加速度の大きさ
    double timing;//timing秒ごとカウント判定する
    bool isEnd;//カウント計測が終わったかどうか
    int countJudgNum;//カウント判定を行う回数
    int countJudgNum_MAX;//カウント判定回数
    CMMotionManager *motionManager;//加速度センサマネージャ
}
//コンビニエンスコンストラクタ
+(ShakeCounter*)everySeconds:(double)timing;//センサの巡回
-(void)startForSeconds:(int)seconds;//センシング開始・カウント開始
-(bool)isEnded;
-(double)getAccSize;//今観測した加速度の大きさを返す
-(int)getCount;
-(void)stop;//センシング停止・スレッド開放

@end
