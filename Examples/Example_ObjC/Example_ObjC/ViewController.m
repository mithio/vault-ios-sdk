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

@property(nonatomic, strong) VaultSDK *sdk;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sdk = [[VaultSDK alloc] init];
    [self.sdk loginFrom:self callback:^(NSString *accessToken, NSError * error) {
        NSLog(@"%@", accessToken);
        [self.sdk unbindWithAccessToken:accessToken callback:^(BOOL success) {
            NSLog(@"%@", success ? @"YES" : @"NO");
        }];
    }];
}


@end
