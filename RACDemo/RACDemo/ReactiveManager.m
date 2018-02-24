//
//  ReactiveManager.m
//  RACDemo
//
//  Created by Justin on 2018/2/17.
//  Copyright © 2018年 Justin. All rights reserved.
//






#import "ReactiveManager.h"

@implementation ReactiveManager

+ (void)signInWithUsername:(NSString *)username
                  Password:(NSString *)password
           CompleteHandler:(SignInResposse)signInBlock {
    
    if ([username isEqualToString:@"123"] && [password isEqualToString:@"456"])
    {
        if (signInBlock) {
            signInBlock(YES);
        }
    }
    else
    {
        if (signInBlock) {
            signInBlock(NO);
        }
    }
}

@end
