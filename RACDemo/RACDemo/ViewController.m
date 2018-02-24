//
//  ViewController.m
//  RACDemo
//
//  Created by Justin on 2018/2/14.
//  Copyright © 2018年 Justin. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ReactiveManager.h"



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    // 用户名输入框返回 NSNumber
    RACSignal *validUserNameSingle = [self.userNameTextfield.rac_textSignal map:^id(NSString *userNameValue) {
        return @([self isValidStr:userNameValue]);
    }];
    
    // 密码输入框返回 NSNumber
    RACSignal *validPasswordSingle = [self.passwordTextfield.rac_textSignal map:^id(NSString *passwordValue) {
        return @([self isValidStr:passwordValue]);
    }];
    
    // 控制输入框的背景颜色
    RAC(self.userNameTextfield,backgroundColor) = [validUserNameSingle map:^id(NSNumber *usernameValue) {
        return [usernameValue boolValue] ? [UIColor orangeColor] : [UIColor lightGrayColor];
    }];
    
    RAC(self.passwordTextfield,backgroundColor) = [validPasswordSingle map:^id(NSNumber *passwordValue) {
        return [passwordValue boolValue] ? [UIColor orangeColor] : [UIColor lightGrayColor];
    }];
    
    // 将两个信号合并，控制登录按钮的状态
    [[RACSignal
      combineLatest:@[validUserNameSingle,validPasswordSingle]
      reduce:^id(NSNumber *usernameValue,NSNumber *passwordValue){
        return @([usernameValue boolValue] && [passwordValue boolValue]);
    }]
      subscribeNext:^(NSNumber *enableValue) {
        self.LoginButton.enabled = [enableValue boolValue];
    }];

    [[[[self.LoginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       
       doNext:^(id x) {
           
           NSLog(@"点击了登录按钮");
           self.LoginButton.enabled = NO;
           
           [NSThread sleepForTimeInterval:3.0];
           
      }]
      
       flattenMap:^RACStream *(id value) {
           
          return [self signinSingle];
      }]
     
       subscribeNext:^(NSNumber *signIn) {
          
           BOOL success = [signIn boolValue];
           
           if (success)
           {
               NSLog(@"Login Success");
               self.LoginButton.enabled = YES;
           }
           else{
               NSLog(@"Login Fail");
           }
      }];
    
}

// 登录信号
- (RACSignal *)signinSingle {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [ReactiveManager signInWithUsername:self.userNameTextfield.text
                                   Password:self.passwordTextfield.text
                            CompleteHandler:^(BOOL isSuccess) {
                                
                                [subscriber sendNext:@(isSuccess)];
                                [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)isValidStr:(NSString *)str
{
    return str.length > 0;
}

@end
