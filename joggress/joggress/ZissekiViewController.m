//
//  ZissekiViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "ZissekiViewController.h"
#import "ViewController.h"


@implementation ZissekiViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *Close;

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    @autoreleasepool {
        // フォント設定
        [Close.titleLabel setFont:[UIFont fontWithName:@"MisakiGothic" size:20.0]];
        
        int point_x = 0;
        int point_y = 5;
        int width = 320;
        int height = zisseki_NUM * 20 + 170;
        CGRect backRect = CGRectMake(point_x, point_y,width, height);//スクロールビュー内の表示画面、位置とサイズ
        self.insideView = [[UIView alloc]initWithFrame:backRect];
        [scrollView addSubview:self.insideView];//スクロールビューにセット
        scrollView.contentSize = self.insideView.frame.size;//スクロールビューのサイズ
        scrollView.contentOffset = CGPointMake(point_x, point_y);//スクロールビューの位置
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//スクロールバーの色
        
        // UTF8 エンコードされた CSV ファイル
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zisseki" ofType:@"txt"];
        NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

        // 改行文字で区切って配列に格納する
        NSArray *lines = [text componentsSeparatedByString:@"\n"];
        
        for (int i=0;i< zisseki_NUM; ++i) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point_x, point_y + (i * 25), width - 5, 20)];
            label.text = lines[i];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = _zissekiFlag&(1<<i)?[UIColor whiteColor]:[UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:@"MisakiGothic" size:17.0];
            [self.insideView addSubview:label];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)respondToButtonClick:(id)sender
{
    // 画面を閉じる処理
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
