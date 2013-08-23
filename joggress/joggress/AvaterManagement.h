//
//  AvaterManagement.h
//  joggress
//
//  Created by 0673nC on 2013/08/23.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Avater.h"

@interface AvaterManagement : NSObject
-(int)AvaterCount;
-(Avater*)Avater:(int)index;
@end
