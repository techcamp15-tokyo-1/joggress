//
//  Avater.h
//  joggress
//
//  Created by 0673nC on 2013/08/22.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Avater : NSObject

@property int ID;//アバターID
@property NSString *AvaterName;//アバター名
@property NSString *ImageName;//アバター画像名(ファイルパス)
@property NSMutableArray *EvolutionList;//進化先リスト:3分岐で固定
@property NSMutableArray *PredationList;//捕食対象リスト
@property NSMutableArray *UnPredationList;//被食対象リスト
@property int CivicVirtuePoint;//公徳ポイント0~999999
@property int CivicVirtuePointIncrement;//公徳ポイント増加値
@property int Hunger;//空腹ゲージ0〜100？
@property int HungerDecrement;//空腹ゲージ減少量

@end
