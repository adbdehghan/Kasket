//
//  ProfileViewController.h
//  Wash Me
//
//  Created by adb on 12/18/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
{


}
@property (weak, nonatomic) IBOutlet UIButton *SaveUIButton;
@property (weak, nonatomic) IBOutlet UITextField *nameUITextField;
@property (weak, nonatomic) IBOutlet UITextField *emailUITextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordUITextField;
@property (weak, nonatomic) IBOutlet UIView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *topUIView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;
@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEnterDate;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDone:(id)sender;
@end
