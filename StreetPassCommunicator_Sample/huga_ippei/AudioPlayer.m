//
//  AudioUtil.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

#define DUMMY_AUDIO_NAME  @"01min"
#define DUMMY_AUDIO_FORMAT @"mp3"

@implementation AudioPlayer {
    
}

/**
 * バックグラウンドで無音の曲を再生し続ける。
 * バックグラウンドで音楽が再生されていればBluetoothもバックグラウンド通信できる。
 * Core Bluetooth　フレームワークを使えばバックグラウンド通信できそうだが、実装に時間がかかりそうなので今回はこの手法を採用。
 * 参考URL: http://addsict.hatenablog.com/entry/2013/01/05/002049
 */
+ (void) playDummyAudioBackground {
    // バックグラウンド再生を許可
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError* error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [session setActive:YES error:&error];
    
    // ファイルのパスを作成
    NSString *path = [[NSBundle mainBundle] pathForResource:DUMMY_AUDIO_NAME ofType:DUMMY_AUDIO_FORMAT];
    // ファイルのパスを NSURL へ変換します。
    NSURL* url = [NSURL fileURLWithPath:path];
    // ファイルを読み込んで、プレイヤーを作成
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    // 無限ループ設定
    player.numberOfLoops = -1;
    // 再生
    [player play];
}

/**
 音楽を鳴らす
 @param path ファイルパス
 @param type ファイルタイプ
 @param vol ボリューム
 **/
+ (void)playAudio:(NSString*)path Type:(NSString*)type Volume:(double)vol{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:type];
    NSURL *fileUrl  = [NSURL fileURLWithPath:filePath];
    NSError* error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    if(!error) {
        [audioPlayer prepareToPlay];
        audioPlayer.volume = vol;
        audioPlayer.currentTime = 0;
        [audioPlayer play];
    } else {
        NSLog(@"AVAudioPlayer Error");
    }    
}

//ダイアログの表示
+ (void)showAlert:(NSString*)title Message:(NSString*)message{

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:self
                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


//for deligate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Alert clicked!!");
}


@end
