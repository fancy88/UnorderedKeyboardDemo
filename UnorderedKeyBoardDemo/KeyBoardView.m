//
//  KeyBoardView.m
//  MyKeyboardDemo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 apple. All rights reserved.
//  随机数字键盘

#import "KeyBoardView.h"
#import "AppDelegate.h"

#define kScreenHight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kWidth  self.frame.size.width
#define kHeight self.frame.size.height

@interface KeyBoardView () <UITextFieldDelegate>

@property (nonatomic, strong)NSArray *numberArray;
@property (nonatomic, strong)NSMutableArray *numberButtonArray;
@property (nonatomic, weak)  UITextField    *keyboardTextField;
@property (nonatomic, weak)  UIButton       *deleteButton;

@end

@implementation KeyBoardView
{
    UIView *modelView;
}

/**
 *  @brief 装载键盘的数字按钮
 *
 */
- (NSMutableArray *)nuberButtonArray{
    if (self.numberButtonArray == nil) {
        self.numberButtonArray = [NSMutableArray array];
    }
    return self.numberButtonArray;
}

/**
 *  @brief 初始化
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
        [self setUpMyKeyBoard];
    }
    return self;
}
/**
 *  @brief 显示键盘
 *
 */
- (void)showInViewController:(UIViewController *)controller{
    //遮盖
    modelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHight)];
    modelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [modelView addGestureRecognizer:tap];
    [modelView addSubview:self];
    
    //加入到主窗口
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:modelView];
    modelView.center = window.center;
    [self setNeedsDisplay];
}

/**
  在view上显示键盘
 */
- (void)showInView:(UIView *)view
{
    modelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHight - 70)];
    modelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    [modelView addSubview:self];
    [view addSubview:modelView];
    [self setNeedsDisplay];
}

/**
 *  @brief 设置键盘
 */
- (void)setUpMyKeyBoard
{
    //输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kWidth - kWidth/3/2, kWidth/3/2)];
    textField.delegate = self;
    textField.placeholder = @"请输入密码";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.secureTextEntry = YES;
    textField.backgroundColor = [UIColor whiteColor];
    [self addSubview:textField];
    self.keyboardTextField = textField;
    
    //删除按钮
    UIButton *deleteButton = [[UIButton alloc] init];
    deleteButton.frame = CGRectMake(CGRectGetMaxX(textField.frame), 0, kWidth/3/2, kWidth/3/2);
    [deleteButton setImage:[UIImage imageNamed:@"ic_keyboard_delete"] forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor whiteColor];
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    self.deleteButton = deleteButton;
    
    //键盘按钮
    NSInteger index = 0;
    for (NSInteger i = 0; i < 4; i++) {
        for (NSInteger j = 0; j < 3; j++) {
            UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            numberBtn.frame = CGRectMake(kWidth/3*j, kWidth/3/2*(i + 1), kWidth/3, kWidth/3/2);
            
            numberBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            numberBtn.tag = 1000+index;
            
            if (numberBtn.tag == 1008) {
                [numberBtn setTitle:@"确定" forState:UIControlStateNormal];
            }else if (numberBtn.tag == 1011){
                [numberBtn setTitle:@"关闭" forState:UIControlStateNormal];
            }else{
                [self.nuberButtonArray addObject:numberBtn];
            }
            
            //文字颜色
            [numberBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            //设置背景图片
            [numberBtn setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_normal"] forState:UIControlStateNormal];
            [numberBtn setBackgroundImage:[UIImage imageNamed:@"ic_keyboard_pressed"] forState:UIControlStateHighlighted];
            
            //键盘格子的分隔线
            [self drawActionWithBtn:numberBtn];
            
            //键盘点击事件
            [numberBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:numberBtn];
            
            index++;
        }
        
    }
    
    [self resetKeyboardNumber];
}

/**
 *  @brief 设置数字按钮的文字（随机）
 */
- (void)resetKeyboardNumber{
    //取出数字数组
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.numberArray];
    
    //给数字按钮设置数字
    [self.nuberButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = (UIButton *)obj;
        //键盘文字(每次键盘弹出都要随机显示数字)
        NSString *text;
        if (tempArray.count > 0) {
            text = tempArray[arc4random() % tempArray.count];
        }
            [button setTitle:text forState:UIControlStateNormal];
            [tempArray removeObject:text];
    }];
}

- (void)hideKeyboard{
    [UIView animateWithDuration:0.4 animations:^{
        self.hidden = YES;
        [modelView removeFromSuperview];
    }];
}

#pragma mark - 按钮点击事件
/**
 *  @brief 键盘点击事件
 *
 */
- (void)clickAction:(UIButton *)button
{
    //高亮
    [button setHighlighted:YES];
    
    //如果不是删除和完成
    if (!(button.tag == 1008 || button.tag == 1011)) {
        if (self.keyboardTextField.text.length != 6) {//限定输入6位密码
           self.keyboardTextField.text = [NSString stringWithFormat:@"%@%@", self.keyboardTextField.text, button.titleLabel.text];
        }
        
    }else{
        if (button.tag == 1008) {
            //点击完成隐藏键盘
            if (self.keyboardTextField.text.length > 0) {
                //通知代理
                if ([self.delegate respondsToSelector:@selector(passValueWithText:)]) {
                    [self.delegate passValueWithText:self.keyboardTextField.text];
                    [self hideKeyboard];
                }
            }
        }
        else
        {
        //点击关闭按钮
        [self hideKeyboard];
        }
    }
}

/**
 *  @brief 点击删除按钮
 */
- (void)deleteButtonClick{
    // 删掉最后一个字符
    if ([self.keyboardTextField.text length] != 0) {
        self.keyboardTextField.text = [self.keyboardTextField.text substringToIndex:([self.keyboardTextField.text length] - 1)];
    }
}

// 划线方法
- (void)drawActionWithBtn:(UIButton *)sender
{
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    if (sender.tag < 1009) {
        [bottomPath moveToPoint:CGPointMake(0, CGRectGetHeight(sender.frame))];
        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(sender.frame), CGRectGetHeight(sender.frame))];
        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(sender.frame), 0)];
        if (sender.tag < 1003) {
            [bottomPath addLineToPoint:CGPointMake(0, 0)];
        }
    }else{
        [bottomPath moveToPoint:CGPointMake(CGRectGetWidth(sender.frame), 0)];
        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(sender.frame), CGRectGetHeight(sender.frame))];
                                            
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = sender.bounds;
    layer.position = CGPointMake(sender.frame.size.width/2, sender.frame.size.height/2);
    layer.strokeColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = bottomPath.CGPath;
    [sender.layer addSublayer:layer];
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return NO;
}

@end
