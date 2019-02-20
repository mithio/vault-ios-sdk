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
@property (weak, nonatomic) IBOutlet UIButton *loginWithVaultButton;
@property (weak, nonatomic) IBOutlet UIButton *getUserInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *getClientInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *getUserMiningActionButton;
@property (weak, nonatomic) IBOutlet UIButton *postUserMiningActionButton;
@property (weak, nonatomic) IBOutlet UITextField *rewardTextField;
@property (weak, nonatomic) IBOutlet UIButton *unbindVaultButton;
@property (weak, nonatomic) IBOutlet UIButton *clearConsoleButton;
@property (weak, nonatomic) IBOutlet UITextView *consoleTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rewardTextField.placeholder = @"0.12345678";
    self.rewardTextField.keyboardType = UIKeyboardTypeDecimalPad;
    if ([[VaultSDK shared] isLoggedIn]) {
        self.consoleTextView.text = [NSString stringWithFormat:@"User is already logged in with access token, %@\n\n", [[VaultSDK shared] accessToken]];
    } else {
        self.consoleTextView.text = @"Please log in with VAULT.\n\n";
    }
    self.consoleTextView.editable = false;
    self.consoleTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.consoleTextView.layer.borderWidth = 0.5;
    self.consoleTextView.layer.cornerRadius = 8;
    self.consoleTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self updateUI];
}

- (void) updateUI {
    BOOL isLoggedIn = [[VaultSDK shared] isLoggedIn];
    self.loginWithVaultButton.enabled = !isLoggedIn;
    self.getUserInfoButton.enabled = isLoggedIn;
    self.getClientInfoButton.enabled = isLoggedIn;
    self.getUserMiningActionButton.enabled = isLoggedIn;
    self.postUserMiningActionButton.enabled = isLoggedIn;
    self.rewardTextField.enabled = isLoggedIn;
    self.unbindVaultButton.enabled = isLoggedIn;
}

- (IBAction)loginWithVault:(UIButton *)sender {
    [[VaultSDK shared] loginFrom:self callback:^(NSString *accessToken, NSError * error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        self.consoleTextView.text = [self.consoleTextView.text stringByAppendingString: [NSString stringWithFormat:@"Successfully logged in, got access token, %@.\n\n", accessToken]];
        [self updateUI];
    }];
}

- (IBAction)getUserInformation:(UIButton *)sender {
    [[VaultSDK shared] getUserInformationWithCallback:^(UserInfo *userInfo, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        self.consoleTextView.text = [self.consoleTextView.text stringByAppendingString: [NSString stringWithFormat:@"User information: %@\n\n", userInfo]];
    }];
}

- (IBAction)getClinetInformation:(UIButton *)sender {
    [[VaultSDK shared] getClientInformationWithCallback:^(NSArray<Balance *> *balances, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        self.consoleTextView.text = [self.consoleTextView.text stringByAppendingString: [NSString stringWithFormat:@"Client information: %@\n\n", balances]];
    }];
}

- (IBAction)getUserMiningAction:(UIButton *)sender {
    [[VaultSDK shared] getUserMiningActionWithCallback:^(NSArray<MiningActivity *> *miningActivities, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        self.consoleTextView.text = [self.consoleTextView.text stringByAppendingString: [NSString stringWithFormat:@"Mining activities: %@\n\n", miningActivities]];
    }];
}

- (IBAction)postUserMingingAction:(UIButton *)sender {
    double reward = [[self.rewardTextField text] doubleValue];
    [[VaultSDK shared] postUserMiningActionWithReward:reward uuid:[NSUUID UUID].UUIDString callback:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        [self.rewardTextField resignFirstResponder];
        self.rewardTextField.text = nil;
        self.consoleTextView.text = [self.consoleTextView.text stringByAppendingString: [NSString stringWithFormat:@"Successfully post user mining action with reward, %f.\n\n", reward]];
    }];
}
- (IBAction)unbindVault:(UIButton *)sender {
    NSString *accessToken = [[VaultSDK shared] accessToken];
    [[VaultSDK shared] unbindWithCallback:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        self.consoleTextView.text = [self.consoleTextView.text stringByAppendingString: [NSString stringWithFormat:@"Successfully unbind access token, %@.\n\n", accessToken]];
    }];
}

- (IBAction)clearConsle:(UIButton *)sender {
    self.consoleTextView.text = @"";
}

@end
