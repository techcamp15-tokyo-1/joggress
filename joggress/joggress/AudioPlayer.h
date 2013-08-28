//
//  AudioUtil.h
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayer : NSObject {
}

+ (void) playDummyAudioBackground;
+ (void) playAudio:(NSString*)path Type:(NSString*)type Volume:(double)vol;//音楽の再生

@end

