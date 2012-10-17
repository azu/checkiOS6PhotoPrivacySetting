//
//  AZViewController.h
//  iOS6PhotoPrivacy
//
//  Created by azu on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
}

@property(weak, nonatomic) IBOutlet UILabel *authorizationStatusLabel;

- (IBAction)pressAlbumButton:(id)sender;
@end