//
//  KeyBoardView.h
//  MyKeyboardDemo
//
//  Created by laitang on 16/4/28.
//  Copyright © 2016年 laitang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardViewDelegate <NSObject>

@optional
- (void)passValueWithText:(NSString *)text;

@end

@interface KeyBoardView : UIView

@property (nonatomic, assign)id<KeyBoardViewDelegate> delegate;

- (void)showInViewController:(UIViewController *)controller;
- (void)showInView:(UIView *)view;

@end
