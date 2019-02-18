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
    if ([VaultSDK shared].isLoggedIn) {
        [[VaultSDK shared] getUserInformationWithCallback:^(UserInfo *userInformation, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
                return;
            }
            
            NSLog(@"%@", userInformation);
        }];
        
        [[VaultSDK shared] getClientInformationWithCallback:^(NSArray<Balance *> *balances, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
                return;
            }
            
            NSLog(@"%@", balances);
        }];
        
        [[VaultSDK shared] getUserMiningActionWithCallback:^(NSArray<MiningActivity *> *miningActivities, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
                return;
            }
            
            NSLog(@"%@", miningActivities);
        }];
        
        [[VaultSDK shared] postUserMiningActionWithReward:321.987 uuid:[NSUUID UUID] callback:^(BOOL success, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
                return;
            }
            
            NSLog(@"%@", success);
        }];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[VaultSDK shared] loginFrom:self callback:^(NSString *accessToken, NSError * error) {
                if (error != nil) {
                    NSLog(@"%@", error);
                    return;
                }
                
                NSLog(@"%@", accessToken);
            }];
        });
    }
}


@end
