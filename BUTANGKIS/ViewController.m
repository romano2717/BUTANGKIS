//
//  ViewController.m
//  BUTANGKIS
//
//  Created by Diffy Romano on 5/8/14.
//  Copyright (c) 2014 Diffy Romano. All rights reserved.
//

#import "ViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Resize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)openCamera:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        // get the ref url
        NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        // define the block to call when we get the asset based on the url (below)
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
        {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            
            // Retrieve the image orientation from the ALAsset
            UIImageOrientation orientation = UIImageOrientationUp;
            NSNumber* orientationValue = [imageAsset valueForProperty:@"ALAssetPropertyOrientation"];
            if (orientationValue != nil) {
                orientation = [orientationValue intValue];
            }
            
            UIImage *image = [UIImage imageWithCGImage:[imageRep fullResolutionImage] scale:1.0 orientation:orientation];
            UIImage *lowResImage = [image resizedImageToFitInSize:CGSizeMake(320, 480) scaleIfSmaller:YES];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            // Request to save the image to camera roll
            [library writeImageToSavedPhotosAlbum:[lowResImage CGImage] orientation:(ALAssetOrientation)[lowResImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                } else {
                    DDLogVerbose(@"[imageRep filename] : %@", assetURL);
                }
            }];
        };
        
        // get the asset library and fetch the asset based on the ref url (pass in block above)
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    }
    else
    {
        UIImage *takenImage=info[UIImagePickerControllerOriginalImage];
        
        UIImage *lowResImage = [takenImage resizedImageToFitInSize:CGSizeMake(320, 480) scaleIfSmaller:YES];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[lowResImage CGImage] orientation:(ALAssetOrientation)[lowResImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
            } else {
                DDLogVerbose(@"[imageRep filename] : %@", assetURL);
            }
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
