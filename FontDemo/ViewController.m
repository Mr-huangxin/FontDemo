//
//  ViewController.m
//  FontDemo
//
//  Created by 黄新 on 2018/7/5.
//  Copyright © 2018年 BJRCB. All rights reserved.
//

#import "ViewController.h"
#import "BJRCBURLProtocol.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[BJRCBURLProtocol class]];
    NSString *url = [[NSBundle mainBundle] pathForResource:@"test.html" ofType:nil];

    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    NSURL *filePath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
    [web loadRequest:request];
    [web setScalesPageToFit:YES];
    [self.view addSubview:web];
    return;
    NSLog(@"--------------------------");
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    label.text = @"当在较短时间显示大量图片时（比如 TableView 存在非常多的图片并且快速滑动时），CPU 占用率很低，GPU 占用非常高，界面仍然会掉帧。避免这种情况的方法只能是尽量减少在短时间内大量图片的显示，尽可能将多张图片合成为一张进行显示。123456789";
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"FZLTHK--GBK1-0" size:14];
    label.textColor = [UIColor blackColor];
    
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 200)];
    label1.text = @"当在较短时间显示大量图片时（比如 TableView 存在非常多的图片并且快速滑动时），CPU 占用率很低，GPU 占用非常高，界面仍然会掉帧。避免这种情况的方法只能是尽量减少在短时间内大量图片的显示，尽可能将多张图片合成为一张进行显示。123456789";
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor blackColor];
    
    [self.view addSubview:label1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
