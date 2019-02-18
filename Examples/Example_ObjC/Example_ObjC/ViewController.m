//
//  ViewController.m
//  Example_ObjC
//
//  Created by Alex Huang on 2019/2/15.
//  Copyright © 2019 Mithril Ltd. All rights reserved.
//

#import "ViewController.h"
@import VaultSDK;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[VaultSDK shared] loginFrom:self callback:^(NSString *accessToken, NSError * error) {
        NSLog(@"%@", accessToken);
        [[VaultSDK shared] unbindWithAccessToken:accessToken callback:^(BOOL success) {
            NSLog(@"%@", success ? @"YES" : @"NO");
        }];
    }];
}


@end
