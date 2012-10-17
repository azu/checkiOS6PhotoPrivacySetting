//
//  AZViewController.m
//  iOS6PhotoPrivacy
//
//  Created by azu on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "AZViewController.h"

@interface AZViewController ()

@end

@implementation AZViewController


- (void)updateAuthorizationStatus {
    // require AssetsLibrary.framework
    /*
    typedef NS_ENUM(NSInteger, ALAuthorizationStatus) {
        ALAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
        ALAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
                                                // The user cannot change this application’s status, possibly due to active restrictions
                                                //  such as parental controls being in place.
        ALAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
        ALAuthorizationStatusAuthorized         // User has authorized this application to access photos data.
    } __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);

     */
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    // ALAuthorizationStatusRestricted : ペアレンタルコントロール等で使えない
    // ALAuthorizationStatusDenied : プライバシーの設定で写真のアクセスが拒否されている

    NSString *labelText = nil;
    if (status == ALAuthorizationStatusNotDetermined){
        labelText = @"まだ許可ダイアログ出たことない";
    } else if (status == ALAuthorizationStatusRestricted){
        labelText = @"機能制限(ペアレンタルコントロール)で許可されてない";
    } else if (status == ALAuthorizationStatusDenied){
        labelText = @"許可ダイアログで\"いいえ\"が押されています\n"
            "設定アプリ -> プライバシー > 写真 -> 該当アプリを\"オン\"する必要があります";
    } else if (status == ALAuthorizationStatusAuthorized){
        labelText = @"写真へのアクセスが許可されています";
    }
    self.authorizationStatusLabel.text = labelText;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateAuthorizationStatus];
}

- (IBAction)pressAlbumButton:(id)sender {
    // Photo Libraryが使えるかをチェックする
    if ([self isAvailablePhotoLibrary]){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"photo library invalid.");
    }
}

- (BOOL)isAvailablePhotoLibrary {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma mark - UIImagePicker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPicker:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissPicker:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image
        editingInfo:(NSDictionary *)editingInfo {
    [self dismissPicker:picker];
}

- (void)dismissPicker:(UIImagePickerController *)picker {
    __weak AZViewController *that = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [that updateAuthorizationStatus];
    }];
}

@end