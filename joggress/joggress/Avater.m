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
    NSMutableArray *EvolutionList;//進化先リスト
    NSMutableArray *PredationList;//捕食対象リスト
    NSMutableArray *UnPredationList;//被食対象リスト
    int CivicVirtuePointIncrement;//公徳ポイント増加値
    int HungerDecrement;//空腹ゲージ減少量
}

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
	return self;
}

@end
