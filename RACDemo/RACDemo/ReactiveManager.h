//
//  ReactiveManager.h
//  RACDemo
//
//  Created by Justin on 2018/2/17.
//  Copyright © 2018年 Justin. All rights reserved.
//
#import <Foundation/Foundation.h>


typedef void(^SignInResposse)(BOOL isSuccess);

@interface ReactiveManager : NSObject

+ (void)signInWithUsername:(NSString *)username
                  Password:(NSString *)password
           CompleteHandler:(SignInResposse)signInBlock;

@end
