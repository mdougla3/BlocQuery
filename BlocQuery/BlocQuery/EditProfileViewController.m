//
//  EditProfileViewController.m
//  BlocQuery
//
//  Created by McCay Barnes on 11/9/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UIImage+Sizing.h"


@interface EditProfileViewController () <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (weak, nonatomic) UIImage *selectedProfilePicture;

@property (strong, nonatomic) PFFile *imageFile;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecogizer;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.user) {
        self.user = [PFUser currentUser];
        self.tapGestureRecogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
        self.profilePictureImage.userInteractionEnabled = YES;
        [self.profilePictureImage addGestureRecognizer:self.tapGestureRecogizer];
    }
    else {
        self.aboutMeTextView.editable = false;
    }
    
    PFFile *userImageFile = self.user[@"photo"];
    self.aboutMeTextView.text = self.user[@"imageDescription"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.profilePictureImage.image = image;
        }
        else if (imageData == nil)
        {
            self.profilePictureImage.image = [UIImage imageNamed:@"ProfilePic.jpg"];
        }
    }];
    
    if (self.user[@"name"] != nil) {
        self.nameTextField.alpha = 0.0;
        self.nameLabel.text = self.user[@"name"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeImage:(UITapGestureRecognizer *)sender {
    
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    imagePC.delegate = self;
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.allowsEditing = YES;
    [self presentViewController:imagePC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    if (!selectedImage) {
        selectedImage = info[UIImagePickerControllerOriginalImage];
        self.selectedProfilePicture = selectedImage;
    }
    
    [self savePhotoToParse:selectedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.profilePictureImage.image = selectedImage;
    }];
}


-(void) savePhotoToParse:(UIImage *)image {

    image = [UIImage imageWithImage:image scaledToWidth:400];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    PFFile *profilePictureFile = [PFFile fileWithData:imageData];
    [profilePictureFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.user setObject:profilePictureFile forKey:@"photo"];
            [self.user saveInBackground];
        }
    }];
    
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    self.user[@"imageDescription"] = self.aboutMeTextView.text;
    self.user[@"name"] = self.nameTextField.text;
    [self.user saveEventually];

    [self savePhotoToParse:self.selectedProfilePicture];
    
}



@end
