//
//  ViewController.m
//  UnorderedKeyBoardDemo
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "KeyBoardView.h"

#define kScreenHight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<KeyBoardViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getUI];

}

- (void)getUI{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth / 2.0 - 60, 200, 120, 40);
    [button setTitle:@"点击弹出键盘" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)buttonAction: (UIButton *)button{
    
    KeyBoardView *keyboard = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, kScreenHight-kScreenWidth/3/2*5, kScreenWidth, kScreenWidth/3/2*5)];
    keyboard.delegate = self;
    [keyboard showInViewController:self];
    
}

#pragma mark - KeyBoardViewDelegate
- (void)passValueWithText:(NSString *)text{
    NSLog(@"输入数字为: %@", text);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
