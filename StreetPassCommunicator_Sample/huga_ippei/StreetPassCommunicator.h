//
//  StreetPassCommunicator.h
//  huga_ippei
//
//  Created by techcamp on 2013/08/23.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface StreetPassCommunicator : UIViewController <GKSessionDelegate>{
@private
    //session
    //セッション
    GKSession *SPCmySession;
    //セッションPEER ID
    NSString *SPCsessionPeerID;
    //送受信を開始するかどうかのフラグ
    bool SPCisStart;
    //一度接続したIDが次回接続可能になるまでの時間（接続禁止リストから解除されるまでの時間（分））
    int SPCrejectMinutes;
    
    //other fields
    //受信したメッセージのリスト。NSString
    NSMutableArray *SPCmessageList;
    //送信するメッセージ。NSString
    NSString *SPCmessage;
    //接続済みIDのマップ。次回接続禁止リスト。key:接続ID,value:接続終了の時の時間
    NSMutableDictionary *SPCconnectedList;
    
    //インスタンスが生成されてからメッセージを送信した回数
    int SPCsendCount;
    //インスタンスが生成されてからメッセージを受信した回数
    int SPCreceiveCount;
    
    //semaphore
    // 送信するメッセージのsetとgetを管理するセマフォ
    dispatch_semaphore_t SPCsemMyMessage;
    
    // 受信したメッセージリストのsetとgetを管理するセマフォ
    dispatch_semaphore_t SPCsemCommMessage;
    
    // 接続済みリストReceiveのsetとgetを管理するセマフォ
    dispatch_semaphore_t SPCsemConnected;

    // メッセージ送信回数sendCountのsetとgetを管理するセマフォ
    dispatch_semaphore_t SPCsemSendCount;
    
    // メッセージ受信回数receiveCountのsetとgetを管理するセマフォ
    dispatch_semaphore_t SPCsemReceiveCount;
    
    // 接続禁止時間のsetとgetを管理するセマフォ
    dispatch_semaphore_t SPCsemRejectTime;
    
    // 開始と停止のstartとstopを管理するセマフォ
    dispatch_semaphore_t SPCsemStart;
}

//コンストラクタ
+(StreetPassCommunicator*)SPCstartAndInitMessage:(NSString*)message;//送信するメッセージを設定
-(void)viewDidLoad;//継承として使うときの初期設定

//メソッド
-(void)SPCsetMyMessage:(NSString*)mes;//送信するメッセージの設定
-(NSString*)SPCgetMyMessage;//送信するメッセージに設定している文字列の取得
-(NSString*)SPCgetCommMessage;//受信したメッセージをリストmessageListから一つpopし返す
-(int)SPCgetCommListSize;//受信したメッセージのリストmessageListのサイズを返す

//メッセージの送受信
-(int)SPCgetSendCount;//メッセージを送信した回数を返す
-(int)SPCgetReceiveCount;//メッセージを受信した回数を返す
-(void)SPCresetSendCount;//メッセージを送信した回数をリセットする
-(void)SPCresetReceiveCount;//メッセージを受信した回数をリセットする

-(int)SPCgetConnectedListSize;//接続済みリストのサイズを返す
-(void)SPCresetConnectedList;//接続済みIDリストをリセットする
-(NSString*)SPCgetSessionPeerID;//セッションPeerIDを返す（セッションPeerIDはアプリ起動ごとに変わるID）

//開始と停止
-(void)SPCstart;//送受信の開始・再開
-(void)SPCstop;//送受信の停止・一時停止
-(void)SPCsetRejectTimeForMinutes:(int)minutes;//一度接続してから接続禁止解除までの時間を設定(分)
-(int)SPCgetRejectTimeForMinutes;//一度接続してから接続禁止解除までの時間を返す
@end