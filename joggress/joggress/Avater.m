//
//  Avater.m
//  joggress
//
//  Created by 0673nC on 2013/08/22.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "Avater.h"
#import "ViewController.h"
#include <stdlib.h>

@implementation Avater

- (id)init
{
	return [self initWithAvater:0 string1:@"" string2:@"" list1:[[NSMutableArray alloc]init]
                          list2:[[NSMutableArray alloc]init] list3:[[NSMutableArray alloc]init] int1:0 int2:0 int3:0];
}

- (id)initWithAvater:(int)ID string1:(NSString*)AName string2:(NSString*)INanme list1:(NSMutableArray*) EL
list2:(NSMutableArray*) PL list3:(NSMutableArray*) UPL int1:(int) CVPI int2:(int) HD int3:(int) Category
{
    _ID = ID;
    _AvaterName = AName;
    _ImageName = INanme;
    _EvolutionList = EL;
    _PredationList = PL;
    _UnPredationList = UPL;
    _CivicVirtuePointIncrement = CVPI;
    _HungerDecrement = HD;
    _Category = Category;
    _CivicVirtuePoint=0;
    _Hunger=Hunger_MAX;
	return self;
}

- (NSString*) toString
{
    return [NSString stringWithFormat:@"%d:%@ %@ %d %d", _ID, self.AvaterName, _ImageName,_CivicVirtuePointIncrement
            ,_HungerDecrement];
}


////空腹ゲージの減少イベント return+ 転生, return- そのまま
//-(int)HungryEvent
//{
//    _Hunger-=_HungerDecrement;
//    if(_Hunger<=0) return [self Reincarnation:FALSE];
//    return -_Hunger;
//}


//転生イベント
- (int)Reincarnation:(bool) flag
{
    int nextID=-1;
    srand(time(nil));
    int i = (int)rand() % (int)Point_MAX;
    NSLog(@"overpoint %d",i);
    if(flag){//すれ違い時の処理
        nextID = [[_EvolutionList objectAtIndex:_CivicVirtuePoint>i?2:1] intValue];
    }else{//餓死時の処理
        nextID = [[_EvolutionList objectAtIndex:_CivicVirtuePoint>i?1:0] intValue];
    }
    return nextID;
}

- (bool) Predation:(int) SPCID
{
    for(NSString *ID in _PredationList){
        if(SPCID == [ID intValue]) return true;
    }
    return  false;
}

- (bool) UnPredation:(int) SPCID
{
    for(NSString *ID in _UnPredationList){
        if(SPCID == [ID intValue]) return true;
    }
    return  false;
}


@end
