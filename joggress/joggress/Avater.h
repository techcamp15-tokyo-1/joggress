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
//@property (copy) NSString *AvaterName;//アバター名
@property (nonatomic) NSString *AvaterName;
@property (nonatomic) NSString *ImageName;//アバター画像名(ファイルパス)
@property (nonatomic) NSMutableArray *EvolutionList;//進化先リスト:3分岐で固定
@property (nonatomic) NSMutableArray *PredationList;//捕食対象リスト
@property (nonatomic) NSMutableArray *UnPredationList;//被食対象リスト
@property int CivicVirtuePoint;//公徳ポイント0~999
@property int CivicVirtuePointIncrement;//公徳ポイント増加値
@property int Hunger;//空腹ゲージ0〜999？
@property int HungerDecrement;//空腹ゲージ減少量
@property int Category;

- (id)initWithAvater:(int)_ID string1:(NSString*)AName string2:(NSString*)INanme list1:(NSMutableArray*) EL
list2:(NSMutableArray*) PL list3:(NSMutableArray*) UPL int1:(int) CVPI int2:(int) HD int3:(int)Category;
- (NSString *)toString;

-(int)Reincarnation:(bool) flag;
-(bool) Predation:(int)SPCID;
-(bool) UnPredation:(int)SPCID;
@end
