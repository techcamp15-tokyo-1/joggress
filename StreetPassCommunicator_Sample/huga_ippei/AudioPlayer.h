//
//  AudioUtil.h
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AudioPlayer : NSObject<UIAlertViewDelegate> {
}

+ (void) playDummyAudioBackground;//ダミーオーディオの再生。バックグラウンド動作用
+ (void) playAudio:(NSString*)path Type:(NSString*)type Volume:(double)vol;//音楽の再生
+ (void) showAlert:(NSString*)title Message:(NSString*)message;//ダイアログの表示

@end

