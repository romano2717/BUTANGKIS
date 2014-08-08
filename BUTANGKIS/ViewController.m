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

#import "MyPageViewController.h"
#import "PageViewControllerData.h"

#import "CreateMemeViewController.h"


@interface ViewController ()
    @property (nonatomic, strong) ALAssetsGroup *groupAsset;
    @property (nonatomic, strong) NSMutableArray *assets;
@end

NSString *k_album = @"BUTANGKIS";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self enumerateAsset];
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
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //camera roll. NOT YET SUPPORTED FOR NOW!
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
            
            [self.library saveImage:image toAlbum:k_album completion:^(NSURL *assetURL, NSError *error) {
                [self cleanUpAssetAndGroup];
                [self enumerateAsset];
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
        
        [self.library saveImage:takenImage toAlbum:k_album completion:^(NSURL *assetURL, NSError *error) {
        
            //[self cleanUpAssetAndGroup];
            //[self enumerateAsset];
            
            [picker dismissViewControllerAnimated:NO completion:NULL];
            
            [self createMeme:takenImage];
        
        } failure:^(NSError *error) {
            DDLogVerbose(@"Saving image failed: %@",error);
        }];
    }
}


-(void)cleanUpAssetAndGroup
{
    _library = nil;
    _assets = nil;
}

-(void)enumerateAsset
{
    if (self.library == nil) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    if (self.assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    
    // emumerate through our groups and look for k_album
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:k_album])
            {
                self.groupAsset = group;
            }
        }
        else
        {
            [self prepareAssets];
        }
    };
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [self.library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        if(error)
            DDLogVerbose(@"enumeration failed %@",error);
    }];
}

-(void)prepareAssets
{
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
        }
        else
        {
            NSArray *reversedArray = [[self.assets reverseObjectEnumerator] allObjects];
            self.assets = (NSMutableArray *)reversedArray;
        }
    };
    
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.groupAsset setAssetsFilter:onlyPhotosFilter];
    [self.groupAsset enumerateAssetsUsingBlock:assetsEnumerationBlock];
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"photoCell";
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    
    // apply the image to the cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
    imageView.image = thumbnail;
    
    return cell;
}


#pragma mark - Segue support

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        
        // hand off the assets of this album to our singleton data source
        [PageViewControllerData sharedInstance].photoAssets = self.assets;
        
        // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController = [segue destinationViewController];
        NSIndexPath *selectedCell = [self.collectionView indexPathsForSelectedItems][0];
        pageViewController.startingIndex = selectedCell.row;
    }
}

-(void)createMeme:(UIImage *)image
{
    CreateMemeViewController *createMeme = [[CreateMemeViewController alloc] init];
    createMeme.image = image;
    
    [self presentViewController:createMeme animated:YES completion:nil];
}

@end
