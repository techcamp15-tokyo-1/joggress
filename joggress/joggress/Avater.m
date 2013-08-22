//
//  Avater.m
//  joggress
//
//  Created by 0673nC on 2013/08/22.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "Avater.h"

@implementation Avater
{
    int ID;//アバターID
    NSString *AvaterName;//アバター名
    NSString *ImageName;//アバター画像名(ファイルパス)
    NSMutableArray *EvolutionList;//進化先リスト:3分岐で固定
    NSMutableArray *PredationList;//捕食対象リスト
    NSMutableArray *UnPredationList;//被食対象リスト
    int CivicVirtuePoint;//公徳ポイント0~999999
    int CivicVirtuePointIncrement;//公徳ポイント増加値
    int Hunger;//空腹ゲージ0〜100？
    int HungerDecrement;//空腹ゲージ減少量
}

@synthesize ID = _Id;
@synthesize AvaterName = _A;
@synthesize ImageName = _Im;
@synthesize EvolutionList = _E;
@synthesize PredationList = _P;
@synthesize UnPredationList = _U;
@synthesize CivicVirtuePoint = _C;
@synthesize CivicVirtuePointIncrement = _CI;
@synthesize Hunger = _H;
@synthesize HungerDecrement = _HD;

- (id)init {
	return [self initWithAvater:0 string1:@"" string2:@"" list1:[[NSMutableArray alloc]init]
                          list2:[[NSMutableArray alloc]init] list3:[[NSMutableArray alloc]init] int1:0 int2:0];
}

- (id)initWithAvater:(int)_ID string1:(NSString*)AName string2:(NSString*)INanme list1:(NSMutableArray*) EL
list2:(NSMutableArray*) PL list3:(NSMutableArray*) UPL int1:(int) CVPI int2:(int) HD{
    self->ID = _ID;
    self->AvaterName = AName;
    self->ImageName = INanme;
    self->EvolutionList = EL;
    self->PredationList = PL;
    self->UnPredationList = UPL;
    self->CivicVirtuePointIncrement = CVPI;
    self->HungerDecrement = HD;
    self->CivicVirtuePoint=0;
    self->Hunger=100;
	return self;
}



//空腹ゲージの減少イベント return+ 転生, return- そのまま
-(int)HungryEvent
{
    Hunger-=HungerDecrement;
    if(Hunger<=0) return [self Reincarnation:FALSE];
    return -Hunger;
}


//転生イベント
-(int)Reincarnation:(bool) flag
{
    int nextID=-1;
    if(flag){//すれ違い時の処理
        nextID = [[EvolutionList objectAtIndex:CivicVirtuePoint>999999/2?2:1] intValue];
    }else{//被食時の処理
        nextID = [[EvolutionList objectAtIndex:CivicVirtuePoint>999999/2?1:0] intValue];
    }
    return nextID;
}





@end
