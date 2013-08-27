//
//  ZissekiViewController.h
//  joggress
//
//  Created by 0673nC on 2013/08/21.
//  Copyright (c) 2013年 0673nC. All rights reserved.
//

// 実績一覧

#import <UIKit/UIKit.h>

@interface ZissekiViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *insideView;

- (IBAction)respondToButtonClick:(id)sender;

@end
