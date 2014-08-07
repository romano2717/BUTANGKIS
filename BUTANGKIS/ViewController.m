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
#import "ALAssetsLibrary+CustomAlbum.h"


@interface ViewController ()
    @property (nonatomic, strong) NSMutableArray *imagesArray;
    @property (nonatomic, weak) IBOutlet UIScrollView *imagesScrollView;
@end

NSString *k_album = @"BUTANGKIS";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.library = [[ALAssetsLibrary alloc] init];
    
    self.imagesArray = [[NSMutableArray alloc] init];
    
    [self loadSavedImges];
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
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) //camera roll
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
            
            /*[self.library saveImage:lowResImage toAlbum:k_album withCompletionBlock:^(NSError *error) {
                if (error!=nil) {
                    NSLog(@"Big error: %@", [error description]);
                }
            }];*/
            
            [self.library saveImage:lowResImage toAlbum:k_album completion:^(NSURL *assetURL, NSError *error) {
                
            } failure:^(NSError *error) {
                
            }];
        };
        
        // get the asset library and fetch the asset based on the ref url (pass in block above)
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    }
    else //camera
    {
        UIImage *takenImage=info[UIImagePickerControllerOriginalImage];
        
        UIImage *lowResImage = [takenImage resizedImageToFitInSize:CGSizeMake(320, 480) scaleIfSmaller:YES];
        
        /*[self.library saveImage:lowResImage toAlbum:k_album withCompletionBlock:^(NSError *error) {
            if (error!=nil) {
                NSLog(@"Big error: %@", [error description]);
            }
        }];*/
        
        [self.library saveImage:lowResImage toAlbum:k_album completion:^(NSURL *assetURL, NSError *error) {
            
            [self loadSavedImges];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)cleanGallery
{
    [self.imagesArray removeAllObjects];
    for (UIView *subView in [self.imagesScrollView subviews]) {
        if([subView isKindOfClass:[UIScrollView class]])
        {
            [subView removeFromSuperview];
        }
    }
}

-(void)loadSavedImges
{

    [self.library loadImagesFromAlbum:k_album completion:^(NSMutableArray *images, NSError *error) {
        NSArray *reversedArray = [[images reverseObjectEnumerator] allObjects];
        
        self.imagesArray = (NSMutableArray *)reversedArray;
        
        [self drawGallery];

    }];
}


-(void)drawGallery
{
    int thumbNalilSize = 140;
    
    int lastYPos = 0;
    
    CGRect frame;
    
    int nthTile = 1;
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        
        if(nthTile == 1)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            frame.origin.x = 0;
            frame.origin.y = lastYPos;
            frame.size.height = thumbNalilSize;
            frame.size.width = thumbNalilSize;
            
            imageView.frame = frame;
            
            UIImage *img = (UIImage *)[self.imagesArray objectAtIndex:i];
            imageView.image = [img imageWithImage:img scaledToFillSize:CGSizeMake(thumbNalilSize, thumbNalilSize)];
            
            [self.imagesScrollView addSubview:imageView];
            
            nthTile++;
        }
        else if (nthTile == 2)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            frame.origin.x = 108;
            frame.origin.y = lastYPos;
            frame.size.height = thumbNalilSize;
            frame.size.width = thumbNalilSize;
            
            imageView.frame = frame;
            
            UIImage *img = (UIImage *)[self.imagesArray objectAtIndex:i];
            imageView.image = [img imageWithImage:img scaledToFillSize:CGSizeMake(thumbNalilSize, thumbNalilSize)];
            
            [self.imagesScrollView addSubview:imageView];
            
            nthTile++;
        }
        else if (nthTile == 3)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            frame.origin.x = 216;
            frame.origin.y = lastYPos;
            frame.size.height = thumbNalilSize;
            frame.size.width = thumbNalilSize;
            
            imageView.frame = frame;
            
            UIImage *img = (UIImage *)[self.imagesArray objectAtIndex:i];
            imageView.image = [img imageWithImage:img scaledToFillSize:CGSizeMake(thumbNalilSize, thumbNalilSize)];
            
            [self.imagesScrollView addSubview:imageView];
            
            //reset tile
            nthTile = 1;
            
            //move down tiles to next row
            lastYPos = frame.origin.y + thumbNalilSize + 4;
        }
        
        //adjust scrollview
        if(lastYPos > self.imagesScrollView.frame.size.height)
        {
            self.imagesScrollView.contentSize = CGSizeMake(self.imagesScrollView.frame.size.width, lastYPos + thumbNalilSize);
        }
    }
}

@end
