//
//  ZissekiViewController.m
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

#import "ZissekiViewController.h"

@implementation ZissekiViewController
{
    IBOutlet UIScrollView *scrollView;
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


        int point_x = 0;
        int point_y = 49;
        int width = 320 -point_x;
        int height = 1000 - point_y;
        CGRect backRect = CGRectMake(point_x, point_y,width, height);//スクロールビュー内の表示画面、位置とサイズ
        self.insideView = [[UIView alloc]initWithFrame:backRect];
        [scrollView addSubview:self.insideView];//スクロールビューにセット
        scrollView.contentSize = self.insideView.frame.size;//スクロールビューのサイズ
        scrollView.contentOffset = CGPointMake(point_x, point_y);//スクロールビューの位置
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//スクロールバーの色
        
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(point_x + 5, point_y + 5, width - 5, 20)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(point_x + 5, height - 100, width - 5, 20)];
        label1.text = @"top";
        label2.text = @"bottom";
        label1.backgroundColor = [UIColor blackColor];
        label2.backgroundColor = [UIColor blackColor];
        label1.textColor = [UIColor whiteColor];
        label2.textColor = [UIColor whiteColor];
        [self.insideView addSubview:label1];
        [self.insideView addSubview:label2];
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
