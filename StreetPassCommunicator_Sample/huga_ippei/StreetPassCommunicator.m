//
//  StreetPassCommunicator.m
//  joggress
//
//  Created by techcamp on 2013/08/23.
//  Copyright (c) 2013年 techcamp. All rights reserved.
//

#import "StreetPassCommunicator.h"

#define GKSessionIDName @"joggress_Fermentation"
#define defaultRejectTime 60

@implementation StreetPassCommunicator

//コンストラクタ
//送信するメッセージを設定
+(StreetPassCommunicator*)SPCstartAndInitMessage:(NSString*)message{
    StreetPassCommunicator* obj = [[self alloc] init];
    
    //semaphore
    obj->SPCsemMyMessage=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->SPCsemCommMessage=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->SPCsemConnected=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->SPCsemSendCount=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->SPCsemReceiveCount=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->SPCsemRejectTime=dispatch_semaphore_create(1);//セマフォ最大値1
    obj->SPCsemStart=dispatch_semaphore_create(1);//セマフォ最大値1
    
    //other fields settings
    obj->SPCmessageList=[NSMutableArray array];
    obj->SPCconnectedList=[NSMutableDictionary dictionary];
    [obj SPCsetSendCount:0];
    [obj SPCsetReceiveCount:0];
    [obj SPCsetMyMessage:message];
    [obj SPCsetRejectTimeForMinutes:defaultRejectTime];
    [obj SPCstop];
    
    //session settings
    obj->SPCmySession= [[GKSession alloc] initWithSessionID:GKSessionIDName displayName:nil sessionMode:GKSessionModePeer];
    obj->SPCmySession.delegate = obj;
	[obj->SPCmySession setDataReceiveHandler:obj withContext:nil];
	obj->SPCmySession.available = NO;
    obj->SPCsessionPeerID=obj->SPCmySession.peerID;
    
    //return
    return obj;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    @autoreleasepool {
        //semaphore
        SPCsemMyMessage=dispatch_semaphore_create(1);//セマフォ最大値1
        SPCsemCommMessage=dispatch_semaphore_create(1);//セマフォ最大値1
        SPCsemConnected=dispatch_semaphore_create(1);//セマフォ最大値1
        SPCsemSendCount=dispatch_semaphore_create(1);//セマフォ最大値1
        SPCsemReceiveCount=dispatch_semaphore_create(1);//セマフォ最大値1
        SPCsemRejectTime=dispatch_semaphore_create(1);//セマフォ最大値1
        SPCsemStart=dispatch_semaphore_create(1);//セマフォ最大値1
        
        //other fields settings
        SPCmessageList=[NSMutableArray array];
        //    [SPCmessageList retain];
        SPCconnectedList=[NSMutableDictionary dictionary];
        //    [SPCconnectedList retain];
        [self SPCsetSendCount:0];
        [self SPCsetReceiveCount:0];
        [self SPCsetMyMessage:SPCmessage];
        [self SPCsetRejectTimeForMinutes:defaultRejectTime];
        [self SPCstop];
        
        //session settings
        SPCmySession= [[GKSession alloc] initWithSessionID:GKSessionIDName displayName:nil sessionMode:GKSessionModePeer];
        SPCmySession.delegate = self;
        [SPCmySession setDataReceiveHandler:self withContext:nil];
        SPCmySession.available = NO;
        SPCsessionPeerID=SPCmySession.peerID;
    }
}


//getter and setter and resetter

//送信するメッセージの設定
-(void)SPCsetMyMessage:(NSString*)mes{
    dispatch_semaphore_wait(SPCsemMyMessage, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    NSString *uiid=[[UIApplication sharedApplication] uniqueInstallationIdentifier];
    NSString *mesStr=[[NSString alloc] initWithFormat:@"%@<>%@",mes,uiid];
    self->SPCmessage=mesStr;//値のコピー
    dispatch_semaphore_signal(SPCsemMyMessage);// セマフォの開放
}

//送信するメッセージに設定している文字列の取得
-(NSString*)SPCgetMyMessage{
    NSString *str;
    dispatch_semaphore_wait(SPCsemMyMessage, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    
    // クリティカルセクション
    NSArray *sep=[self->SPCmessage componentsSeparatedByString:@"<>"];
    str=[sep objectAtIndex:0];//値のコピー
    
    dispatch_semaphore_signal(SPCsemMyMessage);// セマフォの開放
    return str;
}

//受信したメッセージをリストmessageListから一つpopし返す
-(NSString*)SPCgetCommMessage{
    return [self SPCpopCommMessage];
}

//受信したメッセージのリストmessageListのサイズを返す
-(int)SPCgetCommListSize{
    int size=-1;//errorのときは-1が返る
    dispatch_semaphore_wait(SPCsemCommMessage, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    if(SPCmessageList!=nil){
        size=SPCmessageList.count;
    }
    dispatch_semaphore_signal(SPCsemCommMessage);// セマフォの開放
    return size;
}

//メッセージを送信した回数を返す
-(int)SPCgetSendCount{
    int count;
    dispatch_semaphore_wait(SPCsemSendCount, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    count=SPCsendCount;
    dispatch_semaphore_signal(SPCsemSendCount);// セマフォの開放
    return count;
}

//メッセージを受信した回数を返す
-(int)SPCgetReceiveCount{
    int count;
    dispatch_semaphore_wait(SPCsemReceiveCount, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    count=SPCreceiveCount;
    dispatch_semaphore_signal(SPCsemReceiveCount);// セマフォの開放
    return count;
}

//メッセージを送信した回数をリセットする
-(void)SPCresetSendCount{
    [self SPCsetSendCount:0];
}

//メッセージを受信した回数をリセットする
-(void)SPCresetReceiveCount{
    [self SPCsetReceiveCount:0];
}

//接続済みリストのサイズを返す(受信側)
-(int)SPCgetConnectedListSize{
    int size=-1;//messageListがnilのときエラー:-1
    dispatch_semaphore_wait(SPCsemConnected, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    if(SPCconnectedList!=nil){
        size=SPCconnectedList.count;
    }
    dispatch_semaphore_signal(SPCsemConnected);// セマフォの開放
    return size;
}

//接続済みIDリストをリセットする
-(void)SPCresetConnectedList{
    dispatch_semaphore_wait(SPCsemConnected, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    [SPCconnectedList removeAllObjects];
    dispatch_semaphore_signal(SPCsemConnected);// セマフォの開放
}

//start
-(void)SPCstart{
    dispatch_semaphore_wait(SPCsemStart, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    SPCisStart=true;
    SPCmySession.available = YES;
    dispatch_semaphore_signal(SPCsemStart);// セマフォの開放
    NSLog(@"誰かを探し始めた！自分のIDは %@",SPCsessionPeerID);
}

//stop
-(void)SPCstop{
    dispatch_semaphore_wait(SPCsemStart, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    SPCisStart=false;
    SPCmySession.available = NO;
    dispatch_semaphore_signal(SPCsemStart);// セマフォの開放
}


//reject time setting

//一度接続してから接続禁止解除までの時間を設定(分)
-(void)SPCsetRejectTimeForMinutes:(int)minutes{
    dispatch_semaphore_wait(SPCsemRejectTime, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    SPCrejectMinutes=minutes;
    dispatch_semaphore_signal(SPCsemRejectTime);// セマフォの開放
}

//一度接続してから接続禁止解除までの時間を返す
-(int)SPCgetRejectTimeForMinutes{
    int time;
    dispatch_semaphore_wait(SPCsemRejectTime, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    time=SPCrejectMinutes;
    dispatch_semaphore_signal(SPCsemRejectTime);// セマフォの開放
    return time;
}

//セッションIDを返す
-(NSString*)SPCgetSessionPeerID{
    return SPCsessionPeerID;
}







/*********************************************************************
 for private methods
 **********************************************************************/


//pop commMessage
-(NSString*)SPCpopCommMessage{
    NSString *str=nil;
    dispatch_semaphore_wait(SPCsemCommMessage, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    // クリティカルセクション
    if(SPCmessageList!=nil){
        //値のコピー
        if(SPCmessageList.count!=0){
            //get
            str=[SPCmessageList objectAtIndex:0];
            //remove
            [SPCmessageList removeObjectAtIndex:0];
        }
    }
    dispatch_semaphore_signal(SPCsemCommMessage);// セマフォの開放
    return str;
}

//add commMessage
-(void)SPCaddCommMessage:(NSString*)str{
    dispatch_semaphore_wait(SPCsemCommMessage, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    if(SPCmessageList!=nil){
        //追加
        [SPCmessageList addObject:str];
    }
    dispatch_semaphore_signal(SPCsemCommMessage);// セマフォの開放
    NSLog(@"リストにメッセージ「%@」を追加した",str);
}

//add connectedList
-(void)SPCaddConnectedList:(NSString*)sessionID{
    dispatch_semaphore_wait(SPCsemConnected, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    if(SPCconnectedList!=nil){
        [SPCconnectedList setObject:[NSDate date] forKey:sessionID];
    }
    dispatch_semaphore_signal(SPCsemConnected);// セマフォの開放
    NSLog(@"接続済みリストにID:%@を追加した！",sessionID);
}

//get connectedList
-(NSDate*)SPCgetConnectedList:(NSString*)peer{
    NSDate *date=nil;//errorの時はnilが返る
    dispatch_semaphore_wait(SPCsemConnected, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    NSLog(@"%@",peer);
    if(SPCconnectedList!=nil&&peer!=nil){
        date=(NSDate*)[SPCconnectedList objectForKeyedSubscript:peer];
    }
    dispatch_semaphore_signal(SPCsemConnected);// セマフォの開放
    return date;
}

//remove connectedList
-(void)SPCremoveConnectedList:(NSString*)sessionID{
    dispatch_semaphore_wait(SPCsemConnected, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    if(SPCconnectedList!=nil){
        [SPCconnectedList removeObjectForKey:sessionID];
    }
    dispatch_semaphore_signal(SPCsemConnected);// セマフォの開放
}

//setter for sendCount
-(void)SPCsetSendCount:(int)count{
    dispatch_semaphore_wait(SPCsemSendCount, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    SPCsendCount=count;
    dispatch_semaphore_signal(SPCsemSendCount);// セマフォの開放
    NSLog(@"送信カウント:%2d",count);
}

//setter for receiveCount
-(void)SPCsetReceiveCount:(int)count{
    dispatch_semaphore_wait(SPCsemReceiveCount, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    SPCreceiveCount=count;
    dispatch_semaphore_signal(SPCsemReceiveCount);// セマフォの開放
    NSLog(@"受信カウント:%2d",count);
    
}

//get isStart status
-(bool)SPCgetIsStart{
    bool status;
    dispatch_semaphore_wait(SPCsemStart, DISPATCH_TIME_FOREVER);// セマフォを使用宣言
    //クリティカルセクション
    status=SPCisStart;
    dispatch_semaphore_signal(SPCsemStart);// セマフォの開放
    return status;
}



//send & receive Methods for deligates

-(void)SPCsendMessage:(NSString *)peerID{
    if([self SPCgetIsStart]){//check isStart
        
        //send
        NSString *str=[self SPCgetMyMessage];
        [SPCmySession sendData:[str dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataReliable error:nil];
        
        NSLog(@"%@ にメッセージを送った！「%@」",peerID,str);
        [self SPCsetSendCount:[self SPCgetSendCount]+1];
    }
}

-(void)SPCreceiveMessage:(NSData *)data fromPeer:(NSString *)peer{
    if([self SPCgetIsStart]){//check isStart
        
        //receive
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@ からメッセージを受け取った！ 「%@」",peer,str);
        
        NSArray *strArray=[str componentsSeparatedByString:@"<>"];
        if(strArray.count!=2){
            NSLog(@"メッセージのフォーマットが違います。");
            return;
        }
        NSString *mesStr=[strArray objectAtIndex:0];
        NSString *uiid=[strArray objectAtIndex:1];
        
        
        //check connect allowable
        NSDate *date=[self SPCgetConnectedList:uiid];
        NSDate *now=[NSDate date];
        
        if(date!=nil){
            NSTimeInterval elapseTime = [now timeIntervalSinceDate:date];
            NSInteger elapseMinutes = elapseTime/60;
            if(elapseMinutes<[self SPCgetRejectTimeForMinutes]){
                NSLog(@"しかしすでに接続済みだ。");
                return;
            }
        }
        
        //receive
        //NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@ からメッセージを受け取った！ 「%@」",peer,str);
        [self SPCsetReceiveCount:[self SPCgetReceiveCount]+1];
        [self SPCaddCommMessage:mesStr];
        [self SPCaddConnectedList:uiid];//renew connectedList
    }
}

#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    NSLog(@"%@ とうまく接続できない。 (%@)",peerID,[error localizedDescription]);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    NSLog(@"ネットワークがおかしい？ (%@)",[error localizedDescription]);
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    NSLog(@"%@ から接続したいと言われた！",peerID);
	NSError *error;
	if(![SPCmySession acceptConnectionFromPeer:peerID error:&error]) {
        NSLog(@"%@ と接続できなかった… (%@)",peerID,[error localizedDescription]);
	} else {
        NSLog(@"%@ と接続できた！",peerID);
	}
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	switch (state) {
		case GKPeerStateAvailable:
			NSLog(@"%@ を見つけた！",peerID);
            NSLog(@"%@ に接続しに行く！",peerID);
			[SPCmySession connectToPeer:peerID withTimeout:10.0f];
			break;
		case GKPeerStateUnavailable:
            NSLog(@"%@ を見失った！",peerID);
			break;
		case GKPeerStateConnected:
			NSLog(@"%@ が接続した！",peerID);
            [self SPCsendMessage:peerID];
			break;
		case GKPeerStateDisconnected:
            NSLog(@"%@ が切断された！",peerID);
			break;
		case GKPeerStateConnecting:
            NSLog(@"%@ が接続中！",peerID);
			break;
		default:
			break;
	}
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    [self SPCreceiveMessage:data fromPeer:peer];
}

@end
