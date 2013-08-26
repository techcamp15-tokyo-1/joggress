//
//  AvaterManagement.m
//  joggress
//
//  Created by 0673nC on 2013/08/23.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "AvaterManagement.h"
#import "ViewController.h"

@implementation AvaterManagement
{
    NSMutableArray *AvaterList;
}

-(id)init
{
    AvaterList = [[NSMutableArray alloc]init];
    @autoreleasepool {       
        // UTF8 エンコードされた CSV ファイル
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"avaterdata" ofType:@"csv"];
        NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        // 改行文字で区切って配列に格納する
        NSArray *lines = [text componentsSeparatedByString:@"\n"];
        /*
         形式
         アバターID、アバター名、アバター画像名、進化先数i、進化先1~i、捕食対象数j、捕食対象1~j、被食対象数k、被食対象1~k、お祈りポイント増加量、空腹ゲージ減少量
         */
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            NSArray *items = [row componentsSeparatedByString:@","];
            //データ読み込み用仮オブジェクト
            NSMutableArray *EL = [[NSMutableArray alloc]init];
            NSMutableArray *PL = [[NSMutableArray alloc]init];
            NSMutableArray *UPL = [[NSMutableArray alloc]init];
            int itr = 0;
            int ID = [items[itr++] intValue];
            NSString *name = items[itr++];
            NSString *imagename = items[itr++];
            int i = [items[itr++] intValue];
            while(i-- > 0) [EL addObject:[NSNumber numberWithInteger:[items[itr++] intValue]]];
            int j = [items[itr++] intValue];
            while(j-- > 0) [PL addObject:[NSNumber numberWithInteger:[items[itr++] intValue]]];
            int k = [items[itr++] intValue];
            while(k-- > 0) [UPL addObject:[NSNumber numberWithInteger:[items[itr++] intValue]]];
            int inc = [items[itr++] intValue];
            int dec = [items[itr++] intValue];
            Avater *avater = [[Avater alloc ]initWithAvater:ID string1:name string2:imagename list1:EL list2:PL list3:UPL int1:inc int2:dec];
            //NSLog(@"%@",[avater toString]);
            [AvaterList addObject:avater];
        }
    }    
    //NSLog(@"%d",AvaterList.count);
    return self;
}

-(int)AvaterCount
{
    return AvaterList.count;
}

-(Avater*) Avater:(int)index
{
    Avater *avater = AvaterList[index];
    avater.Hunger = Hunger_MAX;
    avater.CivicVirtuePoint = 0;
    return avater;
}
@end
